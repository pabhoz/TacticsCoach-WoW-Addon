local ADDON, ns = ...
-- Respaldo por si el cliente no pasa la tabla privada del addon: los demas archivos la toman de aqui.
ADDON, ns = ADDON or "TacticsCoach", ns or {}
TacticsCoachNS = ns
ns.ADDON = ADDON
ns.builtin = ns.builtin or {}

function ns.print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0Tactics Coach|r: " .. tostring(msg))
end

-- Si una ventana no cabe en la pantalla (interfaz grande, resolucion baja), se achica entera.
function ns.fitToScreen(f)
  local w, h = UIParent:GetWidth(), UIParent:GetHeight()
  local fw, fh = f:GetWidth(), f:GetHeight()
  if not (w and h and fw and fh) or fw <= 0 or fh <= 0 then return end
  f:SetScale(math.min(1, (w - 16) / fw, (h - 16) / fh))
end

function ns.mainTree()
  local best, bestPts = nil, 0
  for i = 1, GetNumTalentTabs() do
    local pts = select(3, GetTalentTabInfo(i))
    if pts and pts > bestPts then best, bestPts = i, pts end
  end
  return best
end

local DEFAULTS = {
  rotations = {}, results = {}, locked = false, hidden = false, scale = 1, alpha = 1,
  explain = true, showNext = true, showFight = true, showSession = true, showDetail = true,
  onlyCombat = false,
  minimapShow = true, minimapAngle = 200, language = "auto",
}

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function(self, event, ...)
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local _, sub, src = ...
    local kind, amount, label, who, crit = ns.Meter.parse(sub, src, select(9, ...))
    if kind then
      ns.Meter.add(kind, amount, label, who, crit)
      ns.Lab.add(kind, amount, label, who, crit)
    end
  elseif event == "PLAYER_REGEN_DISABLED" then
    ns.Meter.startFight()
  elseif event == "PLAYER_REGEN_ENABLED" then
    ns.Meter.endFight()
  elseif event == "UNIT_SPELLCAST_SENT" then
    ns.Lab.onCast(...)
  elseif event == "CHAT_MSG_ADDON" then
    ns.Share.onMessage(...)
  elseif event == "SPELLS_CHANGED" then
    ns.State.scanSpellbook()
  elseif event == "ADDON_LOADED" then
    if ... ~= ADDON then return end
    -- Datos del nombre anterior (Stormrage Rotaciones): si estan, se adoptan una vez.
    if not TacticsCoachDB and StormrageRotacionesDB then TacticsCoachDB = StormrageRotacionesDB end
    if not TacticsCoachCharDB and StormrageRotacionesCharDB then TacticsCoachCharDB = StormrageRotacionesCharDB end
    StormrageRotacionesDB, StormrageRotacionesCharDB = nil, nil
    TacticsCoachDB = TacticsCoachDB or {}
    TacticsCoachCharDB = TacticsCoachCharDB or {}
    for k, v in pairs(DEFAULTS) do
      if TacticsCoachDB[k] == nil then
        TacticsCoachDB[k] = (type(v) == "table") and {} or v
      end
    end
    ns.db, ns.char = TacticsCoachDB, TacticsCoachCharDB
    ns.setLanguage(ns.detectLanguage(ns.db.language))
    self:UnregisterEvent("ADDON_LOADED")
  elseif event == "PLAYER_LOGIN" then
    ns.playerClass = select(2, UnitClass("player"))
    ns.State.scanSpellbook()
    ns.Library.load()
    ns.Share.init()
    ns.UI.create()
    ns.Options.create()
    if UnitAffectingCombat("player") then ns.Meter.startFight() end
    for _, e in ipairs({ "SPELLS_CHANGED", "CHAT_MSG_ADDON", "COMBAT_LOG_EVENT_UNFILTERED",
      "UNIT_SPELLCAST_SENT", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }) do
      self:RegisterEvent(e)
    end
  end
end)

local function findRotation(name)
  name = ns.Format.norm(name)
  for _, rot in ipairs(ns.Library.forClass(ns.playerClass)) do
    if ns.Format.norm(rot.name) == name then return rot end
  end
  for _, rot in ipairs(ns.Library.forClass(ns.playerClass)) do
    if ns.Format.norm(rot.name):find(name, 1, true) then return rot end
  end
end

