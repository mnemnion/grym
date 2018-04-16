# Directory


``bridge`` is going to have a certain attitude toward directories.


The ``orb`` directory module will emulate and prototype that attitude.


- [ ] #todo  Add and use raw "lfs" dependency, since we already need it


- [ ] #todo  And this is the wrong place to put it but, phase out penlight.
             All I use is strict and wrappers around ``lfs``.

```lua
local Dir = {}
Dir.isDir = Dir
Dir.it = require "core/check"

local __Dirs = {} -- Cache to keep each Dir unique by Path
```
```lua
local pl_path = require "pl.path" -- Favor lfs directly
local lfs = require "lfs"
local attributes = lfs.attributes
local Path = require "walk/path"
local isdir  = pl_path.isdir
local mkdir = lfs.mkdir
```
```lua
local new
```
### Dir:exists()

```lua
function Dir.exists(dir)
  return isdir(dir.path.str)
end
```
```lua
function Dir.mkdir(dir)
  if dir:exists() then
    return false, "directory already exists"
  else
    local success, msg, code = mkdir(dir.path.str)
    if success then
      return success
    else
      code = tostring(code)
      s:complain("mkdir failure # " .. code, msg, dir)
      return false, msg
    end
  end
end
```
### Dir.swapDirFor(dir, nestDir, newNest)

The nomenclature isn't great here, which is my ignorance of
directory handling showing. But let's get through it.


It's easiest to illustrate:

```lua-example
a = Dir "/usr/local/bin/"
b = a:swapDirFor("/usr/", "/tmp")
tostring(b)
-- "/tmp/local/bin/"
```

It has to be a proper absolute path, which is currently enforced everywhere
a Path is used and will be until I start to add link resolution, since it's
the correct way to treat paths to things that happen to exist.  This is my
need at the moment.

```lua
function Dir.swapDirFor(dir, nestDir, newNest)
  local dir_str, nest_str = tostring(dir), tostring(nestDir)
  local first, last = string.find(dir_str, nest_str)
  if first == 1 then
    -- swap out
    return new(Path(tostring(newNest) .. string.sub(dir_str, last + 1)))
  else
    return nil, nest_str.. " not found in " .. dir_str
  end
end
```
```lua
function Dir.attributes(dir)
  return attributes(dir.path.str)
end
```
```lua
local function __tostring(dir)
  return dir.path.str
end
```
```lua
function new(path)
  if __Dirs[tostring(path)] then
    return __Dirs[tostring(path)]
  end
  local dir = setmetatable({}, {__index = Dir,
                               __tostring = __tostring})
  local path_str = ""
  if path.isPath then
    assert(path.isDir, "fatal: " .. tostring(path) .. " is not a directory")
    dir.path = path
  else
    local new_path = Path(path)
    assert(new_path.isDir, "fatal: " .. tostring(path) .. " is not a directory")
    dir.path = new_path
  end
  __Dirs[tostring(path)] = dir

  return dir
end
```
```lua
return new
```