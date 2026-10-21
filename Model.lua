-- El modelo del editor visual: una rotacion como tablas (hechizos, acciones y condiciones
-- elegidas de una lista) en vez de texto. Se traduce del texto y vuelve a texto al guardar, asi
-- que compartir y exportar siguen igual. Lo que el editor no sabe representar (una condicion
-- con "o", por ejemplo) se conserva tal cual como condicion "avanzada".
--
-- Reconoce condiciones escritas en ingles o en espanol, y escribe en el idioma elegido.
local _, ns = ...
ns = ns or TacticsCoachNS
local Model = {}
ns.Model = Model

local VOCAB = {
  es = {
    rotation = "rotacion", class = "clase", spec = "especializacion", tree = "arbol", author = "autor",
    version = "version", description = "descripcion", spell = "hechizo", aura = "aura", action = "accion",
    ["if"] = "si", ["and"] = "y", ["not"] = "no",
    debuff = "perjuicio", buff = "beneficio", cast = "lanzamiento", up = "activo", down = "inactivo",
    remains = "restante", target_health = "objetivo.vida", mana = "mana", cp = "puntos",
    energy = "energia", stealthed = "sigilo", moving = "moviendo", mode = "modo",
    tbuff = "beneficio_objetivo", health = "vida", casting = "objetivo.lanzando",
    tplayer = "objetivo.jugador", rage = "ira", runic = "poder_runico",
  },
  en = {
    rotation = "rotation", class = "class", spec = "spec", tree = "tree", author = "author",
    version = "version", description = "description", spell = "spell", aura = "aura", action = "action",
    ["if"] = "if", ["and"] = "and", ["not"] = "not",
    debuff = "debuff", buff = "buff", cast = "cast", up = "up", down = "down",
    remains = "remains", target_health = "target.health", mana = "mana", cp = "combo_points",
    energy = "energy", stealthed = "stealthed", moving = "moving", mode = "mode",
    tbuff = "target_buff", health = "health", casting = "target.casting",
    tplayer = "target.player", rage = "rage", runic = "runic_power",
  },
}
Model.VOCAB = VOCAB

local function vocab() return VOCAB[ns.lang or "en"] or VOCAB.en end

-- Plantillas: {palabra} sale del vocabulario, $S es la clave del hechizo y $N un numero.
Model.CONDS = {
  { id = "debuff_down", tpl = "{debuff}.$S.{down}" },
  { id = "debuff_up", tpl = "{debuff}.$S.{up}" },
  { id = "debuff_lt", tpl = "{debuff}.$S.{remains} < $N" },
  { id = "debuff_cast", tpl = "{debuff}.$S.{remains} < {cast}.$S" },
  { id = "buff_down", tpl = "{buff}.$S.{down}" },
  { id = "buff_up", tpl = "{buff}.$S.{up}" },
  { id = "buff_lt", tpl = "{buff}.$S.{remains} < $N" },
  { id = "tbuff_down", tpl = "{tbuff}.$S.{down}" },
  { id = "tbuff_lt", tpl = "{tbuff}.$S.{remains} < $N" },
  { id = "target_lt", tpl = "{target_health} < $N" },
  { id = "target_gt", tpl = "{target_health} > $N" },
  { id = "mana_lt", tpl = "{mana} < $N" },
  { id = "mana_gt", tpl = "{mana} > $N" },
  { id = "cp_ge", tpl = "{cp} >= $N" },
  { id = "cp_le", tpl = "{cp} <= $N" },
  { id = "energy_ge", tpl = "{energy} >= $N" },
  { id = "rage_ge", tpl = "{rage} >= $N" },
  { id = "runic_ge", tpl = "{runic} >= $N" },
  { id = "health_lt", tpl = "{health} < $N" },
  { id = "casting", tpl = "{casting}" },
  { id = "tplayer", tpl = "{tplayer}" },
  { id = "stealth", tpl = "{stealthed}" },
  { id = "moving", tpl = "{moving}" },
  { id = "still", tpl = "{not} {moving}" },
  { id = "raw" },
}
Model.COND = {}

local K = "([%a_][%w_]*)"
local N = "(%d+%.?%d*)"

