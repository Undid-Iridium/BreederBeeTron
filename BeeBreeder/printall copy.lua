
local current_component = require("component")
local machineProxy = current_component.proxy("c1a281d2-211a-4eb9-bd71-fa5fee8ceaff", "gt_machine")

print("cur machine: " , machineProxy.getName())
for name, _ in pairs(current_component.methods("c1a281d2-211a-4eb9-bd71-fa5fee8ceaff")) do
    print("  ", name)
end



-- for address, ctype in component.list() do
--     print(address, ctype)
--     -- print("-", ctype, "-")
--     if ctype == "gt_machine" then
--         -- print('hey')
--         local machineProxy = component.proxy(address, "gt_machine")
--         print("cur machine: " , machineProxy.getName())
--         for name, _ in pairs(component.methods(address)) do
--             print("  ", name)
--         end
--         break
--     end

    
-- end

-- alias clean="rm -f temp.lua"
-- alias ec="edit temp.lua"
-- alias run="temp.lua"