
local component = require("component")

for address, ctype in component.list() do
    -- print(address, ctype)
    -- print("-", ctype, "-")
    if ctype == "gt_machine" then
        -- print('hey')
        local machineProxy = component.proxy(address, "gt_machine")
        print("cur machine: " , machineProxy.getName())
        for name, _ in pairs(component.methods(address)) do
            print("  ", name)
        end
        break
    end
end

-- alias clean="rm -f temp.lua"
-- alias ec="edit temp.lua"
-- alias run="temp.lua"