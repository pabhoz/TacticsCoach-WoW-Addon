-- El editor visual: armar una rotacion eligiendo hechizos de tu libro, ordenandolos y poniendoles
-- condiciones de una lista. Trabaja sobre ns.Model y al guardar lo convierte a texto.
local _, ns = ...
ns = ns or TacticsCoachNS
local Builder = {}
ns.Builder = Builder

local QUESTION = "Interface\\Icons\\INV_Misc_QuestionMark"
local LIST_ROWS, MAX_CONDS, PICK_ROWS = 11, 5, 14
local DEFAULT_NUM = {
  debuff_lt = "3", buff_lt = "3", target_lt = "25", target_gt = "30", mana_lt = "20", mana_gt = "50",
  cp_ge = "5", cp_le = "2", energy_ge = "60", rage_ge = "30", runic_ge = "40", health_lt = "35",
  tbuff_lt = "3",
}

local win, picker
local model, oldId, sel
local listOffset, pickOffset = 0, 0
local filling = false -- mientras se rellenan los campos, sus OnTextChanged no guardan nada

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function nameOf(key)
  local id = ns.Model.idOf(model, key)
  return (id and ns.State.spellName(id)) or key
end

local function iconOf(key)
  local id = ns.Model.idOf(model, key)
  return (id and select(3, GetSpellInfo(id))) or QUESTION
end

---------------------------------------------------------------------------------------------------
-- Piezas

local function text(parent, str, font)
  local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontNormalSmall")
  fs:SetText(str)
  fs:SetJustifyH("LEFT")
  return fs
end