local function fill(tpl, V) return (tpl:gsub("{([%w_]+)}", V)) end

for _, c in ipairs(Model.CONDS) do
  Model.COND[c.id] = c
  if c.tpl then
    c.spell = c.tpl:find("$S", 1, true) ~= nil
    c.num = c.tpl:find("$N", 1, true) ~= nil
    c.caps = {}
    for mark in c.tpl:gmatch("%$([SN])") do c.caps[#c.caps + 1] = (mark == "N") and "num" or "spell" end
    c.pats = {}
    for _, V in pairs(VOCAB) do
      -- Las marcas se protegen antes de escapar los signos magicos de los patrones de Lua.
      local p = fill(c.tpl, V):gsub("%$S", "\1"):gsub("%$N", "\2")
      -- K y N llevan "%": como reemplazo de gsub tienen que ir por funcion.
      p = p:gsub("[%%%^%$%(%)%.%[%]%*%+%-%?]", "%%%0")
        :gsub("\1", function() return K end):gsub("\2", function() return N end)
      c.pats[#c.pats + 1] = "^" .. p .. "$"
    end
  end
end

function Model.label(id) return ns.L["cond_" .. id] end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

-- Separa por los "y" / "and" que no estan dentro de parentesis.
function Model.splitAnd(text)
  local parts, depth, start, i, n = {}, 0, 1, 1, #text
  while i <= n do
    local c = text:sub(i, i)
    if c == "(" then
      depth = depth + 1
    elseif c == ")" then
      depth = depth - 1
    elseif depth == 0 and c:match("%s") then
      local sep = text:match("^%s+[yY]%s+", i) or text:match("^%s+[aA][nN][dD]%s+", i)
      if sep then
        parts[#parts + 1] = trim(text:sub(start, i - 1))
        i = i + #sep
        start = i
      end
    end
    i = i + 1
  end
  parts[#parts + 1] = trim(text:sub(start))
  return parts
end

-- "puntos>=5" y "puntos >=  5" se leen igual que "puntos >= 5".
local function canonical(s)
  s = s:gsub("%s*([<>=!~]=?)%s*", " %1 ")
  return trim(s:gsub("%s+", " "))
end

function Model.parseCond(clause)
  local canon = canonical(clause)
  for _, c in ipairs(Model.CONDS) do
    for _, pat in ipairs(c.pats or {}) do
      local caps = { canon:match(pat) }
      if caps[1] then
        local cond, same = { id = c.id }, true
        if #c.caps == 0 then return cond end
        for k, name in ipairs(c.caps) do
          if name == "spell" and cond.spell then
            same = same and (caps[k] == cond.spell)
          else
            cond[name] = caps[k]
          end
        end
        if same then return cond end
      end
    end
  end
  return { id = "raw", text = trim(clause) }
end

function Model.parseConds(text)
  local out = {}
  for _, part in ipairs(Model.splitAnd(text)) do
    if part ~= "" then out[#out + 1] = Model.parseCond(part) end
  end
  return out
end

function Model.render(c)
  local V = vocab()
  return (fill(Model.COND[c.id].tpl, V):gsub("%$S", c.spell or ""):gsub("%$N", c.num or ""))
end

function Model.condText(conds)
  local out = {}
  for _, c in ipairs(conds) do
    local s
    if c.id == "raw" then
      s = trim(c.text or "")
      if #conds > 1 and s ~= "" and not s:match("^%(.*%)$") then s = "(" .. s .. ")" end
    else
      s = Model.render(c)
    end
    if s ~= "" then out[#out + 1] = s end
  end
  return table.concat(out, " " .. vocab()["and"] .. " ")
end

function Model.fromRot(rot)
  local m = {
    id = rot.explicitId, name = rot.name, class = rot.class, spec = rot.spec or "", tree = rot.tree, mode = rot.mode,
    author = rot.author or "", version = rot.version, description = rot.description or "",
    spells = {}, auras = {}, actions = {},
  }
  for _, key in ipairs(rot.spellOrder) do m.spells[#m.spells + 1] = { key = key, id = rot.spells[key] } end
  for _, key in ipairs(rot.auraOrder) do m.auras[#m.auras + 1] = { key = key, id = rot.auras[key] } end
  for _, a in ipairs(rot.actions) do
    m.actions[#m.actions + 1] = { key = a.key, note = a.note or "", conds = a.condText and Model.parseConds(a.condText) or {} }
  end
  return m
end

-- Una linea de cabecera o una nota no pueden llevar saltos ni "#" (empezaria un comentario).
local function clean(s) return trim((s or ""):gsub("[\r\n#]", " "):gsub("%s+", " ")) end

function Model.toText(m)
  local V = vocab()
  local L = {}
  if m.id then L[#L + 1] = "id: " .. clean(m.id) end
  L[#L + 1] = V.rotation .. ": " .. clean(m.name)
  L[#L + 1] = V.class .. ": " .. m.class
  if clean(m.spec) ~= "" then L[#L + 1] = V.spec .. ": " .. clean(m.spec) end
  if m.tree then L[#L + 1] = V.tree .. ": " .. m.tree end
  if m.mode then L[#L + 1] = V.mode .. ": " .. m.mode end
  if clean(m.author) ~= "" then L[#L + 1] = V.author .. ": " .. clean(m.author) end
  if m.version then L[#L + 1] = V.version .. ": " .. clean(tostring(m.version)) end
  if clean(m.description) ~= "" then L[#L + 1] = V.description .. ": " .. clean(m.description) end
  L[#L + 1] = ""
  for _, s in ipairs(m.spells) do L[#L + 1] = ("%s %s = %d"):format(V.spell, s.key, s.id) end
  for _, s in ipairs(m.auras) do L[#L + 1] = ("%s %s = %d"):format(V.aura, s.key, s.id) end
  L[#L + 1] = ""
  for _, a in ipairs(m.actions) do
    local line = V.action .. " " .. a.key
    local cond = Model.condText(a.conds)
    if cond ~= "" then line = line .. " " .. V["if"] .. " " .. cond end
    local note = clean(a.note):gsub("%-%-", "-")
    if note ~= "" then line = line .. " -- " .. note end
    L[#L + 1] = line
  end
  return table.concat(L, "\n") .. "\n"
end

function Model.new(class, author, tree)
  return { name = "", class = class, spec = "", tree = tree, author = author or "", description = "",
           spells = {}, auras = {}, actions = {} }
end

-- La clave de un hechizo nuevo sale de su nombre: "Descarga de las Sombras" -> descarga_de_las_sombras.
function Model.keyFor(m, name, id)
  for _, s in ipairs(m.spells) do
    if s.id == id then return s.key end
  end
  local base = ns.Format.norm(name):gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
  if base == "" or base:match("^%d") then base = "s" .. base end
  if ns.Expr.KEYWORDS[base] or base == "si" or base == "if" then base = base .. "_" end
  local taken = {}
  for _, s in ipairs(m.spells) do taken[s.key] = true end
  for _, s in ipairs(m.auras) do taken[s.key] = true end
  local key, i = base, 2
  while taken[key] do
    key = base .. "_" .. i
    i = i + 1
  end
  m.spells[#m.spells + 1] = { key = key, id = id }
  return key
end

function Model.addAction(m, name, id)
  local key = Model.keyFor(m, name, id)
  m.actions[#m.actions + 1] = { key = key, note = "", conds = {} }
  return #m.actions
end

function Model.move(m, i, delta)
  local j = i + delta
  if j < 1 or j > #m.actions then return i end
  m.actions[i], m.actions[j] = m.actions[j], m.actions[i]
  return j
end

function Model.idOf(m, key)
  for _, s in ipairs(m.spells) do if s.key == key then return s.id end end
  for _, s in ipairs(m.auras) do if s.key == key then return s.id end end
end

-- Texto corto de las condiciones para la lista.
function Model.summary(m, action, nameOf)
  if #action.conds == 0 then return ns.L.condAlways end
  local out = {}
  for _, c in ipairs(action.conds) do
    if c.id == "raw" then
      out[#out + 1] = c.text or ""
    else
      local s = Model.label(c.id)
      if c.spell then s = s .. " «" .. nameOf(c.spell) .. "»" end
      if c.num then s = s .. " " .. c.num end
      out[#out + 1] = s
    end
  end
  return table.concat(out, "; ")
end
