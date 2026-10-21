-- Lo que una condicion puede leer del juego. Todo pasa por State.resolve: si una variable no
-- esta aqui, la rotacion no compila. Cada evaluacion usa un ctx nuevo que cachea las auras.
local _, ns = ...
ns = ns or TacticsCoachNS
local State = { known = {}, names = {} }
ns.State = State

-- Los hechizos se buscan por NOMBRE: el id de la rotacion puede ser el rango maximo y el
-- personaje tener uno menor, y por nombre el cliente usa el rango mas alto que conozcas.
function State.spellName(id)
  if not id then return nil end
  local n = State.names[id]
  if n == nil then
    n = GetSpellInfo(id) or false
    State.names[id] = n
  end
  return n or nil
end

function State.scanSpellbook()
  for k in pairs(State.known) do State.known[k] = nil end
  local i = 1
  while true do
    local name = GetSpellName(i, BOOKTYPE_SPELL)
    if not name then break end
    State.known[name] = true
    i = i + 1
  end
end

function State.isKnown(name) return State.known[name] == true end

-- assume: auras que se dan por puestas (para adivinar la sugerencia siguiente).
-- blocked: hechizos que no se pueden sugerir. cp: puntos de combo forzados.
function State.newCtx()
  return { now = GetTime(), cache = {}, assume = {}, blocked = {} }
end

local ASSUMED = { up = true, remains = 99, stack = 1 }

local function aura(ctx, unit, filter, name)
  if ctx.assume[name] then return ASSUMED end
  local key = unit .. filter .. name
  local a = ctx.cache[key]
  if a == nil then
    local n, _, _, count, _, _, expires = UnitAura(unit, name, nil, filter)
    if n then
      a = {
        up = true,
        stack = (count and count > 0) and count or 1,
        remains = (expires and expires > 0) and math.max(0, expires - ctx.now) or 9999,
      }
    else
      a = false
    end
    ctx.cache[key] = a
  end
  return a or nil
end

-- Segundos de reutilizacion que faltan, sin contar el tiempo global (GCD): un hechizo que solo
-- espera el GCD cuenta como listo.
function State.cdRemains(ctx, name)
  local start, dur = GetSpellCooldown(name)
  if not start or start == 0 or not dur or dur <= 1.5 then return 0 end
  return math.max(0, start + dur - ctx.now)
end

local function pct(cur, max)
  if not max or max <= 0 then return 0 end
  return cur * 100 / max
end

local SIMPLE = {}
local function def(names, fn) for _, n in ipairs(names) do SIMPLE[n] = fn end end

def({ "energia", "energy" }, function() return UnitPower("player", 3) or 0 end)
def({ "ira", "rage" }, function() return UnitPower("player", 1) or 0 end)
def({ "poder_runico", "runic_power" }, function() return UnitPower("player", 6) or 0 end)
def({ "mana", "mana_pct" }, function() return pct(UnitPower("player", 0), UnitPowerMax("player", 0)) end)
def({ "vida", "health", "health_pct" }, function() return pct(UnitHealth("player"), UnitHealthMax("player")) end)
def({ "puntos", "combo_points" }, function(ctx)
  if ctx.cp then return ctx.cp end
  return GetComboPoints("player", "target") or 0
end)
def({ "sigilo", "stealthed" }, function() return IsStealthed() and true or false end)
def({ "combate", "combat" }, function() return UnitAffectingCombat("player") and true or false end)
def({ "moviendo", "moving" }, function() return (GetUnitSpeed("player") or 0) > 0 end)
def({ "fragmentos", "soul_shards" }, function() return GetItemCount(6265) or 0 end)
def({ "mascota", "pet" }, function() return (UnitExists("pet") and not UnitIsDead("pet")) and true or false end)

local TARGET = {}
local function targetHealth()
  if not UnitExists("target") then return 100 end
  return pct(UnitHealth("target"), UnitHealthMax("target"))
end
TARGET.vida, TARGET.health, TARGET.health_pct = targetHealth, targetHealth, targetHealth