-- /tc id <texto>: los ids de tus hechizos que contienen ese texto, para escribir rotaciones.
local function spellIds(text)
  text = ns.Format.norm(text)
  local found, i = 0, 1
  while true do
    local name, rank = GetSpellName(i, BOOKTYPE_SPELL)
    if not name then break end
    if text == "" or ns.Format.norm(name):find(text, 1, true) then
      local id = GetSpellLink(i, BOOKTYPE_SPELL):match("spell:(%d+)")
      ns.print(("%s%s = |cffffd100%s|r"):format(name, (rank and rank ~= "") and (" (" .. rank .. ")") or "", id))
      found = found + 1
    end
    i = i + 1
  end
  if found == 0 then ns.print(ns.L.noSpellMatch:format(text)) end
end

-- /tc auras: los ids de tus beneficios y de tus perjuicios sobre el objetivo.
local function auraIds()
  local function list(unit, filter, title)
    ns.print(title)
    for i = 1, 40 do
      local name, _, _, _, _, _, _, _, _, _, id = UnitAura(unit, i, filter)
      if not name then break end
      ns.print(("   %s = |cffffd100%d|r"):format(name, id))
    end
  end
  list("player", "HELPFUL", ns.L.aurasBuffs)
  list("target", "HARMFUL|PLAYER", ns.L.aurasDebuffs)
end

-- Cada subcomando se acepta en los dos idiomas, sin importar el elegido.
local COMMANDS = {
  prueba = "test", test = "test", parar = "stop", stop = "stop",
  resultados = "results", results = "results", usar = "use", use = "use",
  bloquear = "lock", lock = "lock", desbloquear = "unlock", unlock = "unlock",
  ocultar = "hide", hide = "hide", mostrar = "show", show = "show",
  explicar = "explain", explain = "explain", escala = "scale", scale = "scale",
  mover = "move", move = "move", opciones = "options", options = "options", config = "options",
  reiniciar = "reset", reset = "reset", id = "id", auras = "auras",
  idioma = "language", language = "language", lang = "language",
}

SLASH_TACTICSCOACH1 = "/tc"
SLASH_TACTICSCOACH2 = "/tactics"
SLASH_TACTICSCOACH3 = "/rot"
SlashCmdList.TACTICSCOACH = function(msg)
  local L = ns.L
  local word, arg = msg:match("^%s*(%S*)%s*(.-)%s*$")
  word = ns.Format.norm(word or "")
  local cmd = COMMANDS[word]
  if word == "" then
    ns.Config.toggle()
  elseif cmd == "test" then
    ns.Lab.arm(arg)
  elseif cmd == "stop" then
    ns.Lab.stop()
  elseif cmd == "results" then
    ns.Config.showResults()
  elseif cmd == "use" then
    local rot = findRotation(arg)
    if rot then
      ns.char.active = rot.id
      ns.print(L.usingRotation:format(rot.name))
      ns.Config.refresh()
    else
      ns.print(L.rotationNotFound:format(arg))
    end
  elseif cmd == "lock" then
    ns.db.locked = true
    ns.UI.applySettings()
  elseif cmd == "unlock" then
    ns.db.locked = false
    ns.UI.applySettings()
  elseif cmd == "hide" then
    ns.db.hidden = true
  elseif cmd == "show" then
    ns.db.hidden = false
  elseif cmd == "explain" then
    ns.db.explain = not ns.db.explain
    ns.print(ns.db.explain and L.explainOn or L.explainOff)
  elseif cmd == "scale" then
    local s = tonumber(arg)
    if s and s >= 0.5 and s <= 2 then
      ns.db.scale = s
      ns.UI.applySettings()
    else
      ns.print(L.scaleRange)
    end
  elseif cmd == "move" then
    if ns.UI.moving then ns.UI.stopMove() else ns.UI.startMove() end
  elseif cmd == "options" then
    ns.Options.open()
  elseif cmd == "reset" then
    ns.Meter.reset()
    ns.print(L.sessionReset)
  elseif cmd == "language" then
    local lang = ns.Format.norm(arg)
    lang = (lang == "es" or lang == "espanol" or lang == "spanish") and "es"
      or (lang == "en" or lang == "english" or lang == "ingles") and "en"
      or (lang == "auto") and "auto" or nil
    if lang then ns.Options.setLanguage(lang) else ns.print(L.languageUsage) end
  elseif cmd == "id" then
    spellIds(arg)
  elseif cmd == "auras" then
    auraIds()
  else
    for _, line in ipairs(L.help) do ns.print(line) end
  end
end
