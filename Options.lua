-- Las opciones (Interfaz > Accesorios > Tactics Coach) y el boton del minimapa.
local _, ns = ...
ns = ns or TacticsCoachNS
local Options = {}
ns.Options = Options

local panel, content, minimapButton
local languageMenus = {}
local checks, sliders = {}, {}

local function check(key, label, x, y)
  local name = "TacticsCoachOpt_" .. key
  local cb = CreateFrame("CheckButton", name, content, "InterfaceOptionsCheckButtonTemplate")
  cb:SetPoint("TOPLEFT", x, y)
  _G[name .. "Text"]:SetText(label)
  cb:SetScript("OnClick", function(self)
    ns.db[key] = self:GetChecked() and true or false
    ns.UI.applySettings()
  end)
  checks[key] = cb
end

-- get/set opcionales: por defecto el valor vive en ns.db[key].
local function slider(key, label, minV, maxV, step, x, y, fmt, get, set)
  local name = "TacticsCoachOpt_" .. key
  local s = CreateFrame("Slider", name, content, "OptionsSliderTemplate")
  s:SetPoint("TOPLEFT", x, y)
  s:SetWidth(150)
  s:SetMinMaxValues(minV, maxV)
  s:SetValueStep(step)
  _G[name .. "Low"]:SetText(fmt(minV))
  _G[name .. "High"]:SetText(fmt(maxV))
  s:SetScript("OnValueChanged", function(_, v)
    v = math.floor(v / step + 0.5) * step
    if set then set(v) else ns.db[key] = v end
    _G[name .. "Text"]:SetText(label .. ": " .. fmt(v))
    if not set then ns.UI.applySettings() end
  end)
  s.get = get
  sliders[key] = s
end

local function button(text, width, onClick)
  local b = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
  b:SetWidth(width)
  b:SetHeight(22)
  b:SetText(text)
  b:SetScript("OnClick", onClick)
  return b
end

local function pct(v) return math.floor(v * 100 + 0.5) .. "%" end

local LANGUAGES = { "auto", "es", "en" }

local function languageLabel(lang)
  return lang == "auto" and ns.L.langAuto or lang == "es" and "Español" or "English"
end

function Options.sync()
  for key, cb in pairs(checks) do cb:SetChecked(ns.db[key]) end
  for key, s in pairs(sliders) do s:SetValue(s.get and s.get() or ns.db[key]) end
  for _, dd in ipairs(languageMenus) do UIDropDownMenu_SetText(dd, languageLabel(ns.db.language)) end
end

function Options.open()
  -- En 3.3.5a la primera llamada a veces solo abre la ventana sin ir a la categoria.
  InterfaceOptionsFrame_OpenToCategory(panel)
  InterfaceOptionsFrame_OpenToCategory(panel)
end

-- Los textos ya creados no se pueden traducir en vivo: cambiar de idioma recarga la interfaz.
function Options.setLanguage(lang)
  if ns.db.language == lang then return end
  ns.db.language = lang
  for _, dd in ipairs(languageMenus) do UIDropDownMenu_SetText(dd, languageLabel(lang)) end
  StaticPopup_Show("TC_RELOAD")
end

-- El selector de idioma: va en las opciones y en la ventana principal.
function Options.languageMenu(parent, name)
  local dd = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
  UIDropDownMenu_SetWidth(dd, 100)
  UIDropDownMenu_Initialize(dd, function(_, level)
    for _, lang in ipairs(LANGUAGES) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = languageLabel(lang)
      info.checked = (ns.db.language == lang)
      info.func = function() Options.setLanguage(lang) end
      UIDropDownMenu_AddButton(info, level)
    end
  end)
  UIDropDownMenu_SetText(dd, languageLabel(ns.db.language))
  languageMenus[#languageMenus + 1] = dd
  return dd
end

---------------------------------------------------------------------------------------------------
-- Boton del minimapa (sin librerias: arrastrable por el borde, angulo guardado)

local function placeMinimap()
  local a = math.rad(ns.db.minimapAngle or 200)
  minimapButton:ClearAllPoints()
  minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - 80 * math.cos(a), 80 * math.sin(a) - 52)
end

local function dragMinimap()
  local mx, my = Minimap:GetCenter()
  local px, py = GetCursorPosition()
  local scale = Minimap:GetEffectiveScale()
  ns.db.minimapAngle = math.deg(math.atan2(py / scale - my, px / scale - mx))
  placeMinimap()
end

function Options.applyMinimap()
  if not minimapButton then return end
  if ns.db.minimapShow then minimapButton:Show() else minimapButton:Hide() end
end

