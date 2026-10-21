-- Condiciones de las rotaciones: un lenguaje pequeno y cerrado.
--
-- Las rotaciones se comparten entre jugadores, asi que una condicion NUNCA es codigo Lua: se
-- parsea a un arbol y se compila a funciones que solo pueden leer las variables que expone
-- State.resolve. Nada de loadstring.
--
--   perjuicio.inmolar.restante < lanzamiento.inmolar y mana > 20
--   (sigilo o beneficio.danza.activo) and puntos <= 2
local _, ns = ...
ns = ns or TacticsCoachNS
local Expr = {}
ns.Expr = Expr

local KEYWORDS = {
  ["and"] = "and", y = "and",
  ["or"] = "or", o = "or",
  ["not"] = "not", no = "not",
  ["true"] = "true", verdadero = "true",
  ["false"] = "false", falso = "false",
}
Expr.KEYWORDS = KEYWORDS

local function fail(pos, msg) error({ pos = pos, msg = msg }, 0) end

local function tokenize(s)
  local toks, i, n = {}, 1, #s
  while i <= n do
    local c = s:sub(i, i)
    if c:match("%s") then
      i = i + 1
    elseif c:byte() >= 128 then
      fail(i, ns.L.exprAccent)
    else
      local num = s:match("^%d+%.?%d*", i)
      local id = not num and s:match("^[%a_][%w_]*", i)
      local two = s:sub(i, i + 1)
      if num then
        toks[#toks + 1] = { t = "num", v = tonumber(num), pos = i }
        i = i + #num
      elseif id then
        local kw = KEYWORDS[id:lower()]
        toks[#toks + 1] = kw and { t = kw, text = id, pos = i } or { t = "id", v = id, pos = i }
        i = i + #id
      elseif two == "<=" or two == ">=" or two == "==" or two == "~=" or two == "!=" then
        toks[#toks + 1] = { t = "op", v = (two == "!=") and "~=" or two, pos = i }
        i = i + 2
      elseif c == "<" or c == ">" then
        toks[#toks + 1] = { t = "op", v = c, pos = i }
        i = i + 1
      elseif c == "=" then
        toks[#toks + 1] = { t = "op", v = "==", pos = i }
        i = i + 1
      elseif c:match("[%+%-%*/%(%)%.]") then
        toks[#toks + 1] = { t = c, pos = i }
        i = i + 1
      else
        fail(i, ns.L.exprSign:format(c))
      end
    end
  end
  toks[#toks + 1] = { t = "eof", pos = n + 1 }
  return toks
end

local function parse(s)
  local toks, p = tokenize(s), 1
  local function peek() return toks[p] end
  local function take() p = p + 1; return toks[p - 1] end
  local function show(t) return t.text or (t.v and tostring(t.v)) or t.t end

  local expr

  local function primary()
    local t = take()
    if t.t == "num" then
      return { k = "const", v = t.v }
    elseif t.t == "true" or t.t == "false" then
      return { k = "const", v = (t.t == "true") }
    elseif t.t == "id" then
      local path = { t.v }
      while peek().t == "." do
        take()
        -- Despues de un punto, "y" o "no" son nombres: ahi no pueden ser operadores.
        local nt = take()
        local name = (nt.t == "id") and nt.v or nt.text
        if not name then fail(nt.pos, ns.L.exprAfterDot) end
        path[#path + 1] = name
      end
      return { k = "var", path = path, pos = t.pos }
    elseif t.t == "(" then
      local e = expr()
      if take().t ~= ")" then fail(toks[p - 1].pos, ns.L.exprParen) end
      return e
    elseif t.t == "-" then
      return { k = "neg", a = primary() }
    elseif t.t == "eof" then
      fail(t.pos, ns.L.exprEarlyEnd)
    else
      fail(t.pos, ns.L.exprUnexpected:format(show(t)))
    end
  end

  local function term()
    local a = primary()
    while peek().t == "*" or peek().t == "/" do
      local op = take().t
      a = { k = "arith", op = op, a = a, b = primary() }
    end
    return a
  end

  local function sum()
    local a = term()
    while peek().t == "+" or peek().t == "-" do
      local op = take().t
      a = { k = "arith", op = op, a = a, b = term() }
    end
    return a
  end

  local function cmp()
    local a = sum()
    if peek().t == "op" then
      local op = take().v
      a = { k = "cmp", op = op, a = a, b = sum() }
    end
    return a
  end

  local function notx()
    if peek().t == "not" then
      take()
      return { k = "not", a = notx() }
    end
    return cmp()
  end

  local function andx()
    local a = notx()
    while peek().t == "and" do
      take()
      a = { k = "and", a = a, b = notx() }
    end
    return a
  end

  function expr()
    local a = andx()
    while peek().t == "or" do
      take()
      a = { k = "or", a = a, b = andx() }
    end
    return a
  end

  local ast = expr()
  if peek().t ~= "eof" then fail(peek().pos, ns.L.exprTrailing:format(show(peek()))) end
  return ast
end

local function catch(ok, res)
  if ok then return res end
  if type(res) == "table" then return nil, res.msg, res.pos end
  return nil, tostring(res)
end

-- Devuelve el arbol, o nil + mensaje + posicion.
function Expr.parse(s)
  return catch(pcall(parse, s))
end

-- Los booleanos valen 1 y 0 en las cuentas; nil vale 0.
local function num(v)
  if v == true then return 1 elseif not v then return 0 end
  return v
end

local function truthy(v) return v ~= nil and v ~= false and v ~= 0 end
Expr.truthy = truthy

local CMP = {
  ["<"] = function(a, b) return a < b end,
  ["<="] = function(a, b) return a <= b end,
  [">"] = function(a, b) return a > b end,
  [">="] = function(a, b) return a >= b end,
  ["=="] = function(a, b) return a == b end,
  ["~="] = function(a, b) return a ~= b end,
}

local ARITH = {
  ["+"] = function(a, b) return a + b end,
  ["-"] = function(a, b) return a - b end,
  ["*"] = function(a, b) return a * b end,
  ["/"] = function(a, b) if b == 0 then return 0 end return a / b end,
}

-- resolve(path) devuelve una funcion getter(ctx), o nil + mensaje si la variable no existe.
-- El resultado es una funcion f(ctx) que devuelve un numero o un booleano.
function Expr.compile(ast, resolve)
  local function c(n)
    if n.k == "const" then
      local v = n.v
      return function() return v end
    elseif n.k == "var" then
      local g, msg = resolve(n.path)
      if not g then fail(n.pos, msg) end
      return g
    elseif n.k == "not" then
      local a = c(n.a)
      return function(ctx) return not truthy(a(ctx)) end
    elseif n.k == "and" then
      local a, b = c(n.a), c(n.b)
      return function(ctx) return truthy(a(ctx)) and truthy(b(ctx)) end
    elseif n.k == "or" then
      local a, b = c(n.a), c(n.b)
      return function(ctx) return truthy(a(ctx)) or truthy(b(ctx)) end
    elseif n.k == "cmp" then
      local f, a, b = CMP[n.op], c(n.a), c(n.b)
      return function(ctx) return f(num(a(ctx)), num(b(ctx))) end
    elseif n.k == "arith" then
      local f, a, b = ARITH[n.op], c(n.a), c(n.b)
      return function(ctx) return f(num(a(ctx)), num(b(ctx))) end
    elseif n.k == "neg" then
      local a = c(n.a)
      return function(ctx) return -num(a(ctx)) end
    end
    error("nodo desconocido: " .. tostring(n.k))
  end
  return catch(pcall(c, ast))
end
