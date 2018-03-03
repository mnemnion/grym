-- * Handle Module
--

local L = require "lpeg"

local Node = require "peg/node"
local u = require "../lib/util"

local m = require "grym/morphemes"

local H, h = u.inherit(Node)

function h.matchHandle(line)
    local handlen = L.match(L.C(m.handle), line)
    if handlen then
        return handlen
    else
        u.freeze("h.matchHandle fails to match a handle")
    end
end

local function new(Handle, line)
    io.write("making a handle yo\n")
    local handle = setmetatable({}, H)
    handle.id = "handle"
    handle.val = h.matchHandle(line):sub(2, -1)
    return handle
end

return u.export(h, new)