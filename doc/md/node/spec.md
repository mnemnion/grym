# Spec


  A small test harness to exercise our fresh Node class.

### includes

```lua
local Grammar = require "node/grammar"
local Node = require "node/node"
local L = require "node/elpeg"


```
## Trivial Grammar

This should succeed under all circumstances.


I'd have to guess what it will return currently. 

```lua
local function epsilon(_ENV)
  START = "any"
  any = P(1)^1 
end 
```