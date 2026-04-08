local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')


local altar_add=""
for address, ctype in current_component.list() do
    -- print(address, ctype)
    -- print("-", ctype, "-")
    if ctype == "blood_altar" then
        -- local machineProxy = current_component.proxy(address, "gt_machine")
        -- print("cur machine: " , machineProxy.getName())
        altar_add = address
    end
end

-- alias clean="rm -f temp.lua"
-- alias ec="edit temp.lua"
-- alias run="temp.lua"

local altar = current_component.proxy(altar_add, "blood_altar")

print("How much blood do we have in altar: " .. altar.getCurrentBlood())