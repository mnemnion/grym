 


```lua
local L = require "lpeg"

local pl_file = require "pl.file"
local pl_dir = require "pl.dir"
local pl_path = require "pl.path"
local getfiles = pl_dir.getfiles
local makepath = pl_dir.makepath
local getdirectories = pl_dir.getdirectories
local extension = pl_path.extension
local dirname = pl_path.dirname
local basename = pl_path.basename
local read = pl_file.read
local write = pl_file.write
local isdir = pl_path.isdir


local walk = require "walk"
local strHas = walk.strHas
local endsWith = walk.endsWith
local subLastFor = walk.subLastFor

local epeg = require "epeg"
local u = require "util"
local a = require "ansi"

local inverter = require "invert/inverter"
```
```lua
local function invert_dir(inverter, pwd, depth)
    local depth = depth + 1
    for dir in pl_dir.walk(pwd, false, false) do
        if not strHas(".git", dir) and isdir(dir)
            and not strHas("src/lib", dir) then

            local files = getfiles(dir)
            io.write(("  "):rep(depth) .. "* " .. dir .. "\n")
            local subdirs = getdirectories(dir)
            for _, f in ipairs(files) do
                if (inverter.extension == extension(f)) then
                    local org_dir = subLastFor("/src", "/org", dirname(f))
                    makepath(org_dir)
                    local bare_name = basename(f):sub(1, -(#inverter.extension + 1))
                    local out_name = org_dir .. "/" .. bare_name .. ".gm"
                    write(out_name, inverter:invert(read(f)))
                    io.write(("  "):rep(depth) .. "  - " .. out_name .. "\n")
                end
            end
            for _, d in ipairs(subdirs) do
                invert_dir(inverter, d, depth)
            end
        end
    end
end

local function invert_all(inverter, pwd)
    for dir in pl_dir.walk(pwd, false, false) do
        if not strHas(".git", dir) and isdir(dir) 
            and endsWith("src", dir) then

            return invert_dir(inverter, dir, 0)
        end
    end
    return false
end

inverter.invert_all = invert_all


return inverter
```
