
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

local epeg = require "peg/epeg"
local u = require "lib/util"
local a = require "lib/ansi"

local inverter = require "invert/inverter"

local function strHas(substr, str)
    return L.match(epeg.anyP(substr), str)
end

local function endsWith(substr, str)
    return L.match(L.P(string.reverse(substr)),
        string.reverse(str))
end

-- Finds the last match for a literal substring and replaces it
-- with =swap=, returning the new string.
--
local function subLastFor(match, swap, str)
    local trs, hctam = string.reverse(str), string.reverse(match)
    local first, last = strHas(hctam, trs)
    if last then
        -- There is some way to do this without reversing the string twice,
        -- but I can't be arsed to find it. ONE BASED INDEXES ARE A MISTAKE
        return string.reverse(trs:sub(1, first - 1) 
            .. string.reverse(swap) .. trs:sub(last, -1))
    else
        u.freeze("didn't find an instance of " .. match .. " in string: " .. str)
    end 
end


-- Walks a given directory, inverting the contents of =/src/=
-- into =/org/=. 
-- 
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
                    local org_dir = dirname(subLastFor("/src", "/org", f))
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