local function createMinimapButton()
  local L = ns.L
  local b = CreateFrame("Button", "TacticsCoachMinimapButton", Minimap)
  b:SetWidth(31)
  b:SetHeight(31)
  b:SetFrameStrata("MEDIUM")
  b:SetFrameLevel(8)
  b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  local icon = b:CreateTexture(nil, "BACKGROUND")
  icon:SetWidth(20)
  icon:SetHeight(20)
  icon:SetTexture("Interface\\Icons\\INV_Misc_Book_11")
  icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
  icon:SetPoint("TOPLEFT", 7, -5)
  local border = b:CreateTexture(nil, "OVERLAY")
  border:SetWidth(53)
  border:SetHeight(53)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetPoint("TOPLEFT")

  b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  b:RegisterForDrag("LeftButton")
  b:SetScript("OnClick", function(_, which)
    if which == "RightButton" then Options.open() else ns.Config.toggle() end
  end)
  b:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", dragMinimap) end)
  b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
  b:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Tactics Coach")
    local rot = ns.Library.active()
    if rot then GameTooltip:AddLine(rot.name, 0.4, 0.8, 1) end
    local dmg, dps, since = ns.Meter.sessionStats()
    if dmg > 0 then
      GameTooltip:AddLine(L.tipSession:format(date("%H:%M", since), ns.fmt(dmg), ns.fmt(dps)), 1, 1, 1)
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L.tipClick, 0.8, 0.8, 0.8)
    GameTooltip:AddLine(L.tipRightClick, 0.8, 0.8, 0.8)
    GameTooltip:AddLine(L.tipDragMinimap, 0.8, 0.8, 0.8)
    GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  minimapButton = b
  placeMinimap()
  Options.applyMinimap()
end

---------------------------------------------------------------------------------------------------

function Options.create()
  local L = ns.L
  panel = CreateFrame("Frame", "TacticsCoachOptions", InterfaceOptionsFramePanelContainer)
  panel.name = "Tactics Coach"
  panel:Hide()

  StaticPopupDialogs.TC_RELOAD = {
    text = L.reloadText,
    button1 = L.reloadNow, button2 = L.later,
    OnAccept = function() ReloadUI() end,
    timeout = 0, whileDead = 1, hideOnEscape = 1,
  }

  -- El panel de 3.3.5a mide unas 410 x 410 unidades (menos con fuentes grandes): todo va dentro de
  -- un area con barra de desplazamiento, en 380 de ancho.
  local sf = CreateFrame("ScrollFrame", "TacticsCoachOptScroll", panel, "UIPanelScrollFrameTemplate")
  sf:SetPoint("TOPLEFT", 4, -4)
  sf:SetPoint("BOTTOMRIGHT", -28, 4)
  content = CreateFrame("Frame", nil, sf)
  content:SetWidth(380)
  content:SetHeight(520)
  sf:SetScrollChild(content)

  local title = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 12, -12)
  title:SetText("Tactics Coach")
  local sub = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
  sub:SetWidth(350)
  sub:SetJustifyH("LEFT")
  sub:SetText(L.optSubtitle)

  local y = -54
  for _, opt in ipairs({
    { "locked", L.optLocked }, { "onlyCombat", L.optOnlyCombat }, { "showNext", L.optShowNext },
    { "explain", L.optExplain }, { "showFight", L.optShowFight }, { "showSession", L.optShowSession },
    { "showDetail", L.optShowDetail }, { "minimapShow", L.optMinimap }, { "hidden", L.optHidden },
  }) do
    check(opt[1], opt[2], 12, y)
    y = y - 24
  end

  -- La posicion va en unidades de UIParent (no en pixeles de pantalla, que es lo que da GetScreenWidth).
  local halfW = math.floor((UIParent:GetWidth() or 1600) / 2)
  local halfH = math.floor((UIParent:GetHeight() or 1200) / 2)
  y = y - 24
  slider("scale", L.optScale, 0.5, 2, 0.05, 20, y, pct)
  slider("posX", L.optPosX, -halfW, halfW, 1, 205, y, tostring,
    function() return (ns.UI.position()) end,
    function(v) local _, py = ns.UI.position(); ns.UI.setPosition(v, py) end)
  y = y - 50
  slider("alpha", L.optAlpha, 0.2, 1, 0.05, 20, y, pct)
  slider("posY", L.optPosY, -halfH, halfH, 1, 205, y, tostring,
    function() return select(2, ns.UI.position()) end,
    function(v) local px = ns.UI.position(); ns.UI.setPosition(px, v) end)

  -- Dos botones por fila: 2 x 175 + 6 de separacion caben en 380.
  y = y - 44
  local open = button(L.optOpen, 175, function()
    InterfaceOptionsFrame:Hide()
    ns.Config.toggle()
  end)
  open:SetPoint("TOPLEFT", 12, y)
  local move = button(L.moveIcon, 175, function()
    InterfaceOptionsFrame:Hide()
    ns.UI.startMove()
  end)
  move:SetPoint("LEFT", open, "RIGHT", 6, 0)
  local reset = button(L.optResetPos, 175, function() ns.UI.resetPosition() end)
  reset:SetPoint("TOPLEFT", open, "BOTTOMLEFT", 0, -6)
  local session = button(L.optResetSession, 175, function()
    ns.Meter.reset()
    ns.print(L.sessionReset)
  end)
  session:SetPoint("LEFT", reset, "RIGHT", 6, 0)

  local langLabel = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  langLabel:SetPoint("TOPLEFT", reset, "BOTTOMLEFT", 2, -18)
  langLabel:SetText(L.optLanguage)
  local menu = Options.languageMenu(content, "TacticsCoachOptLanguage")
  menu:SetPoint("LEFT", langLabel, "RIGHT", -8, -2)

  panel:SetScript("OnShow", Options.sync)
  InterfaceOptions_AddCategory(panel)
  createMinimapButton()
end
