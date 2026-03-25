local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local interface = current_component.proxy("f9f5683a-4731-4323-ad74-980e327b9782", "me_interface")
local db = current_component.proxy("077c0408-8271-46b4-afa7-fdd0af436b79", "database")


-- local testbee = {}
-- for item in interface.allItems() do
--      if string.find(item.name, "Forestry:beePrincessGE") then 
--         testbee = item 
--         break 
--     end 
-- end

-- print(testbee)

-- print(testbee[1])

-- for k, v in pairs(testbee) do
--     print(k, v)
-- end

db.set(1, "Forestry:beePrincessGE", 10)

-- interface.store( { ["tag"] = testbee[1].tag } , db.address )
-- coolant_interface_db.set(db_index_coolant, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", coolant_name))
local db_index = 9
db.set(db_index, "Forestry:beePrincessGE", 0, "{ Genome : {Chromosomes:[0:{Slot:0b,UID0:\"gregtech.bee.speciesAmericium\"} }")
interface.setInterfaceConfiguration(1, db.address, db_index)



local db_index = 8
db.set(db_index, "Forestry:beePrincessGE", 0, "{ Genome : { Chromosomes[0] : {Slot:0,UID0:\"gregtech.bee.speciesAmericium\"} }")
interface.setInterfaceConfiguration(2, db.address, db_index)

local db_index = 7
db.set(db_index, "Forestry:beePrincessGE", 0, "Genome:{Chromosomes:[0:{Slot:0b,UID0:\"gregtech.bee.speciesAmericium\",UID1:\"gregtech.bee.speciesAmericium\"}]}")
interface.setInterfaceConfiguration(3, db.address, db_index)

local db_index = 6
db.set(db_index, "gregtech:gt.comb", 49)
interface.setInterfaceConfiguration(4, db.address, db_index)



local db_index = 5
db.set(db_index, "Forestry:beePrincessGE", 0, 
"Genome:{Chromosomes:[0:{Slot:0b,UID0:\"gregtech.bee.speciesAmericium\",UID1:\"gregtech.bee.speciesAmericium\"},1:{Slot:1b,UID0:\"magicbees.speedBlinding\",UID1:\"magicbees.speedBlinding\"},2:{Slot:2b,UID0:\"forestry.lifespanLongest\",UID1:\"forestry.lifespanLongest\"},3:{Slot:3b,UID0:\"forestry.fertilityMaximum\",UID1:\"forestry.fertilityMaximum\"},4:{Slot:4b,UID0:\"forestry.toleranceBoth4\",UID1:\"forestry.toleranceBoth4\"},5:{Slot:5b,UID0:\"forestry.boolTrue\",UID1:\"forestry.boolTrue\"},6:{Slot:7b,UID0:\"forestry.toleranceBoth4\",UID1:\"forestry.toleranceBoth4\"},7:{Slot:8b,UID0:\"forestry.boolFalse\",UID1:\"forestry.boolFalse\"},8:{Slot:9b,UID0:\"forestry.boolFalse\",UID1:\"forestry.boolFalse\"},9:{Slot:10b,UID0:\"forestry.flowersVanilla\",UID1:\"forestry.flowersVanilla\"},10:{Slot:11b,UID0:\"forestry.floweringSlowest\",UID1:\"forestry.floweringSlowest\"},11:{Slot:12b,UID0:\"forestry.territoryLarger\",UID1:\"forestry.territoryLarger\"},12:{Slot:13b,UID0:\"forestry.effectNone\",UID1:\"forestry.effectNone\"}]}"
)
interface.setInterfaceConfiguration(5, db.address, db_index)

local db_index = 4
db.set(db_index, "Forestry:beePrincessGE", 0, 
"{Mate:{Chromosomes:[0:{Slot:0b,UID0:\"gregtech.bee.speciesAmericium\",UID1:\"gregtech.bee.speciesAmericium\"}]},Genome:{Chromosomes:[0:{Slot:0b,UID0:\"gregtech.bee.speciesAmericium\",UID1:\"gregtech.bee.speciesAmericium\"}]}}"
)
interface.setInterfaceConfiguration(6, db.address, db_index)

local db_index = 3
db.set(db_index, "Forestry:beePrincessGE", 0, 
"{Mate:{Chromosomes:[0:{Slot:0b,UID0:\"extrabees.species.rock\",UID1:\"extrabees.species.rock\"}]},Genome:{Chromosomes:[0:{Slot:0b,UID0:\"extrabees.species.rock\",UID1:\"extrabees.species.rock\"}]}}"
)
interface.setInterfaceConfiguration(7, db.address, db_index)


local ok, err = pcall(function()
    interface.store(db.get(3), db.address, 16)
end)

print("  store attempt 1: ok=" .. tostring(ok) .. (err and (" err=" .. tostring(err)) or ""))





-- db.get(1)

-- alias clean="rm -f silly.lua"
-- alias ec="edit silly.lua"
-- alias run="silly"