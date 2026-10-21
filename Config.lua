-- Ventanas: la lista de rotaciones de tu clase (con su prioridad explicada), el editor de texto
-- y la tabla de resultados del laboratorio.
local _, ns = ...
ns = ns or TacticsCoachNS
local Config = {}
ns.Config = Config

local ROWS = 14
local main, editor, results
local selected, offset = nil, 0

local function button(parent, text, width, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetWidth(width)
  b:SetHeight(22)
  b:SetText(text)
  b:SetScript("OnClick", onClick)
  return b
end

local function window(name, width, height, titleText)
  local f = CreateFrame("Frame", name, UIParent)
  f:SetWidth(width)
  f:SetHeight(height)
  f:SetPoint("CENTER")
  f:SetFrameStrata("DIALOG")
  f:SetToplevel(true)
  f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
  })
  f:EnableMouse(true)
  f:SetMovable(true)
  f:SetClampedToScreen(true)
  f:SetScript("OnShow", ns.fitToScreen)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  f.title:SetPoint("TOP", 0, -18)
  f.title:SetText(titleText)
  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)
  tinsert(UISpecialFrames, name)
  f:Hide()
  return f
end

local function panel(parent)
  local p = CreateFrame("Frame", nil, parent)
  p:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  p:SetBackdropColor(0, 0, 0, 0.6)
  return p
end

local function selectedRot() return selected and ns.Library.all[selected] end

local function bestFor(id)
  local best, me = nil, UnitName("player")
  for _, r in ipairs(ns.db.results) do
    if r.rot == id and r.char == me and (not best or r.dps > best) then best = r.dps end
  end
  return best
end