-- Lanzando o canalizando algo que se puede interrumpir (para Patada, Contrahechizo, etc.).
local function targetCasting()
  if not UnitExists("target") then return false end
  local name, _, _, _, _, _, _, _, locked = UnitCastingInfo("target")
  if not name then name, _, _, _, _, _, _, locked = UnitChannelInfo("target") end
  return name ~= nil and not locked
end
TARGET.lanzando, TARGET.casting = targetCasting, targetCasting
local function targetPlayer() return UnitExists("target") and UnitIsPlayer("target") and true or false end
TARGET.jugador, TARGET.player = targetPlayer, targetPlayer
local function targetFriendly() return UnitExists("target") and UnitIsFriend("player", "target") and true or false end
TARGET.amistoso, TARGET.friendly = targetFriendly, targetFriendly

-- buff: tus beneficios (de quien sea). debuff: TUS perjuicios en el objetivo.
-- tbuff: TUS beneficios en el objetivo (sanadores: Renovar, Señal de la Luz). sdebuff: perjuicios
-- sobre ti (las cargas de Explosion Arcana, Abstinencia).
local PREFIX = {
  beneficio = "buff", buff = "buff",
  perjuicio = "debuff", debuff = "debuff",
  beneficio_objetivo = "tbuff", target_buff = "tbuff",
  perjuicio_propio = "sdebuff", self_debuff = "sdebuff",
  reutilizacion = "cd", cd = "cd", cooldown = "cd",
  lanzamiento = "cast", cast = "cast",
}
local AURA_FIELD = {
  activo = "up", up = "up", inactivo = "down", down = "down",
  restante = "remains", remains = "remains", cargas = "stack", stack = "stack",
}
local CD_FIELD = { listo = "ready", ready = "ready", restante = "remains", remains = "remains" }

-- Devuelve getter(ctx) para la variable, o nil + mensaje en espanol.
function State.resolve(path, rot)
  local full = table.concat(path, ".")
  local head = path[1]:lower()
  if #path == 1 then
    if SIMPLE[head] then return SIMPLE[head] end
    return nil, ns.L.varUnknown:format(full)
  end
  if head == "objetivo" or head == "target" then
    local g = #path == 2 and TARGET[path[2]:lower()]
    if g then return g end
    return nil, ns.L.varTarget
  end

  local kind = PREFIX[head]
  if not kind then return nil, ns.L.varUnknown:format(full) end
  local key = path[2]
  local id = rot.spells[key] or ((kind ~= "cd" and kind ~= "cast") and rot.auras[key])
  if not id then
    return nil, ns.L.varUndefined:format(key, key, key)
  end

  if kind == "cast" then
    if #path ~= 2 then return nil, ns.L.varCast:format(full, key) end
    return function()
      local name = State.spellName(id)
      local ct = name and select(7, GetSpellInfo(name))
      return (ct or 0) / 1000
    end
  end

  local field = path[3] and path[3]:lower()
  if kind == "cd" then
    local f = #path == 3 and CD_FIELD[field]
    if not f then return nil, ns.L.varCdField:format(full) end
    if f == "ready" then
      return function(ctx)
        local name = State.spellName(id)
        return name ~= nil and State.cdRemains(ctx, name) <= 0
      end
    end
    return function(ctx)
      local name = State.spellName(id)
      return name and State.cdRemains(ctx, name) or 0
    end
  end

  local f = #path == 3 and AURA_FIELD[field]
  if not f then return nil, ns.L.varAuraField:format(full) end
  local unit = (kind == "buff" or kind == "sdebuff") and "player" or "target"
  local filter = (kind == "buff") and "HELPFUL" or (kind == "debuff") and "HARMFUL|PLAYER"
    or (kind == "tbuff") and "HELPFUL|PLAYER" or "HARMFUL"
  local function get(ctx)
    local name = State.spellName(id)
    return name and aura(ctx, unit, filter, name)
  end
  if f == "up" then return function(ctx) return get(ctx) ~= nil end end
  if f == "down" then return function(ctx) return get(ctx) == nil end end
  if f == "remains" then return function(ctx) local a = get(ctx); return a and a.remains or 0 end end
  return function(ctx) local a = get(ctx); return a and a.stack or 0 end
end
