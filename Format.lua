-- El formato de una rotacion es texto plano: se lee, se edita en el juego, se pega en Discord y
-- se manda por canal de addon tal cual. La rotacion guardada ES el texto; esto lo interpreta.
--
--   rotacion: Afliccion (Stormrage)
--   clase: WARLOCK
--   arbol: 1
--   hechizo corrupcion = 47813
--   accion corrupcion si perjuicio.corrupcion.inactivo -- explicacion opcional
local _, ns = ...
ns = ns or TacticsCoachNS
local Format = {}
ns.Format = Format

local ACCENTS = {
  ["á"] = "a", ["é"] = "e", ["í"] = "i", ["ó"] = "o", ["ú"] = "u", ["ü"] = "u", ["ñ"] = "n",
  ["Á"] = "a", ["É"] = "e", ["Í"] = "i", ["Ó"] = "o", ["Ú"] = "u", ["Ü"] = "u", ["Ñ"] = "n",
}

local function norm(s)
  s = s:lower()
  for k, v in pairs(ACCENTS) do s = s:gsub(k, v) end
  return s
end
Format.norm = norm

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local CLASSES = {
  WARRIOR = "WARRIOR", PALADIN = "PALADIN", HUNTER = "HUNTER", ROGUE = "ROGUE", PRIEST = "PRIEST",
  DEATHKNIGHT = "DEATHKNIGHT", SHAMAN = "SHAMAN", MAGE = "MAGE", WARLOCK = "WARLOCK", DRUID = "DRUID",
  guerrero = "WARRIOR", paladin = "PALADIN", cazador = "HUNTER", picaro = "ROGUE",
  sacerdote = "PRIEST", caballero_de_la_muerte = "DEATHKNIGHT", chaman = "SHAMAN", mago = "MAGE",
  brujo = "WARLOCK", druida = "DRUID",
}

local HEADER = {
  rotacion = "name", nombre = "name", rotation = "name", name = "name",
  clase = "class", class = "class",
  especializacion = "spec", spec = "spec",
  arbol = "tree", tree = "tree",
  autor = "author", author = "author",
  version = "version",
  descripcion = "description", description = "description",
  id = "id",
  modo = "mode", mode = "mode",
}
local HEADER_OUT = {
  name = "rotacion", class = "clase", spec = "especializacion", tree = "arbol",
  author = "autor", version = "version", description = "descripcion", id = "id", mode = "modo",
}

local RESERVED = { si = true, ["if"] = true }
for k in pairs(ns.Expr.KEYWORDS) do RESERVED[k] = true end

local function className(v)
  local up = v:upper():gsub("%s+", "")
  if CLASSES[up] then return CLASSES[up] end
  return CLASSES[(norm(v):gsub("%s+", "_"))]
end

