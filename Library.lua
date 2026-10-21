-- Las rotaciones disponibles: las de fabrica (Rotations/*.lua, de solo lectura) y las del
-- jugador, que se guardan como texto en TacticsCoachDB.rotations[id].
local _, ns = ...
ns = ns or TacticsCoachNS
local Library = { all = {} }
ns.Library = Library

function Library.build(text, builtin)
  local rot, errs = ns.Format.parse(text)
  if not rot then return nil, errs end
  errs = ns.Engine.compile(rot)
  if #errs > 0 then return nil, errs end
  rot.builtin = builtin or nil
  return rot
end

-- Una de fabrica que el jugador edito se guarda en ns.db.rotations con el mismo nombre: se usa
-- su version (modified) y se recuerda el texto original para poder restaurarlo.
function Library.load()
  for k in pairs(Library.all) do Library.all[k] = nil end
  for _, entry in ipairs(ns.builtin) do
    -- Cada una viene en los dos idiomas; se usa la del idioma elegido.
    local text = type(entry) == "table" and (entry[ns.lang or "en"] or entry.en) or entry
    local rot, errs = Library.build(text, true)
    if rot then
      rot.original = text
      local custom = ns.db.rotations[rot.id] and Library.build(ns.db.rotations[rot.id], true)
      if custom and custom.id == rot.id then
        custom.original, custom.modified = text, true
        rot = custom
      end
      Library.all[rot.id] = rot
    else
      ns.print(ns.L.libBuiltinBroken .. "\n" .. ns.Format.formatErrors(errs))
    end
  end
  for _, text in pairs(ns.db.rotations) do
    local rot = Library.build(text, false)
    if rot and not Library.all[rot.id] then Library.all[rot.id] = rot end
  end
end

local function problem(msg) return nil, { { line = 0, msg = msg } } end

-- Guarda una rotacion. oldId: la que se esta editando (puede cambiar de nombre). Editar una de
-- fabrica sin cambiarle el nombre guarda tu version encima; cambiarselo crea una nueva.
function Library.save(text, oldId)
  local rot, errs = Library.build(text, false)
  if not rot then return nil, errs end
  local existing = Library.all[rot.id]
  if existing and existing.builtin and rot.id ~= oldId then
    return problem(ns.L.libBuiltinName:format(rot.id))
  end
  if existing and not existing.builtin and rot.id ~= oldId then
    return problem(ns.L.libExists:format(rot.id))
  end
  local old = oldId and Library.all[oldId]
  if old and oldId ~= rot.id and not old.builtin then
    ns.db.rotations[oldId] = nil
    Library.all[oldId] = nil
    if ns.char.active == oldId then ns.char.active = rot.id end
  end
  if existing and existing.builtin then
    rot.builtin, rot.modified, rot.original = true, true, existing.original
  end
  ns.db.rotations[rot.id] = text
  Library.all[rot.id] = rot
  return rot
end

-- Borra una tuya, o devuelve una de fabrica editada a su version original.
function Library.delete(id)
  local rot = Library.all[id]
  if not rot then return end
  ns.db.rotations[id] = nil
  if rot.builtin then
    if rot.modified then
      local original = Library.build(rot.original, true)
      original.original = rot.original
      Library.all[id] = original
    end
    return
  end
  Library.all[id] = nil
  if ns.char.active == id then ns.char.active = nil end
end

-- Un nombre libre a partir de base: "base", "base 2", "base 3"...
function Library.freeName(base)
  local name, i = base, 2
  while Library.all[name] do
    name = base .. " " .. i
    i = i + 1
  end
  return name
end

-- Importa una rotacion recibida o pegada. Si el nombre ya existe, se renombra.
function Library.import(text, from)
  local rot, errs = Library.build(text, false)
  if not rot then return nil, errs end
  if Library.all[rot.id] then
    local base = from and (rot.name .. " (" .. from .. ")") or rot.name
    local free = Library.freeName(base)
    text = ns.Format.setField(ns.Format.setField(text, "name", free), "id", free)
  end
  return Library.save(text)
end

function Library.forClass(class)
  local out = {}
  for _, rot in pairs(Library.all) do
    if rot.class == class then out[#out + 1] = rot end
  end
  table.sort(out, function(a, b)
    if (a.builtin and 1 or 0) ~= (b.builtin and 1 or 0) then return a.builtin ~= nil end
    return a.name < b.name
  end)
  return out
end

-- La de fabrica de tu clase que coincide con el arbol donde tienes mas puntos.
function Library.auto()
  local tree = ns.mainTree and ns.mainTree()
  local best, bestScore
  for _, rot in pairs(Library.all) do
    if rot.builtin and rot.class == ns.playerClass then
      -- El arbol pesa mas que el modo; entre las del mismo arbol, la de PvE.
      local score = ((tree and rot.tree == tree) and 2 or 0) + ((rot.mode ~= "pvp") and 1 or 0)
      if not best or score > bestScore or (score == bestScore and rot.name < best.name) then
        best, bestScore = rot, score
      end
    end
  end
  return best
end

function Library.active()
  local rot = ns.char.active and Library.all[ns.char.active]
  if rot and rot.class == ns.playerClass then return rot end
  return Library.auto()
end