-- La prioridad en palabras: es lo que se aprende.
local function describe(rot)
  local L = ns.L
  local tag = rot.modified and L.tagBuiltinEdited or rot.builtin and L.tagBuiltin or ""
  local lines = {
    "|cffffd100" .. rot.name .. "|r" .. (tag ~= "" and ("  |cff888888" .. tag .. "|r") or ""),
    L.authorLine:format(rot.author or "?", rot.spec or L.noSpec),
  }
  if rot.description then lines[#lines + 1] = "|cffcccccc" .. rot.description .. "|r" end
  lines[#lines + 1] = " "
  lines[#lines + 1] = L.priorityTitle
  for i, act in ipairs(rot.actions) do
    local id = rot.spells[act.key]
    local name = ns.State.spellName(id) or act.key
    local known = ns.State.isKnown(name)
    local line = ("%d. %s%s|r"):format(i, known and "|cffffffff" or "|cff777777", name)
    if act.note then
      line = line .. " — " .. act.note
    elseif act.condText then
      line = line .. " |cff888888" .. L.ifWord .. " " .. act.condText .. "|r"
    end
    lines[#lines + 1] = line
  end
  local best = bestFor(rot.id)
  if best then
    lines[#lines + 1] = " "
    lines[#lines + 1] = L.bestRun:format(ns.fmt(best))
  end
  return table.concat(lines, "\n")
end

---------------------------------------------------------------------------------------------------
-- Editor de texto

local function editorErrors(errs)
  editor.err:SetText("|cffff5555" .. ns.Format.formatErrors(errs) .. "|r")
end

local function buildEditor()
  local L = ns.L
  editor = window("TacticsCoachEditor", 560, 470, L.editRotation)
  local bg = panel(editor)
  bg:SetPoint("TOPLEFT", 18, -44)
  bg:SetPoint("BOTTOMRIGHT", -18, 96)

  local sf = CreateFrame("ScrollFrame", "TacticsCoachEditorScroll", bg, "UIPanelScrollFrameTemplate")
  sf:SetPoint("TOPLEFT", 8, -8)
  sf:SetPoint("BOTTOMRIGHT", -28, 8)
  local eb = CreateFrame("EditBox", nil, sf)
  eb:SetMultiLine(true)
  eb:SetAutoFocus(false)
  eb:SetFontObject(ChatFontNormal)
  eb:SetWidth(480)
  eb:SetScript("OnEscapePressed", eb.ClearFocus)
  eb:SetScript("OnTextChanged", function(self) ScrollingEdit_OnTextChanged(self, sf) end)
  eb:SetScript("OnCursorChanged", ScrollingEdit_OnCursorChanged)
  eb:SetScript("OnUpdate", function(self, elapsed) ScrollingEdit_OnUpdate(self, elapsed, sf) end)
  sf:SetScrollChild(eb)
  bg:EnableMouse(true)
  bg:SetScript("OnMouseDown", function() eb:SetFocus() end)
  editor.eb = eb

  editor.err = editor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  editor.err:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 4, -6)
  editor.err:SetPoint("RIGHT", editor, "RIGHT", -20, 0)
  editor.err:SetHeight(48)
  editor.err:SetJustifyH("LEFT")
  editor.err:SetJustifyV("TOP")

  editor.check = button(editor, L.check, 110, function()
    local rot, errs = ns.Library.build(eb:GetText(), false)
    if rot then
      editor.err:SetText("|cff00ff00" .. L.allGood:format(#rot.actions) .. "|r")
    else
      editorErrors(errs)
    end
  end)
  editor.check:SetPoint("BOTTOMLEFT", 20, 18)

  editor.save = button(editor, L.save, 110, function()
    local rot, errs = ns.Library.save(eb:GetText(), editor.oldId)
    if not rot then return editorErrors(errs) end
    selected = rot.id
    ns.print(L.saved:format(rot.name))
    editor:Hide()
    Config.refresh()
  end)
  editor.save:SetPoint("LEFT", editor.check, "RIGHT", 8, 0)

  local close = button(editor, L.close, 110, function() editor:Hide() end)
  close:SetPoint("BOTTOMRIGHT", -20, 18)
end

-- mode: "edit" (oldId = la que se edita), "new" o "export" (solo para copiar).
local function openEditor(mode, text, oldId)
  local L = ns.L
  if not editor then buildEditor() end
  editor.oldId = oldId
  editor.eb:SetText(text)
  editor.eb:SetCursorPosition(0)
  if mode == "export" then
    editor.title:SetText(L.export)
    editor.err:SetText(L.exportHelp)
    editor.check:Hide()
    editor.save:Hide()
    editor:Show()
    editor.eb:SetFocus()
    editor.eb:HighlightText()
  else
    editor.title:SetText(mode == "new" and L.newRotation or L.editRotation)
    editor.err:SetText(L.pasteHelp)
    editor.check:Show()
    editor.save:Show()
    editor:Show()
  end
end

---------------------------------------------------------------------------------------------------
-- Resultados

local COLUMNS = {
  { "colRotation", 170, "LEFT" }, { "colRuns", 46, "RIGHT" }, { "colAvg", 66, "RIGHT" },
  { "colBest", 60, "RIGHT" }, { "colSd", 46, "RIGHT" }, { "colPet", 70, "RIGHT" },
  { "colTop", 70, "RIGHT" }, { "colAdherence", 56, "RIGHT" }, { "colGear", 46, "RIGHT" },
}
local RESULT_ROWS = 8

local function cell(parent, row, col)
  local fs = parent:CreateFontString(nil, "OVERLAY", row == 0 and "GameFontNormalSmall" or "GameFontHighlightSmall")
  local x = 24
  for i = 1, col - 1 do x = x + COLUMNS[i][2] + 6 end
  fs:SetPoint("TOPLEFT", x, -48 - row * 18)
  fs:SetWidth(COLUMNS[col][2])
  fs:SetJustifyH(COLUMNS[col][3])
  return fs
end

local function buildResults()
  local L = ns.L
  results = window("TacticsCoachResults", 760, 440, L.resultsTitle)
  results.cells = {}
  for c = 1, #COLUMNS do cell(results, 0, c):SetText(L[COLUMNS[c][1]]) end
  for r = 1, RESULT_ROWS do
    results.cells[r] = {}
    for c = 1, #COLUMNS do results.cells[r][c] = cell(results, r, c) end
  end
  results.note = results:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  results.note:SetPoint("TOPLEFT", 24, -48 - (RESULT_ROWS + 1) * 18)
  results.note:SetPoint("RIGHT", results, "RIGHT", -24, 0)
  results.note:SetJustifyH("LEFT")
  results.note:SetJustifyV("TOP")
  results.note:SetHeight(150)

  local one = button(results, L.test1, 130, function()
    results:Hide()
    ns.Lab.arm(60)
  end)
  one:SetPoint("BOTTOMLEFT", 20, 18)
  local three = button(results, L.test3, 130, function()
    results:Hide()
    ns.Lab.arm(180)
  end)
  three:SetPoint("LEFT", one, "RIGHT", 6, 0)
  local clear = button(results, L.clearResults, 170, function() StaticPopup_Show("TC_CLEAR") end)
  clear:SetPoint("LEFT", three, "RIGHT", 6, 0)
  button(results, L.close, 100, function() results:Hide() end):SetPoint("BOTTOMRIGHT", -20, 18)
end

local popups

function Config.showResults()
  local L = ns.L
  popups()
  if not results then buildResults() end
  local me = UnitName("player")
  local rows = ns.Lab.summary(me)
  for r = 1, RESULT_ROWS do
    local s, c = rows[r], results.cells[r]
    if s then
      local ilvl = s.ilvlMin and (s.ilvlMin == s.ilvlMax and tostring(s.ilvlMin) or (s.ilvlMin .. "-" .. s.ilvlMax)) or "?"
      -- En verde, la mejor de cada duracion (vienen ordenadas por duracion y luego por DPS).
      local first = (r == 1 or rows[r - 1].target ~= s.target)
      local group = 0
      for _, o in ipairs(rows) do if o.target == s.target then group = group + 1 end end
      c[1]:SetText((first and group > 1 and "|cff00ff00" or "") .. s.name .. " |cff999999· " .. ns.Lab.durationLabel(s.target) .. "|r")
      c[2]:SetText(s.n < 3 and ("|cffff9900" .. s.n .. "|r") or s.n)
      c[3]:SetText(ns.fmt(s.avg))
      c[4]:SetText(ns.fmt(s.best))
      c[5]:SetText(s.sd and ns.fmt(s.sd) or "-")
      c[6]:SetText(s.petDps and s.petDps > 0 and ns.fmt(s.petDps) or "-")
      c[7]:SetText(s.top > 0 and ns.fmt(s.top) or "-")
      c[8]:SetText(s.adherence and (math.floor(s.adherence * 100 + 0.5) .. "%") or "-")
      c[9]:SetText(ilvl)
    else
      for i = 1, #COLUMNS do c[i]:SetText("") end
    end
  end

  local lines = {}
  if #rows == 0 then
    lines[1] = L.noResults
  else
    lines[1] = L.resultsHint
    local last = ns.Lab.last(me)
    if last then
      local spells = {}
      for name, dmg in pairs(last.spells) do spells[#spells + 1] = { name, dmg } end
      table.sort(spells, function(a, b) return a[2] > b[2] end)
      lines[#lines + 1] = " "
      lines[#lines + 1] = L.lastRun:format(last.rotName, last.date, ns.fmt(last.dps), math.floor(last.dur), last.talents or "?")
      local detail = ns.Meter.detailText(last, last.dur)
      if detail ~= "" then lines[#lines + 1] = "   " .. detail:gsub("\n", "\n   ") end
      for i = 1, math.min(6, #spells) do
        lines[#lines + 1] = ("   %s: %s (%d%%)"):format(spells[i][1], ns.fmt(spells[i][2]), math.floor(spells[i][2] * 100 / last.dmg + 0.5))
      end
    end
  end
  results.note:SetText(table.concat(lines, "\n"))
  results:Show()
end

---------------------------------------------------------------------------------------------------
-- Ventana principal

local function rows() return ns.Library.forClass(ns.playerClass) end

function Config.refresh()
  local L = ns.L
  if not main or not main:IsShown() then return end
  local list = rows()
  local active = ns.Library.active()
  if not selectedRot() or selectedRot().class ~= ns.playerClass then
    selected = active and active.id or (list[1] and list[1].id)
  end
  offset = math.max(0, math.min(offset, #list - ROWS))
  for i = 1, ROWS do
    local row, rot = main.rows[i], list[i + offset]
    if rot then
      row.rotId = rot.id
      row.text:SetText((active and active.id == rot.id and "|cff00ff00» |r" or "   ") .. rot.name
        .. (rot.mode == "pvp" and " |cffff6060PvP|r" or ""))
      if rot.id == selected then row:LockHighlight() else row:UnlockHighlight() end
      row:Show()
    else
      row:Hide()
    end
  end

  local rot = selectedRot()
  main.detail:SetText(rot and describe(rot) or L.noRotations)
  for _, b in ipairs(main.needRot) do
    if rot then b:Enable() else b:Disable() end
  end
  -- Las tuyas se borran; las de fabrica que editaste se restauran; las de fabrica intactas, nada.
  if rot and rot.builtin then
    main.delete:SetText(L.restore)
    if rot.modified then main.delete:Enable() else main.delete:Disable() end
  else
    main.delete:SetText(L.delete)
    if rot then main.delete:Enable() else main.delete:Disable() end
  end
  if rot and active and rot.id == active.id then main.use:Disable() end
end

local function buildMain()
  local L = ns.L
  main = window("TacticsCoachConfig", 700, 490, "Tactics Coach")
  main:HookScript("OnShow", Config.refresh)
  local options = button(main, L.options, 90, function()
    main:Hide()
    ns.Options.open()
  end)
  options:SetPoint("TOPLEFT", 18, -14)
  local lang = ns.Options.languageMenu(main, "TacticsCoachMainLanguage")
  lang:SetPoint("TOPRIGHT", -40, -10) -- a la izquierda de la X de cerrar

  local listBg = panel(main)
  listBg:SetPoint("TOPLEFT", 18, -44)
  listBg:SetWidth(230)
  listBg:SetHeight(ROWS * 20 + 12)
  listBg:EnableMouseWheel(true)
  listBg:SetScript("OnMouseWheel", function(_, delta)
    offset = offset - delta
    Config.refresh()
  end)
  main.rows = {}
  for i = 1, ROWS do
    local row = CreateFrame("Button", nil, listBg)
    row:SetWidth(216)
    row:SetHeight(20)
    row:SetPoint("TOPLEFT", 7, -6 - (i - 1) * 20)
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", 4, 0)
    row.text:SetPoint("RIGHT", -4, 0)
    row.text:SetJustifyH("LEFT")
    row:SetScript("OnClick", function(self)
      selected = self.rotId
      Config.refresh()
    end)
    main.rows[i] = row
  end

  local detailBg = panel(main)
  detailBg:SetPoint("TOPLEFT", listBg, "TOPRIGHT", 8, 0)
  detailBg:SetPoint("BOTTOMRIGHT", main, "TOPRIGHT", -18, -44 - ROWS * 20 - 12)
  main.detail = detailBg:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  main.detail:SetPoint("TOPLEFT", 10, -10)
  main.detail:SetPoint("BOTTOMRIGHT", -10, 10)
  main.detail:SetJustifyH("LEFT")
  main.detail:SetJustifyV("TOP")

  -- Cuatro columnas que caben de borde a borde (700 - 2 x 20 de margen).
  local W = 160
  local function grid(row, col, text, onClick)
    local b = button(main, text, W, onClick)
    b:SetPoint("BOTTOMLEFT", 20 + (col - 1) * (W + 6), 18 + (4 - row) * 26)
    return b
  end

  main.use = grid(1, 1, L.useThis, function()
    ns.char.active = selected
    Config.refresh()
  end)
  local test1 = grid(1, 2, L.test1, function()
    ns.char.active = selected
    main:Hide()
    ns.Lab.arm(60)
  end)
  local test3 = grid(1, 3, L.test3, function()
    ns.char.active = selected
    main:Hide()
    ns.Lab.arm(180)
  end)
  grid(1, 4, L.results, Config.showResults)

  grid(2, 1, L.new, function()
    main:Hide()
    ns.Builder.open(nil)
  end)
  local dup = grid(2, 2, L.duplicate, function()
    main:Hide()
    ns.Builder.open(selectedRot(), true)
  end)
  main.edit = grid(2, 3, L.edit, function()
    main:Hide()
    ns.Builder.open(selectedRot())
  end)
  main.delete = grid(2, 4, L.delete, function()
    local rot = selectedRot()
    local dialog = StaticPopup_Show(rot.builtin and "TC_RESTORE" or "TC_DELETE", rot.name)
    if dialog then dialog.data = selected end
  end)

  local group = grid(3, 1, L.sendGroup, function() ns.Share.send(selectedRot(), "GROUP") end)
  local guild = grid(3, 2, L.sendGuild, function() ns.Share.send(selectedRot(), "GUILD") end)
  local whisper = grid(3, 3, L.sendTo, function()
    local dialog = StaticPopup_Show("TC_WHISPER", selectedRot().name)
    if dialog then dialog.data = selected end
  end)
  local auto = grid(3, 4, L.automatic, function()
    ns.char.active = nil
    selected = nil
    ns.print(L.autoChosen)
    Config.refresh()
  end)
  grid(4, 1, L.pasteText, function()
    openEditor("new", L.newTemplate:format(ns.playerClass, UnitName("player")))
  end)
  local asText = grid(4, 2, L.editAsText, function() openEditor("edit", selectedRot().text, selected) end)
  grid(4, 3, L.moveIcon, function()
    main:Hide()
    ns.UI.startMove()
  end)
  local export = grid(4, 4, L.export, function() openEditor("export", selectedRot().text) end)
  main.needRot = { main.use, test1, test3, export, dup, main.edit, group, guild, whisper, asText }
  auto:Enable()
end

function popups()
  local L = ns.L
  if StaticPopupDialogs.TC_DELETE then return end
  StaticPopupDialogs.TC_RESTORE = {
    text = L.restoreConfirm,
    button1 = L.restore, button2 = L.cancel,
    OnAccept = function(_, id)
      ns.Library.delete(id)
      Config.refresh()
    end,
    timeout = 0, whileDead = 1, hideOnEscape = 1,
  }
  StaticPopupDialogs.TC_DELETE = {
    text = L.deleteConfirm,
    button1 = L.delete, button2 = L.cancel,
    OnAccept = function(_, id)
      ns.Library.delete(id)
      selected = nil
      Config.refresh()
    end,
    timeout = 0, whileDead = 1, hideOnEscape = 1,
  }
  StaticPopupDialogs.TC_CLEAR = {
    text = L.clearConfirm,
    button1 = L.delete, button2 = L.cancel,
    OnAccept = function()
      local me, keep = UnitName("player"), {}
      for _, r in ipairs(ns.db.results) do
        if r.char ~= me then keep[#keep + 1] = r end
      end
      ns.db.results = keep
      Config.showResults()
    end,
    timeout = 0, whileDead = 1, hideOnEscape = 1,
  }
  local function sendWhisper(dialog)
    local name = _G[dialog:GetName() .. "EditBox"]:GetText()
    local rot = ns.Library.all[dialog.data]
    if rot and name ~= "" then ns.Share.send(rot, "WHISPER", name) end
  end
  StaticPopupDialogs.TC_WHISPER = {
    text = L.whisperWho,
    button1 = L.send, button2 = L.cancel,
    hasEditBox = 1, maxLetters = 12,
    OnShow = function(self) _G[self:GetName() .. "EditBox"]:SetFocus() end,
    OnAccept = function(self) sendWhisper(self) end,
    EditBoxOnEnterPressed = function(self)
      sendWhisper(self:GetParent())
      self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
    timeout = 0, whileDead = 1, hideOnEscape = 1,
  }
end

-- Lo usa el editor visual: «Ver como texto» y elegir la rotacion recien guardada.
function Config.openText(text, oldId)
  popups()
  openEditor(oldId and "edit" or "new", text, oldId)
end

function Config.select(id)
  if not main then
    popups()
    buildMain()
  end
  selected = id
  main:Show()
  Config.refresh()
end

function Config.toggle()
  if not main then
    popups()
    buildMain()
  end
  if main:IsShown() then main:Hide() else main:Show() end
end