-- Devuelve la rotacion, o nil + lista de errores { line, msg } (line 0 = la rotacion entera).
function Format.parse(text)
  local rot = { spells = {}, auras = {}, actions = {}, spellOrder = {}, auraOrder = {}, text = text }
  local errors = {}
  local function err(ln, msg) errors[#errors + 1] = { line = ln, msg = msg } end

  local ln = 0
  for raw in (text .. "\n"):gmatch("([^\n]*)\n") do
    ln = ln + 1
    local line = trim((raw:gsub("\r", ""):gsub("#.*$", "")))
    if line ~= "" then
      local hk, hv = line:match("^([^:%s]+)%s*:%s*(.*)$")
      local word, rest = line:match("^(%S+)%s*(.-)$")
      local w = norm(word)
      if hk and HEADER[norm(hk)] then
        rot[HEADER[norm(hk)]] = hv
      elseif w == "hechizo" or w == "spell" or w == "aura" then
        local key, id = rest:match("^([%a_][%w_]*)%s*=%s*(%d+)$")
        if not key then
          err(ln, ns.L.fmtSpellLine:format(word))
        elseif RESERVED[key:lower()] then
          err(ln, ns.L.fmtReserved:format(key))
        elseif rot.spells[key] or rot.auras[key] then
          err(ln, ns.L.fmtDefined:format(key))
        else
          local into = (w == "aura") and rot.auras or rot.spells
          local order = (w == "aura") and rot.auraOrder or rot.spellOrder
          into[key] = tonumber(id)
          order[#order + 1] = key
        end
      elseif w == "accion" or w == "action" then
        local body, note = rest:match("^(.-)%s*%-%-%s*(.*)$")
        body = body or rest
        local key, cond = body:match("^([%a_][%w_]*)%s*(.-)$")
        if not key then
          err(ln, ns.L.fmtActionLine)
        else
          local act = { key = key, line = ln, note = (note and note ~= "") and note or nil }
          if cond ~= "" then
            local kw, ctext = cond:match("^(%S+)%s+(.+)$")
            if not kw or (norm(kw) ~= "si" and norm(kw) ~= "if") then
              err(ln, ns.L.fmtIfAfter)
            else
              local ast, msg = ns.Expr.parse(ctext)
              if ast then
                act.cond, act.condText = ast, ctext
              else
                err(ln, ns.L.fmtCondition:format(msg))
              end
            end
          end
          rot.actions[#rot.actions + 1] = act
        end
      else
        err(ln, ns.L.fmtUnknownLine)
      end
    end
  end

  rot.name = rot.name and trim(rot.name)
  if not rot.name or rot.name == "" then
    err(0, ns.L.fmtNoName)
  elseif #rot.name > 48 then
    err(0, ns.L.fmtNameLong)
  end
  local cls = rot.class and className(rot.class)
  if not cls then
    err(0, ns.L.fmtClass)
  end
  rot.class = cls
  if rot.tree then
    local t = tonumber(rot.tree)
    if not t or t < 1 or t > 3 then err(0, ns.L.fmtTree) end
    rot.tree = t
  end
  if rot.mode then
    local m = norm(trim(rot.mode))
    if m ~= "pve" and m ~= "pvp" then err(0, ns.L.fmtMode) end
    rot.mode = m
  end
  if #rot.actions == 0 then err(0, ns.L.fmtNoActions) end
  for _, a in ipairs(rot.actions) do
    if not rot.spells[a.key] then
      err(a.line, ns.L.fmtUndefinedSpell:format(a.key, a.key))
    end
  end

  if #errors > 0 then
    table.sort(errors, function(a, b) return a.line < b.line end)
    return nil, errors
  end
  -- Las de fabrica traen un id fijo (id: tc-affliction) para que cambiar de idioma, que cambia
  -- su nombre, no las vuelva otra rotacion. Las demas se identifican por el nombre.
  rot.explicitId = rot.id and trim(rot.id) ~= "" and trim(rot.id) or nil
  rot.id = rot.explicitId or rot.name
  return rot
end

function Format.formatErrors(errors)
  local out = {}
  for _, e in ipairs(errors) do
    out[#out + 1] = (e.line > 0 and ns.L.fmtLine:format(e.line) or "") .. e.msg
  end
  return table.concat(out, "\n")
end

-- Cambia (o agrega al principio) un campo de la cabecera sin tocar el resto del texto.
function Format.setField(text, field, value)
  local out, done = {}, false
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    local k = line:match("^%s*([^:%s#]+)%s*:")
    if not done and k and HEADER[norm(k)] == field then
      out[#out + 1] = HEADER_OUT[field] .. ": " .. value
      done = true
    else
      out[#out + 1] = line
    end
  end
  if not done then table.insert(out, 1, HEADER_OUT[field] .. ": " .. value) end
  -- gmatch sobre text.."\n" agrega una linea vacia de mas al final.
  if out[#out] == "" then table.remove(out) end
  return table.concat(out, "\n")
end