local function button(parent, str, width, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetWidth(width)
  b:SetHeight(22)
  b:SetText(str)
  b:SetScript("OnClick", onClick)
  return b
end

local function iconButton(parent, texture, onClick, tip)
  local b = CreateFrame("Button", nil, parent)
  b:SetWidth(18)
  b:SetHeight(18)
  b:SetNormalTexture(texture)
  b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
  b:SetScript("OnClick", onClick)
  if tip then
    b:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:SetText(tip)
      GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  end
  return b
end

local boxes = 0
local function editbox(parent, width, onChange)
  boxes = boxes + 1
  local eb = CreateFrame("EditBox", "TacticsCoachBox" .. boxes, parent, "InputBoxTemplate")
  eb:SetWidth(width)
  eb:SetHeight(20)
  eb:SetAutoFocus(false)
  eb:SetScript("OnEscapePressed", eb.ClearFocus)
  eb:SetScript("OnEnterPressed", eb.ClearFocus)
  eb:SetScript("OnTextChanged", function(self)
    if not filling then onChange(self:GetText()) end
  end)
  return eb
end

local function setBox(eb, value)
  filling = true
  eb:SetText(value or "")
  eb:SetCursorPosition(0)
  filling = false
end

local menus = 0
local function dropdown(parent, width)
  menus = menus + 1
  local dd = CreateFrame("Frame", "TacticsCoachMenu" .. menus, parent, "UIDropDownMenuTemplate")
  UIDropDownMenu_SetWidth(dd, width)
  return dd
end

-- items: { { text, value } }. Se reconstruye en cada refresco porque las opciones cambian.
local function setMenu(dd, items, current, onPick)
  UIDropDownMenu_Initialize(dd, function(_, level)
    for _, it in ipairs(items) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = it[1]
      info.checked = (it[2] == current)
      info.func = function() onPick(it[2]) end
      UIDropDownMenu_AddButton(info, level)
    end
  end)
  for _, it in ipairs(items) do
    if it[2] == current then UIDropDownMenu_SetText(dd, it[1]) end
  end
end

---------------------------------------------------------------------------------------------------
-- Refresco

local refreshList, refreshDetail

local function selectAction(i)
  sel = i
  refreshList()
  refreshDetail()
end

function refreshList()
  local n = #model.actions
  listOffset = math.max(0, math.min(listOffset, n - LIST_ROWS))
  for r = 1, LIST_ROWS do
    local row, i = win.rows[r], r + listOffset
    local a = model.actions[i]
    if a then
      row.index = i
      row.num:SetText(i .. ".")
      row.icon:SetTexture(iconOf(a.key))
      row.label:SetText(nameOf(a.key) .. "  |cff999999" .. ns.Model.summary(model, a, nameOf) .. "|r")
      if i == sel then row:LockHighlight() else row:UnlockHighlight() end
      row:Show()
    else
      row:Hide()
    end
  end
  win.empty:SetText(n == 0 and ns.L.bEmpty or "")
end

local function spellItems()
  local items = {}
  for _, s in ipairs(model.spells) do items[#items + 1] = { nameOf(s.key), s.key } end
  for _, s in ipairs(model.auras) do items[#items + 1] = { nameOf(s.key) .. " " .. ns.L.bAuraSuffix, s.key } end
  return items
end

local function typeItems()
  local items = {}
  for _, c in ipairs(ns.Model.CONDS) do items[#items + 1] = { ns.Model.label(c.id), c.id } end
  return items
end

function refreshDetail()
  local a = sel and model.actions[sel]
  local d = win.detail
  if not a then
    d:Hide()
    return
  end
  d:Show()
  d.icon:SetTexture(iconOf(a.key))
  d.title:SetText(sel .. ". " .. nameOf(a.key))
  d.none:SetText(#a.conds == 0 and ("|cff999999" .. ns.L.bNoConds .. "|r") or "")

  local types, spells = typeItems(), spellItems()
  for r = 1, MAX_CONDS do
    local row, c = d.conds[r], a.conds[r]
    if c then
      local def = ns.Model.COND[c.id]
      setMenu(row.type, types, c.id, function(id)
        local nc = { id = id }
        local nd = ns.Model.COND[id]
        if nd.spell then nc.spell = c.spell or a.key end
        if nd.num then nc.num = DEFAULT_NUM[id] or "1" end
        if id == "raw" then nc.text = (c.id == "raw" and c.text) or ns.Model.condText({ c }) end
        a.conds[r] = nc
        refreshList()
        refreshDetail()
      end)
      if def.spell then
        setMenu(row.spell, spells, c.spell, function(key)
          c.spell = key
          refreshList()
          refreshDetail()
        end)
        row.spell:Show()
      else
        row.spell:Hide()
      end
      if def.num then
        setBox(row.num, c.num)
        row.num:Show()
      else
        row.num:Hide()
      end
      if c.id == "raw" then
        setBox(row.raw, c.text)
        row.raw:Show()
      else
        row.raw:Hide()
      end
      row:Show()
    else
      row:Hide()
    end
  end
  if #a.conds < MAX_CONDS then d.add:Enable() else d.add:Disable() end
  setBox(d.note, a.note)
end

---------------------------------------------------------------------------------------------------
-- Selector de hechizos de tu libro

local function bookSpells()
  local byName, i = {}, 1
  while true do
    local name, rank = GetSpellName(i, BOOKTYPE_SPELL)
    if not name then break end
    if not IsPassiveSpell(i, BOOKTYPE_SPELL) then
      local link = GetSpellLink(i, BOOKTYPE_SPELL)
      local id = link and tonumber(link:match("spell:(%d+)"))
      -- El libro trae los rangos en orden: el ultimo es el mas alto.
      if id then byName[name] = { name = name, rank = rank, id = id, icon = GetSpellTexture(i, BOOKTYPE_SPELL) } end
    end
    i = i + 1
  end
  local list = {}
  for _, s in pairs(byName) do list[#list + 1] = s end
  table.sort(list, function(x, y) return x.name < y.name end)
  return list
end

local function refreshPicker()
  local filter = ns.Format.norm(picker.search:GetText() or "")
  local shown = {}
  for _, s in ipairs(picker.all) do
    if filter == "" or ns.Format.norm(s.name):find(filter, 1, true) then shown[#shown + 1] = s end
  end
  pickOffset = math.max(0, math.min(pickOffset, #shown - PICK_ROWS))
  for r = 1, PICK_ROWS do
    local row, s = picker.rows[r], shown[r + pickOffset]
    if s then
      row.spell = s
      row.icon:SetTexture(s.icon or QUESTION)
      row.label:SetText(s.name .. ((s.rank and s.rank ~= "") and ("  |cff999999" .. s.rank .. "|r") or ""))
      row:Show()
    else
      row:Hide()
    end
  end
end

local function buildPicker()
  picker = CreateFrame("Frame", "TacticsCoachPicker", UIParent)
  picker:SetWidth(330)
  picker:SetHeight(PICK_ROWS * 22 + 110)
  picker:SetPoint("CENTER", 300, 0)
  picker:SetFrameStrata("FULLSCREEN_DIALOG")
  picker:SetToplevel(true)
  picker:EnableMouse(true)
  picker:SetClampedToScreen(true)
  picker:SetScript("OnShow", ns.fitToScreen)
  picker:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
  })
  local t = text(picker, ns.L.bPickTitle, "GameFontNormal")
  t:SetPoint("TOP", 0, -18)
  local close = CreateFrame("Button", nil, picker, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)
  local s = text(picker, ns.L.bSearch)
  s:SetPoint("TOPLEFT", 22, -48)
  picker.search = editbox(picker, 220, function()
    pickOffset = 0
    refreshPicker()
  end)
  picker.search:SetPoint("LEFT", s, "RIGHT", 10, 0)
  picker.rows = {}
  for r = 1, PICK_ROWS do
    local row = CreateFrame("Button", nil, picker)
    row:SetWidth(290)
    row:SetHeight(22)
    row:SetPoint("TOPLEFT", 20, -72 - (r - 1) * 22)
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetWidth(18)
    row.icon:SetHeight(18)
    row.icon:SetPoint("LEFT", 2, 0)
    row.label = text(row, "", "GameFontHighlightSmall")
    row.label:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    row:SetScript("OnClick", function(self)
      sel = ns.Model.addAction(model, self.spell.name, self.spell.id)
      listOffset = math.max(0, sel - LIST_ROWS)
      picker:Hide()
      refreshList()
      refreshDetail()
    end)
    picker.rows[r] = row
  end
  picker:EnableMouseWheel(true)
  picker:SetScript("OnMouseWheel", function(_, delta)
    pickOffset = pickOffset - delta * 3
    refreshPicker()
  end)
  local hint = text(picker, "|cff999999" .. ns.L.bWheel .. "|r")
  hint:SetPoint("BOTTOMLEFT", 22, 18)
  picker:Hide()
end

local function openPicker()
  if not picker then buildPicker() end
  picker.all = bookSpells()
  pickOffset = 0
  setBox(picker.search, "")
  refreshPicker()
  picker:Show()
end

---------------------------------------------------------------------------------------------------
-- Ventana

local function status(msg) win.status:SetText(msg or "") end

local function save()
  if trim(model.name or "") == "" then return status("|cffff5555" .. ns.L.bNeedName .. "|r") end
  if #model.actions == 0 then return status("|cffff5555" .. ns.L.bNeedSpell .. "|r") end
  local rot, errs = ns.Library.save(ns.Model.toText(model), oldId)
  if not rot then return status("|cffff5555" .. ns.Format.formatErrors(errs) .. "|r") end
  ns.print(ns.L.saved:format(rot.name))
  win:Hide()
  if picker then picker:Hide() end
  ns.Config.select(rot.id)
end

local function buildWindow()
  win = CreateFrame("Frame", "TacticsCoachBuilder", UIParent)
  win:SetWidth(740)
  win:SetHeight(540)
  win:SetPoint("CENTER")
  win:SetFrameStrata("DIALOG")
  win:SetToplevel(true)
  win:EnableMouse(true)
  win:SetMovable(true)
  win:SetClampedToScreen(true)
  win:SetScript("OnShow", ns.fitToScreen)
  win:RegisterForDrag("LeftButton")
  win:SetScript("OnDragStart", win.StartMoving)
  win:SetScript("OnDragStop", win.StopMovingOrSizing)
  win:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
  })
  tinsert(UISpecialFrames, "TacticsCoachBuilder")
  win.title = text(win, "", "GameFontNormalLarge")
  win.title:SetPoint("TOP", 0, -18)
  local close = CreateFrame("Button", nil, win, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)
  win:SetScript("OnHide", function() if picker then picker:Hide() end end)

  -- Cabecera
  local l1 = text(win, ns.L.bName)
  l1:SetPoint("TOPLEFT", 24, -52)
  win.name = editbox(win, 230, function(v) model.name = v end)
  win.name:SetPoint("LEFT", l1, "RIGHT", 12, 0)
  local l2 = text(win, ns.L.bSpec)
  l2:SetPoint("LEFT", win.name, "RIGHT", 20, 0)
  win.spec = editbox(win, 140, function(v) model.spec = v end)
  win.spec:SetPoint("LEFT", l2, "RIGHT", 12, 0)
  local l3 = text(win, ns.L.bDescription)
  l3:SetPoint("TOPLEFT", 24, -80)
  win.desc = editbox(win, 580, function(v) model.description = v end)
  win.desc:SetPoint("LEFT", l3, "RIGHT", 12, 0)

  -- Lista de prioridades
  local lt = text(win, ns.L.bPriority, "GameFontNormal")
  lt:SetPoint("TOPLEFT", 24, -112)
  local list = CreateFrame("Frame", nil, win)
  list:SetPoint("TOPLEFT", 18, -130)
  list:SetWidth(320)
  list:SetHeight(LIST_ROWS * 26 + 12)
  list:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  list:SetBackdropColor(0, 0, 0, 0.6)
  list:EnableMouseWheel(true)
  list:SetScript("OnMouseWheel", function(_, delta)
    listOffset = listOffset - delta
    refreshList()
  end)
  win.empty = text(list, "", "GameFontHighlightSmall")
  win.empty:SetPoint("TOPLEFT", 12, -14)
  win.empty:SetWidth(290)
  win.rows = {}
  for r = 1, LIST_ROWS do
    local row = CreateFrame("Button", nil, list)
    row:SetWidth(304)
    row:SetHeight(24)
    row:SetPoint("TOPLEFT", 8, -6 - (r - 1) * 26)
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    row.num = text(row, "", "GameFontNormalSmall")
    row.num:SetPoint("LEFT", 2, 0)
    row.num:SetWidth(20)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetWidth(20)
    row.icon:SetHeight(20)
    row.icon:SetPoint("LEFT", 22, 0)
    row.label = text(row, "", "GameFontHighlightSmall")
    row.label:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    row.label:SetWidth(180)
    row.label:SetHeight(14)
    row:SetScript("OnClick", function(self) selectAction(self.index) end)
    local up = iconButton(row, "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up", function()
      selectAction(ns.Model.move(model, row.index, -1))
    end, ns.L.bUp)
    up:SetPoint("RIGHT", -42, 0)
    local down = iconButton(row, "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up", function()
      selectAction(ns.Model.move(model, row.index, 1))
    end, ns.L.bDown)
    down:SetPoint("RIGHT", -22, 0)
    local del = iconButton(row, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", function()
      table.remove(model.actions, row.index)
      if sel and sel > #model.actions then sel = #model.actions end
      if sel == 0 then sel = nil end
      refreshList()
      refreshDetail()
    end, ns.L.bRemove)
    del:SetPoint("RIGHT", -2, 0)
    win.rows[r] = row
  end
  local add = button(win, ns.L.bAddSpell, 150, openPicker)
  add:SetPoint("TOPLEFT", list, "BOTTOMLEFT", 0, -6)
  local hint = text(win, "|cff999999" .. ns.L.bArrows .. "|r")
  hint:SetPoint("LEFT", add, "RIGHT", 10, 0)

  -- Detalle de la accion elegida
  local d = CreateFrame("Frame", nil, win)
  d:SetPoint("TOPLEFT", list, "TOPRIGHT", 12, 0)
  d:SetPoint("BOTTOMRIGHT", win, "BOTTOMRIGHT", -18, 60)
  d:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  d:SetBackdropColor(0, 0, 0, 0.6)
  d.icon = d:CreateTexture(nil, "ARTWORK")
  d.icon:SetWidth(28)
  d.icon:SetHeight(28)
  d.icon:SetPoint("TOPLEFT", 12, -12)
  d.title = text(d, "", "GameFontNormalLarge")
  d.title:SetPoint("LEFT", d.icon, "RIGHT", 8, 0)
  local when = text(d, ns.L.bWhen, "GameFontNormal")
  when:SetPoint("TOPLEFT", 12, -50)
  d.none = text(d, "", "GameFontHighlightSmall")
  d.none:SetPoint("TOPLEFT", 14, -72)
  d.conds = {}
  for r = 1, MAX_CONDS do
    local row = CreateFrame("Frame", nil, d)
    row:SetWidth(390)
    row:SetHeight(30)
    row:SetPoint("TOPLEFT", 4, -66 - (r - 1) * 32)
    -- Un menu de WoW mide lo pedido + ~50 px, y el texto empieza 16 px adentro de su borde.
    row.type = dropdown(row, 150)
    row.type:SetPoint("LEFT", -12, 0)
    row.spell = dropdown(row, 80)
    row.spell:SetPoint("LEFT", 168, 0)
    row.num = editbox(row, 32, function(v)
      local c = model.actions[sel].conds[r]
      if tonumber(v) then
        c.num = trim(v)
        refreshList()
      end
    end)
    row.num:SetPoint("LEFT", 306, 2)
    row.raw = editbox(row, 150, function(v)
      model.actions[sel].conds[r].text = v
      refreshList()
    end)
    row.raw:SetPoint("LEFT", 190, 2)
    local del = iconButton(row, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", function()
      table.remove(model.actions[sel].conds, r)
      refreshList()
      refreshDetail()
    end, ns.L.bRemoveCond)
    del:SetPoint("LEFT", 348, 2)
    d.conds[r] = row
  end
  d.add = button(d, ns.L.bAddCond, 150, function()
    local a = model.actions[sel]
    a.conds[#a.conds + 1] = { id = "debuff_down", spell = a.key }
    refreshList()
    refreshDetail()
  end)
  d.add:SetPoint("TOPLEFT", 12, -66 - MAX_CONDS * 32 - 4)
  local nl = text(d, ns.L.bNote, "GameFontNormal")
  nl:SetPoint("TOPLEFT", d.add, "BOTTOMLEFT", 0, -12)
  d.note = editbox(d, 340, function(v)
    model.actions[sel].note = v
  end)
  d.note:SetPoint("TOPLEFT", nl, "BOTTOMLEFT", 6, -4)
  win.detail = d

  -- Abajo
  win.status = text(win, "", "GameFontHighlightSmall")
  win.status:SetPoint("BOTTOMLEFT", 24, 44)
  win.status:SetWidth(690)
  local saveB = button(win, ns.L.save, 120, save)
  saveB:SetPoint("BOTTOMLEFT", 20, 16)
  local asText = button(win, ns.L.bAsText, 140, function()
    local t = ns.Model.toText(model)
    win:Hide()
    ns.Config.openText(t, oldId)
  end)
  asText:SetPoint("LEFT", saveB, "RIGHT", 8, 0)
  local cancel = button(win, ns.L.cancel, 120, function() win:Hide() end)
  cancel:SetPoint("BOTTOMRIGHT", -20, 16)
  win:Hide()
end

-- rot: la que se edita (nil = nueva). asNew: abrirla como copia nueva (Duplicar).
function Builder.open(rot, asNew)
  if not win then buildWindow() end
  if rot then
    model = ns.Model.fromRot(rot)
    oldId = (not asNew) and rot.id or nil
    if asNew then
      model.id = nil -- la copia es otra rotacion: no hereda el id fijo de la de fabrica
      model.name = ns.Library.freeName(rot.name .. " " .. ns.L.mineSuffix)
      model.author = UnitName("player")
    end
  else
    model = ns.Model.new(ns.playerClass, UnitName("player"), ns.mainTree())
    model.name = ns.Library.freeName(ns.L.myRotation)
    oldId = nil
  end
  sel = (#model.actions > 0) and 1 or nil
  listOffset = 0
  win.title:SetText(oldId and ns.L.bEditTitle:format(rot.name) or ns.L.newRotation)
  setBox(win.name, model.name)
  setBox(win.spec, model.spec)
  setBox(win.desc, model.description)
  if rot and rot.builtin and oldId then
    status(ns.L.bBuiltinHint)
  else
    status("")
  end
  refreshList()
  refreshDetail()
  win:Show()
  if not rot then openPicker() end
end

-- Para las pruebas: el modelo que se esta editando.
function Builder.current() return model, sel end
