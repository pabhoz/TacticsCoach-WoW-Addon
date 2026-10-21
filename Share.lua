-- Mandar una rotacion a otro jugador por canal de addon (grupo, banda, hermandad, susurro).
-- El texto viaja escapado y en trozos; el que la recibe decide si la guarda.
--
--   H~<id>~<trozos>~<nombre>      cabecera
--   D~<id>~<n>~<datos>~           trozo n (el ~ final protege los espacios del borde)
local _, ns = ...
ns = ns or TacticsCoachNS
local Share = { queue = {}, inbox = {} }
ns.Share = Share

local PREFIX = "TCOACH"
local CHUNK = 200
local MAX_CHUNKS = 60
local SEND_EVERY = 0.15
local INBOX_TTL = 60

function Share.escape(s)
  return (s:gsub("\r", ""):gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("|", "\\p"):gsub("~", "\\t"))
end

function Share.unescape(s)
  return (s:gsub("\\(.)", function(c)
    if c == "n" then return "\n" elseif c == "p" then return "|" elseif c == "t" then return "~" end
    return c
  end))
end

function Share.encode(text, id, name)
  local esc = Share.escape(text)
  local parts = {}
  for i = 1, #esc, CHUNK do parts[#parts + 1] = esc:sub(i, i + CHUNK - 1) end
  local msgs = { ("H~%s~%d~%s"):format(id, #parts, Share.escape(name):sub(1, 60)) }
  for i, p in ipairs(parts) do msgs[#msgs + 1] = ("D~%s~%d~%s~"):format(id, i, p) end
  return msgs
end

-- Devuelve nombre, texto cuando un mensaje completa una rotacion.
function Share.receive(sender, msg, now)
  local hid, n, name = msg:match("^H~(%w+)~(%d+)~(.*)$")
  if hid then
    n = tonumber(n)
    if n >= 1 and n <= MAX_CHUNKS then
      Share.inbox[sender .. "~" .. hid] = { n = n, name = Share.unescape(name), parts = {}, got = 0, t = now }
    end
    return
  end
  local did, idx, data = msg:match("^D~(%w+)~(%d+)~(.*)~$")
  if not did then return end
  local key = sender .. "~" .. did
  local box = Share.inbox[key]
  idx = tonumber(idx)
  if not box or idx < 1 or idx > box.n or box.parts[idx] then return end
  box.parts[idx], box.got = data, box.got + 1
  if box.got == box.n then
    Share.inbox[key] = nil
    return box.name, Share.unescape(table.concat(box.parts))
  end
end

-- Lo de abajo solo corre dentro del juego.

local driver
local function pump(self, elapsed)
  self.wait = (self.wait or 0) - elapsed
  if self.wait > 0 then return end
  self.wait = SEND_EVERY
  local m = table.remove(Share.queue, 1)
  if m then
    SendAddonMessage(PREFIX, m[1], m[2], m[3])
  else
    self:Hide()
  end
end

function Share.init()
  driver = CreateFrame("Frame")
  driver:Hide()
  driver:SetScript("OnUpdate", pump)

  StaticPopupDialogs.TC_IMPORT = {
    text = ns.L.shareImport,
    button1 = ns.L.save, button2 = ns.L.no,
    OnAccept = function(_, data)
      local rot, errs = ns.Library.import(data.text, data.from)
      if rot then
        ns.print(ns.L.shareSaved:format(rot.name))
        if ns.Config then ns.Config.refresh() end
      else
        ns.print(ns.L.shareSaveFailed .. "\n" .. ns.Format.formatErrors(errs))
      end
    end,
    timeout = 0, whileDead = 1, hideOnEscape = 1,
  }
end

function Share.onMessage(prefix, msg, _, sender)
  if prefix ~= PREFIX or sender == UnitName("player") then return end
  local now = GetTime()
  for k, box in pairs(Share.inbox) do
    if now - box.t > INBOX_TTL then Share.inbox[k] = nil end
  end
  local name, text = Share.receive(sender, msg, now)
  if name then
    local dialog = StaticPopup_Show("TC_IMPORT", sender, name)
    if dialog then dialog.data = { text = text, from = sender } end
  end
end

-- channel: "GROUP" (grupo o banda), "GUILD" o "WHISPER" con target.
function Share.send(rot, channel, target)
  if channel == "GROUP" then
    if GetNumRaidMembers() > 0 then
      channel = "RAID"
    elseif GetNumPartyMembers() > 0 then
      channel = "PARTY"
    else
      ns.print(ns.L.shareNoGroup)
      return
    end
  elseif channel == "GUILD" and not IsInGuild() then
    ns.print(ns.L.shareNoGuild)
    return
  elseif channel == "WHISPER" and (not target or target == "") then
    return
  end
  local msgs = Share.encode(rot.text, tostring(math.random(1000, 9999)), rot.name)
  if #msgs - 1 > MAX_CHUNKS then
    ns.print(ns.L.shareTooLong)
    return
  end
  for _, m in ipairs(msgs) do Share.queue[#Share.queue + 1] = { m, channel, target } end
  driver:Show()
  local where = { RAID = ns.L.toRaid, PARTY = ns.L.toParty, GUILD = ns.L.toGuild }
  ns.print(ns.L.shareSending:format(rot.name, where[channel] or target))
end
