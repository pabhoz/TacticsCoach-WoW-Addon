-- El medidor: lo del combate actual (o el ultimo) y lo acumulado de la sesion. La sesion vive
-- en TacticsCoachCharDB, asi que sobrevive a /reload; se reinicia a mano.
--
-- De cada uno se lleva: dano total (tuyo + mascota), dano de la mascota aparte, curacion
-- efectiva (sin la sobrecuracion) y el golpe mas grande con su hechizo y si fue critico.
local _, ns = ...
ns = ns or TacticsCoachNS
local Meter = {}
ns.Meter = Meter

-- Un evento del registro de combate de 3.3.5a hecho por ti o tu mascota. ... son los argumentos
-- que siguen a dstFlags. Devuelve tipo ("damage" | "heal"), cantidad, etiqueta, "player" | "pet",
-- critico. nil si no es tuyo o no es dano ni curacion.
function Meter.parse(sub, srcGUID, ...)
  local who
  if srcGUID == UnitGUID("player") then
    who = "player"
  else
    local pet = UnitGUID("pet")
    if pet and srcGUID == pet then who = "pet" end
  end
  if not who then return end
  local kind, amount, label, crit
  if sub == "SWING_DAMAGE" then
    -- amount, overkill, school, resisted, blocked, absorbed, critical
    local amt, _, _, _, _, _, c = ...
    kind, amount, label, crit = "damage", amt, ns.L.melee, c
  elseif sub == "SPELL_DAMAGE" or sub == "SPELL_PERIODIC_DAMAGE" or sub == "RANGE_DAMAGE" then
    -- spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical
    local _, name, _, amt, _, _, _, _, _, c = ...
    kind, amount, label, crit = "damage", amt, name, c
  elseif sub == "SPELL_HEAL" or sub == "SPELL_PERIODIC_HEAL" then
    -- spellId, spellName, spellSchool, amount, overhealing, absorbed, critical
    local _, name, _, amt, over, _, c = ...
    kind, amount, label, crit = "heal", (amt or 0) - (over or 0), name, c
  else
    return
  end
  if not amount or amount <= 0 then return end
  if who == "pet" then label = (label or "?") .. ns.L.petSuffix end
  return kind, amount, label, who, (crit and crit ~= 0) and true or nil
end

function Meter.newStats() return { dmg = 0, pet = 0, heal = 0, top = 0 } end

-- Suma un evento a unas estadisticas (las de la sesion, el combate o una prueba).
function Meter.record(st, kind, amount, label, who, crit)
  if kind == "heal" then
    st.heal = (st.heal or 0) + amount
    return
  end
  st.dmg = (st.dmg or 0) + amount
  if who == "pet" then st.pet = (st.pet or 0) + amount end
  if amount > (st.top or 0) then st.top, st.topLabel, st.topCrit = amount, label, crit end
end

function Meter.rate(n, secs)
  if not n or secs < 1 then return 0 end
  return n / secs
end

local function session()
  local s = ns.char.session
  if not s then
    s = Meter.newStats()
    s.time, s.since = 0, time()
    ns.char.session = s
  end
  return s
end

-- Un combate se define por la actividad, no solo por el estado de combate del juego: el muneco de
-- AzerothCore suelta el combate 5 s despues del ultimo golpe directo (los DoT no cuentan), y si un
-- evento se pierde, el tiempo quedaria en cero. Empieza con el primer golpe (o al entrar en
-- combate) y dura hasta el ultimo golpe.
local IDLE_OUT_OF_COMBAT, IDLE_MAX = 6, 15

function Meter.startFight()
  if Meter.fight and not Meter.fight.stop then return end
  local now = GetTime()
  Meter.fight = Meter.newStats()
  Meter.fight.start, Meter.fight.last = now, now
end

function Meter.endFight()
  local f = Meter.fight
  if not f or f.stop then return end
  f.stop = math.max(f.last or f.start, f.start)
  local s = session()
  s.time = s.time + (f.stop - f.start)
end

function Meter.add(kind, amount, label, who, crit)
  Meter.record(session(), kind, amount, label, who, crit)
  local f = Meter.fight
  if kind == "damage" and (not f or f.stop) then
    Meter.startFight()
    f = Meter.fight
  end
  if f and not f.stop then
    Meter.record(f, kind, amount, label, who, crit)
    if kind == "damage" then f.last = GetTime() end
  end
end

-- Cierra el combate si lleva un rato sin dano: lo llama el icono cada 0,1 s.
function Meter.tick(now)
  local f = Meter.fight
  if not f or f.stop then return end
  local idle = now - (f.last or f.start)
  if idle > IDLE_MAX or (idle > IDLE_OUT_OF_COMBAT and not UnitAffectingCombat("player")) then
    Meter.endFight()
  end
end

function Meter.reset()
  ns.char.session = nil
  Meter.fight = nil
  if UnitAffectingCombat("player") then Meter.startFight() end
end

-- El combate actual o, fuera de combate, el ultimo: estadisticas, segundos, si sigue en curso.
function Meter.fightInfo()
  local f = Meter.fight
  if not f then return nil end
  return f, (f.stop or f.last or f.start) - f.start, f.stop == nil
end

-- La sesion: estadisticas y segundos en combate (el tiempo fuera de combate no cuenta).
function Meter.sessionInfo()
  local s = session()
  local secs = s.time
  local f = Meter.fight
  if f and not f.stop then secs = secs + ((f.last or f.start) - f.start) end
  return s, secs
end

-- Atajo: dano, DPS y desde cuando.
function Meter.sessionStats()
  local s, secs = Meter.sessionInfo()
  return s.dmg or 0, Meter.rate(s.dmg, secs), s.since
end

-- "Mascota 12.345 (18%) · Golpe más grande 9.876 (Descarga de caos, crítico)"
function Meter.detailText(st, secs)
  local L, parts = ns.L, {}
  if (st.pet or 0) > 0 then
    parts[#parts + 1] = L.detailPet:format(ns.fmt(st.pet), math.floor(st.pet * 100 / st.dmg + 0.5))
  end
  if (st.top or 0) > 0 then
    parts[#parts + 1] = L.detailTop:format(ns.fmt(st.top), (st.topLabel or "?") .. (st.topCrit and L.critSuffix or ""))
  end
  local lines = {}
  if #parts > 0 then lines[1] = table.concat(parts, " · ") end
  if (st.heal or 0) > 0 then
    lines[#lines + 1] = L.detailHeal:format(ns.fmt(st.heal), ns.fmt(Meter.rate(st.heal, secs)))
  end
  return table.concat(lines, "\n")
end
