-- El laboratorio: una prueba de duracion fija contra un muneco. Mide el dano (tuyo y de tu
-- mascota, aparte), la curacion, el golpe mas grande, el desglose por hechizo y que tanto
-- seguiste la sugerencia, y lo guarda para comparar rotaciones con el mismo personaje.
local _, ns = ...
ns = ns or TacticsCoachNS
local Lab = { phase = "idle" }
ns.Lab = Lab

local MIN_SECONDS, MAX_SECONDS, MAX_RESULTS = 30, 900, 300

function Lab.arm(seconds)
  local rot = ns.Library.active()
  if not rot then
    ns.print(ns.L.labNeedRotation)
    return
  end
  seconds = math.floor(tonumber(seconds) or 180)
  seconds = math.max(MIN_SECONDS, math.min(MAX_SECONDS, seconds))
  local names = {}
  for _, id in pairs(rot.spells) do
    local n = ns.State.spellName(id)
    if n then names[n] = true end
  end
  local run = ns.Meter.newStats()
  run.rotId, run.rotName, run.dur, run.names = rot.id, rot.name, seconds, names
  run.spells, run.casts, run.hits = {}, 0, 0
  Lab.run = run
  Lab.phase = "armed"
  ns.print(ns.L.labArmed:format(seconds, rot.name))
end

function Lab.stop()
  if Lab.phase == "idle" then
    ns.print(ns.L.labNone)
  elseif Lab.phase == "armed" then
    Lab.phase, Lab.run = "idle", nil
    ns.print(ns.L.labCancelled)
  else
    Lab.finish()
  end
end

-- Un evento ya filtrado por Meter.parse (tuyo o de tu mascota). El primer golpe arranca la prueba;
-- una curacion antes de empezar no cuenta.
function Lab.add(kind, amount, label, who, crit)
  if Lab.phase == "idle" then return end
  if Lab.phase == "armed" then
    if kind ~= "damage" then return end
    Lab.phase = "running"
    Lab.run.start = GetTime()
  end
  local run = Lab.run
  ns.Meter.record(run, kind, amount, label, who, crit)
  if kind == "damage" then run.spells[label] = (run.spells[label] or 0) + amount end
end

-- Cada hechizo de la rotacion que pulsas cuenta; si era el sugerido, es un acierto.
function Lab.onCast(unit, spell)
  if Lab.phase == "idle" or unit ~= "player" then return end
  local run = Lab.run
  if not run.names[spell] then return end
  run.casts = run.casts + 1
  if spell == ns.Engine.current then run.hits = run.hits + 1 end
end

function Lab.tick(now)
  if Lab.phase == "running" and now - Lab.run.start >= Lab.run.dur then Lab.finish() end
end

function Lab.elapsed()
  if Lab.phase ~= "running" then return 0 end
  return math.min(GetTime() - Lab.run.start, Lab.run.dur)
end

function Lab.itemLevel()
  local sum, n = 0, 0
  for slot = 1, 18 do
    if slot ~= 4 then -- la camisa no cuenta
      local link = GetInventoryItemLink("player", slot)
      local lvl = link and select(4, GetItemInfo(link))
      if lvl then sum, n = sum + lvl, n + 1 end
    end
  end
  if n == 0 then return nil end
  return math.floor(sum / n + 0.5)
end

function Lab.talents()
  local pts = {}
  for i = 1, 3 do pts[i] = select(3, GetTalentTabInfo(i)) or 0 end
  return table.concat(pts, "/")
end

function Lab.finish()
  local run, elapsed = Lab.run, Lab.elapsed()
  Lab.phase, Lab.run = "idle", nil
  if elapsed < 20 then
    ns.print(ns.L.labTooShort)
    return
  end
  local result = {
    rot = run.rotId, rotName = run.rotName, char = UnitName("player"), class = ns.playerClass,
    date = date("%Y-%m-%d %H:%M"), target = run.dur, dur = elapsed, dmg = run.dmg, dps = run.dmg / elapsed,
    pet = run.pet, heal = run.heal, top = run.top, topLabel = run.topLabel, topCrit = run.topCrit,
    spells = run.spells, adherence = (run.casts > 0) and (run.hits / run.casts) or nil,
    ilvl = Lab.itemLevel(), talents = Lab.talents(), level = UnitLevel("player"),
  }
  table.insert(ns.db.results, result)
  while #ns.db.results > MAX_RESULTS do table.remove(ns.db.results, 1) end
  ns.print(ns.L.labDone:format(run.rotName, ns.fmt(result.dps), math.floor(elapsed),
    result.adherence and ns.L.labAdherence:format(math.floor(result.adherence * 100 + 0.5)) or ""))
  if ns.Config and ns.Config.showResults then ns.Config.showResults() end
end

-- "1 min", "3 min", "45 s": la duracion pedida de una prueba.
function Lab.durationLabel(secs)
  secs = math.floor(secs + 0.5)
  if secs % 60 == 0 then return ns.L.minutes:format(secs / 60) end
  return ns.L.seconds:format(secs)
end

-- Resumen de las pruebas de un personaje, de mayor a menor DPS medio. Solo se comparan pruebas de
-- la misma duracion: en una de 1 minuto la apertura pesa mucho mas que en una de 3.
function Lab.summary(char)
  local by, order = {}, {}
  for _, r in ipairs(ns.db.results) do
    if r.char == char then
      local target = r.target or (math.floor(r.dur / 30 + 0.5) * 30)
      local key = r.rot .. "|" .. target
      local g = by[key]
      if not g then
        g = { rot = r.rot, target = target, dps = {}, adh = {}, ilvl = {}, petDps = {}, top = 0 }
        by[key] = g
        order[#order + 1] = g
      end
      g.name = r.rotName
      g.dps[#g.dps + 1] = r.dps
      if r.pet then g.petDps[#g.petDps + 1] = r.pet / r.dur end
      if (r.top or 0) > g.top then g.top, g.topLabel, g.topCrit = r.top, r.topLabel, r.topCrit end
      if r.adherence then g.adh[#g.adh + 1] = r.adherence end
      if r.ilvl then g.ilvl[#g.ilvl + 1] = r.ilvl end
    end
  end
  local function mean(t)
    if #t == 0 then return nil end
    local s = 0
    for _, v in ipairs(t) do s = s + v end
    return s / #t
  end
  local out = {}
  for _, g in ipairs(order) do
    local n, best = #g.dps, 0
    for _, v in ipairs(g.dps) do if v > best then best = v end end
    local avg = mean(g.dps)
    local sd
    if n > 1 then
      local var = 0
      for _, v in ipairs(g.dps) do var = var + (v - avg) ^ 2 end
      sd = math.sqrt(var / (n - 1))
    end
    local imin, imax
    for _, v in ipairs(g.ilvl) do
      imin = (not imin or v < imin) and v or imin
      imax = (not imax or v > imax) and v or imax
    end
    out[#out + 1] = {
      rot = g.rot, name = g.name, target = g.target, n = n, avg = avg, best = best, sd = sd,
      adherence = mean(g.adh), petDps = mean(g.petDps), top = g.top, topLabel = g.topLabel,
      topCrit = g.topCrit, ilvlMin = imin, ilvlMax = imax,
    }
  end
  table.sort(out, function(a, b)
    if a.target ~= b.target then return a.target < b.target end
    return a.avg > b.avg
  end)
  return out
end

function Lab.last(char)
  for i = #ns.db.results, 1, -1 do
    if ns.db.results[i].char == char then return ns.db.results[i] end
  end
end
