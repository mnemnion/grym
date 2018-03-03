-- * Handleline module
--
--   A minimalist Node container for a handle line.

local Node = require "peg/node"
local u = require "../lib/util"

local Handle = require "grym/handle"

local H, h = u.inherit(Node)

local function new(Hashline, line)
    local handleline = setmetatable({}, H)
    handleline.id = "handleline"
    handleline[1] = Handle(line)

    return handleline
end


return u.export(h, new)