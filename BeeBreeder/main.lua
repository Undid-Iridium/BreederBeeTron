local current_component = require('component')
local transposer = current_component.proxy("f3a523de-f6d4-45f4-a2cf-f0e8aadfa9aa", "transposer")
local adapter = current_component.proxy("address", "adapter")
local bee_api = current_component.proxy("address", "beekeeper")
-- local config = require("config")
-- local filesystem = require("filesystem")
-- local event = require("event")

local config = {
    ["bottom"] = 0,
    ["top"] = 1,
    ["back"] = 2,
    ["front"] = 3,
    ["right"] = 4,
    ["left"] = 5,
}


function areGenesEqual(geneTable)
    for gene,value in pairs(geneTable.active) do
        if type(value) == "table" then
            for name,tValue in pairs(value) do
                if geneTable.inactive[gene][name] ~= tValue then
                    return false
                end
            end
        elseif value ~= geneTable.inactive[gene] then
            return false
        end
    end
    return true
end

print(transposer.address)

for name, side in pairs(config) do
    print("Side name:", name, "Side number:", side)
    
    -- Example: check items on this side
    if transposer.getInventorySize(side) then
        local size = transposer.getInventorySize(side)
        print("Items on this side:", size)

        if size > 100 then
            print("This is chest")
            print(transposer.getAllStacks(side))
            local stack = transposer.getStackInSlot(side, 1)
            print(stack.individual)
            print("Trying")
            print(transposer.getStackInSlot(side, 1).label)
            print(transposer.getStackInSlot(side, 1).tag)
            print(transposer.getStackInSlot(side, 1).name)
        end
    end
end



-- 3c1c0e82-a151-4231-a5bc-bc238adf5ade
-- tile_for_apiculture_0_name


-- local alveary_address = "3c1c0e82-a151-4231-a5bc-bc238adf5ade"

-- local alveary = current_component.proxy(alveary_address, "adapter")

-- alveary.





