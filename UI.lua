-- El icono de la sugerencia: grande el siguiente hechizo, pequeno el de despues, y debajo la
-- explicacion de la accion y el dano (o el estado de la prueba).
local _, ns = ...
ns = ns or TacticsCoachNS
local UI = {}
ns.UI = UI

local QUESTION = "Interface\\Icons\\INV_Misc_QuestionMark"
local PAD = 6
local frame, main, nextIcon, title, status

local MOVE_BACKDROP = {
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 12,
  insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

local function makeIcon(parent, size)
  local b = CreateFrame("Frame", nil, parent)
  b:SetWidth(size)
  b:SetHeight(size)
  local bg = b:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(0, 0, 0, 0.7)
  bg:SetPoint("TOPLEFT", -2, 2)
  bg:SetPoint("BOTTOMRIGHT", 2, -2)
  b.tex = b:CreateTexture(nil, "ARTWORK")
  b.tex:SetAllPoints()
  b.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
  b.cd:SetAllPoints()
  return b
end

-- poor: espera recursos (azulado). Fuera de alcance: rojizo.
local function setIcon(b, name, poor)
  if not name then
    b.tex:SetTexture(QUESTION)
    b.tex:SetVertexColor(0.5, 0.5, 0.5)
    b.cd:Hide()
    b.lastStart = nil
    return
  end
  b.tex:SetTexture((select(3, GetSpellInfo(name))) or QUESTION)
  if poor then
    b.tex:SetVertexColor(0.45, 0.45, 1)
  elseif IsSpellInRange(name, "target") == 0 then
    b.tex:SetVertexColor(1, 0.35, 0.35)
  else
    b.tex:SetVertexColor(1, 1, 1)
  end
  local start, dur = GetSpellCooldown(name)
  if start and start > 0 and dur and dur > 0 then
    if b.lastStart ~= start or b.lastDur ~= dur then
      CooldownFrame_SetTimer(b.cd, start, dur, 1)
      b.lastStart, b.lastDur = start, dur
    end
  else
    b.cd:Hide()
    b.lastStart = nil
  end
end

local function shouldShow(rot)
  if UI.moving then return true end
  if ns.db.hidden then return false end
  if not ns.db.locked then return true end
  if not rot then return false end
  if ns.Lab.phase ~= "idle" or UnitAffectingCombat("player") then return true end
  if ns.db.onlyCombat then return false end
  return UnitExists("target") and UnitCanAttack("player", "target") and not UnitIsDead("target")
end

local function labText()
  local run = ns.Lab.run
  if ns.Lab.phase == "armed" then return ns.L.uiLabReady end
  local t = ns.Lab.elapsed()
  local left = math.floor(math.max(0, run.dur - t))
  local dps = t > 0 and run.dmg / t or 0
  local adh = run.casts > 0 and ns.L.uiAdherence:format(math.floor(run.hits * 100 / run.casts + 0.5)) or ""
  return ns.L.uiLab:format(math.floor(left / 60), left % 60, ns.fmt(dps), adh)
end

local function statusText(a1)
  local lines = {}
  if ns.Lab.phase ~= "idle" then
    lines[#lines + 1] = labText()
  elseif ns.db.explain and a1 and a1.note then
    lines[#lines + 1] = a1.note
  end
  local M = ns.Meter
  if ns.db.showFight then
    local f, secs, live = M.fightInfo()
    if f then
      lines[#lines + 1] = ns.L.uiDamageLine:format(live and ns.L.uiFight or ns.L.uiLastFight, ns.fmt(f.dmg), ns.fmt(M.rate(f.dmg, secs)))
    end
  end
  if ns.db.showSession then
    local s, secs = M.sessionInfo()
    if (s.dmg or 0) > 0 or (s.heal or 0) > 0 then
      lines[#lines + 1] = ns.L.uiDamageLine:format(ns.L.uiSession, ns.fmt(s.dmg), ns.fmt(M.rate(s.dmg, secs)))
      if ns.db.showDetail then
        local detail = M.detailText(s, secs)
        if detail ~= "" then lines[#lines + 1] = "|cffbbbbbb" .. detail:gsub("\n", "|r\n|cffbbbbbb") .. "|r" end
      end
    end
  end
  return table.concat(lines, "\n")
end

function UI.refresh()
  local n1, poor1, a1, n2, poor2 = ns.Engine.update()
  local rot = ns.Engine.rot
  if not shouldShow(rot) then
    frame:Hide()
    return
  end
  frame:Show()
  setIcon(main, n1, poor1)
  setIcon(nextIcon, n2, poor2)
  if UI.moving then
    title:SetText(ns.L.uiMovingTitle)
  elseif ns.db.locked then
    title:SetText("")
  else
    title:SetText((rot and rot.name or ns.L.uiNoRotation) .. "  " .. ns.L.uiDragHint)
  end
  status:SetText(statusText(a1))
end

-- La posicion se guarda como desplazamiento del centro del icono respecto del centro de la
-- pantalla, en unidades de UIParent: no depende de la escala del icono ni del punto de anclaje.
local DEFAULT_POS = { x = 0, y = -170 }

function UI.position()
  local p = ns.db.pos or DEFAULT_POS
  return p.x, p.y
end

function UI.setPosition(x, y)
  ns.db.pos = { x = math.floor(x + 0.5), y = math.floor(y + 0.5) }
  UI.applyPosition()
end

function UI.applyPosition()
  local x, y = UI.position()
  local s = frame:GetScale()
  frame:ClearAllPoints()
  frame:SetPoint("CENTER", UIParent, "CENTER", x / s, y / s)
end

function UI.resetPosition()
  ns.db.pos = nil
  UI.applyPosition()
  if ns.Options and ns.Options.sync then ns.Options.sync() end
end

-- Aplica tamano, opacidad, bloqueo y que partes se ven. Lo llaman las opciones y los comandos.
function UI.applySettings()
  if not frame then return end
  frame:SetScale(ns.db.scale or 1)
  frame:SetAlpha(UI.moving and 1 or (ns.db.alpha or 1))
  UI.applyPosition()
  if ns.db.showNext then nextIcon:Show() else nextIcon:Hide() end
  frame:SetWidth(PAD * 2 + 56 + (ns.db.showNext and (8 + 34) or 0))
  local movable = UI.moving or not ns.db.locked
  frame:EnableMouse(movable)
  if movable then
    frame:SetBackdrop(MOVE_BACKDROP)
    frame:SetBackdropColor(0.1, 0.45, 0.9, UI.moving and 0.7 or 0.35)
    frame:SetBackdropBorderColor(0.4, 0.8, 1, 1)
  else
    frame:SetBackdrop(nil)
  end
  if ns.Options and ns.Options.applyMinimap then ns.Options.applyMinimap() end
end

-- Modo mover: se ve y se arrastra aunque este bloqueado u oculto, hasta el clic derecho.
function UI.startMove()
  UI.moving = true
  UI.applySettings()
  frame:Show()
  ns.print(ns.L.uiMoveStart)
end

function UI.stopMove()
  if not UI.moving then return end
  UI.moving = false
  UI.applySettings()
  ns.print(ns.L.uiMoveDone .. (ns.db.locked and "" or " " .. ns.L.uiMoveLockHint))
end

function UI.create()
  frame = CreateFrame("Frame", "TacticsCoachFrame", UIParent)
  frame:SetHeight(56 + PAD * 2)
  frame:SetClampedToScreen(true)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local cx, cy = self:GetCenter()
    local ux, uy = UIParent:GetCenter()
    local s = self:GetScale()
    UI.setPosition(cx * s - ux, cy * s - uy)
    if ns.Options and ns.Options.sync then ns.Options.sync() end
  end)
  frame:SetScript("OnMouseUp", function(_, which)
    if which == "RightButton" then UI.stopMove() end
  end)
  frame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("Tactics Coach")
    GameTooltip:AddLine(ns.L.uiTipDrag, 1, 1, 1)
    if UI.moving then
      GameTooltip:AddLine(ns.L.uiTipRightClick, 1, 1, 1)
    else
      GameTooltip:AddLine(ns.L.uiTipLock, 1, 1, 1, true)
    end
    GameTooltip:Show()
  end)
  frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
  ns.db.frame = nil -- formato viejo de la posicion

  main = makeIcon(frame, 56)
  main:SetPoint("TOPLEFT", PAD, -PAD)
  nextIcon = makeIcon(frame, 34)
  nextIcon:SetPoint("BOTTOMLEFT", main, "BOTTOMRIGHT", 8, 0)

  title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  title:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 2, 3)

  status = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  status:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 2, -3)
  status:SetWidth(280)
  status:SetJustifyH("LEFT")

  UI.applySettings()

  -- El que late tiene que ser un marco siempre visible: uno oculto no recibe OnUpdate.
  local driver, wait = CreateFrame("Frame"), 0
  driver:SetScript("OnUpdate", function(_, elapsed)
    wait = wait - elapsed
    if wait > 0 then return end
    wait = 0.1
    local now = GetTime()
    ns.Lab.tick(now)
    ns.Meter.tick(now)
    UI.refresh()
  end)
end
