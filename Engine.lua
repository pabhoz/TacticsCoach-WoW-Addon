-- Elige que sugerir: recorre la lista de prioridades y se queda con la primera accion que el
-- personaje conoce, que esta (o estara al acabar el GCD) lista, y cuya condicion se cumple.
local _, ns = ...
ns = ns or TacticsCoachNS
local Engine = {}
ns.Engine = Engine

-- Compila las condiciones de una rotacion ya parseada. Devuelve la lista de errores.
function Engine.compile(rot)
  local errs = {}
  local function resolve(path) return ns.State.resolve(path, rot) end
  for _, act in ipairs(rot.actions) do
    if act.cond then
      local fn, msg = ns.Expr.compile(act.cond, resolve)
      if fn then
        act.fn = fn
      else
        errs[#errs + 1] = { line = act.line, msg = ns.L.fmtCondition:format(msg) }
      end
    end
  end
  return errs
end

-- Un hechizo que espera recursos (energia, mana) SI se sugiere: lo correcto es esperarlos.
-- Uno que no se puede usar por otra razon (falta sigilo, falta arma) no.
-- Un ataque "en el siguiente golpe" (Golpe heroico, Rajar, Golpe de raptor, Magullar) ya encolado
-- sigue marcado como actual hasta que sale el golpe: no se vuelve a sugerir, para no tapar lo demas.
-- Lo que se esta lanzando o canalizando tambien es "actual", pero eso si cuenta.
local function queued(name)
  if not IsCurrentSpell or not IsCurrentSpell(name) then return false end
  return UnitCastingInfo("player") ~= name and UnitChannelInfo("player") ~= name
end

local function pick(rot, ctx)
  local State = ns.State
  for _, act in ipairs(rot.actions) do
    local name = State.spellName(rot.spells[act.key])
    if name and State.isKnown(name) and not ctx.blocked[name] and not queued(name) then
      local usable, noMana = IsUsableSpell(name)
      if (usable or noMana) and State.cdRemains(ctx, name) <= 0.2 then
        if not act.fn or ns.Expr.truthy(act.fn(ctx)) then
          return act, name, not usable
        end
      end
    end
  end
end

-- Un finalizador gasta los puntos de combo: se reconoce porque su condicion los pide.
local function isFinisher(act)
  local c = act.condText and act.condText:lower()
  return c ~= nil and (c:find("puntos%s*>") or c:find("combo_points%s*>")) ~= nil
end

-- Devuelve: nombre sugerido, si espera recursos, la accion; y lo mismo para la siguiente.
function Engine.suggest(rot)
  local ctx = ns.State.newCtx()
  local a1, n1, poor1 = pick(rot, ctx)
  if not a1 then return nil end

  -- La siguiente: se da por lanzada la primera (su aura puesta, sus puntos gastados) y no se
  -- repite, salvo que sea la ultima accion: el relleno si se encadena consigo mismo.
  local ctx2 = ns.State.newCtx()
  ctx2.assume[n1] = true
  if rot.actions[#rot.actions].key ~= a1.key then ctx2.blocked[n1] = true end
  if isFinisher(a1) then ctx2.cp = 0 end
  local a2, n2, poor2 = pick(rot, ctx2)
  return n1, poor1, a1, n2, poor2, a2
end

function Engine.update()
  local rot = ns.Library.active()
  Engine.rot = rot
  if not rot then
    Engine.current, Engine.currentAction = nil, nil
    return nil
  end
  local n1, poor1, a1, n2, poor2, a2 = Engine.suggest(rot)
  Engine.current, Engine.currentAction = n1, a1
  return n1, poor1, a1, n2, poor2, a2
end
