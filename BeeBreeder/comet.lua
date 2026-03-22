-- local cur_transposer = component.proxy(component.list('transposer')())
-- local max = cur_transposer.getTankCapacity(1)

local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local hydro_transposer = current_component.proxy("f76b34a5-2aa5-44de-948f-8152ed968f17", "transposer")
local unknown_partical_transposer = current_component.proxy("a5bf7302-98cf-4093-9caa-e593efbde6e1", "transposer")
local quantum_anomaly_transposer = current_component.proxy("589ff1f6-e41c-4785-be9d-fcf00cfc97ee", "transposer")
-- local temp = current_component.proxy("6117fa01-b4ba-4e77-9638-9ec2d2f5ae6e", "adapter")
local hydro_me_interface = current_component.proxy("5fc3698d-4aa7-4d2f-b1b2-74d855e2aa24", "me_interface")
local unknown_particle_me_interface = current_component.proxy("03808a06-ecf5-4e34-a73d-c6978be177fd", "me_interface")
local quantum_anomaly_me_interface = current_component.proxy("82234f8e-d97d-4851-8ac3-18cb8555dfc9", "me_interface")

local unknown_particle_database  = current_component.proxy("cfc57228-ce8e-4f61-898c-31aba9215700", "database")
local hydrogen_atom_database  = current_component.proxy("92c3bf50-e07d-4fbb-9596-9ef12d661175", "database")
local quantum_anomaly_database  = current_component.proxy("c4773943-069b-48ce-8c96-ed3917c54022", "database")
-- local hydro_me_interface_upgrade = current_component.proxy("5fc3698d-4aa7-4d2f-b1b2-74d855e2aa24", "upgrade_me")
-- setFluidInterfaceConfiguration 


-- local count = 0
-- for k, v in pairs(current_me_interface.getFluidsInNetwork()) do
--     if count > 20 then
--         break
--     end
--     for sub_k, sub_v in pairs(v) do
--         print(" Each item table ", sub_k, sub_v, type(sub_v))
--     end
--     print(k, v, type(v))
--     count = count + 1

-- end



local function set_hydrogen_atom_fluid()
    local fluid_name = "Hydrogen"
    local db_index = 1
    local damage = 0
    local fluid_index = 0

    hydrogen_atom_database.set(db_index, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", fluid_name))
    hydro_me_interface.setFluidInterfaceConfiguration(fluid_index, hydrogen_atom_database.address, db_index)
end


-- If there are unknown particle then do not do this, if there are hydrogen atoms, also do not do this

local function generate_hydrogen_atom()
    -- hydro_me_interface.getItemInNetwork(1, 0)
    -- hydro_me_interface_upgrade.requestFluids(current_component.database.address, 1, 1000)
    hydro_transposer.transferFluid(sides.south, sides.down)
end

local function set_unknown_particle_fluid()
    -- local item_name_id = "9816"
    -- local item_name = "Hydrogen Ion"
    local fluid_name = "Hydrogen"
    local db_index = 2
    local damage = 0
    local fluid_index = 0
    unknown_particle_database.set(db_index, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", fluid_name))
    unknown_particle_me_interface.setFluidInterfaceConfiguration(fluid_index, unknown_particle_database.address, db_index)
end

local function generate_unknown_particle()
    
    -- hydro_me_interface.getItemInNetwork(1, 0)
    -- hydro_me_interface_upgrade.requestFluids(current_component.database.address, 1, 1000)
    unknown_partical_transposer.transferFluid(sides.east, sides.down)

    -- -- current_component.database.set(db_index, "particleHydrogen", damage, string.format("{ id: %s}", item_name_id) )
    -- -- {Damage:0s,id:9816s,tag:{Ion:{Charge:6L}},Count:1b}
    -- cur_database.set(db_index, "particleHydrogen", damage, "{Damage:0s,id:9816s,tag:{Ion:{Charge:5L}},Count:1b}" )
    -- -- cur_database.set(db_index, "particleHydrogen", damage)
    -- -- current_component.database.clear(2)
    -- -- current_component.database.set(db_index, "Hydrogen Ion", damage)
    -- unknown_particle_me_interface.setInterfaceConfiguration(1, cur_database.address, db_index)
    -- -- unknown_particle_me_interface.getItemInNetwork(item_name_id)
    -- unknown_partical_transposer.transferItem(sides.south, sides.down)
end

local function generate_quantum_anomaly()
    local db_index = 9
    -- cur_database.set(db_index, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", fluid_name))
    -- cur_database.set(db_index, "particleBase", damage) ITEM TOO DUMB
    quantum_anomaly_me_interface.setInterfaceConfiguration(1, quantum_anomaly_database.address, db_index)
    -- hydro_me_interface.getItemInNetwork(1, 0)
    -- hydro_me_interface_upgrade.requestFluids(current_component.database.address, 1, 1000)
    return quantum_anomaly_transposer.transferItem(sides.south, sides.down)
end


local function keyboardEvent(eventName, keyboardAddress, charNum, codeNum, playerName)
    if charNum == 113 then
        NeedExitFlag = true
        return false
    end
end

local function initEvents()
    NeedExitFlag = false
end


local function hookEvents()
    event.listen("key_down", keyboardEvent)
end

initEvents()
hookEvents()

local thread = require("thread")

local timeout = 5 -- seconds
thread.create(function(a, b)
    while true do
        local name, addr, char, code = event.pull(timeout, "key_down")
        if name == "key_down" then
            if code == 209 then -- 209 is PageDown
              print("PageDown pressed. Stopping.")
              NeedExitFlag = true
              return
            end
        end
        computer.pullSignal(1)
    end
end)

local function process_anomaly_check()
    if (generate_quantum_anomaly() <= 0) then
        print(os.date(), " : No anomaly could be sent, no hydrogen to process, running generate_hydrogen_atom, then generate_unknown_particle - Exit flag: ", NeedExitFlag)
        generate_hydrogen_atom()
        generate_unknown_particle()
        -- if(unknown_partical_transposer.getFluidInTank(sides.down, 1).amount == 0) then
        --     print(os.date(), " : No anomaly could be sent, no hydrogen to process, running generate_hydrogen_atom, then generate_unknown_particle - Exit flag: ", NeedExitFlag)
        --     generate_hydrogen_atom()
        --     generate_unknown_particle()
        -- else
        --     print(os.date(), " : No anomaly could be sent, hydrogen atom available, generate_unknown_particle - Exit flag: ", NeedExitFlag)
        --     generate_unknown_particle()
        -- end
        os.sleep(5)
    end
end

set_hydrogen_atom_fluid()
set_unknown_particle_fluid()


while NeedExitFlag ~= true do
    if quantum_anomaly_transposer ~= nil then
        local current_stack = quantum_anomaly_transposer.getStackInSlot(sides.down, 1) 
        if current_stack == nil then
            process_anomaly_check()
        elseif current_stack.size == 0 then
            process_anomaly_check()
        else
            print(os.date(), " : Anomaly is in slot, and is waiting for processing - Exit flag: ", NeedExitFlag)
        end
    else
        print(os.date(), " : Quantum transposer was null.. - Exit flag: ", NeedExitFlag)
    end
    os.sleep(5)
    -- computer.pullSignal(5)
end


-- hydro_me_interface.setFluidInterfaceConfiguration(0)




-- hydro_me_interface.setFluidInterfaceConfiguration ()


-- local me=require("component").upgrade_me





-- Minimum fluid amount that guarantees maximum output
-- local min = math.ceil((1-math.sqrt(0.001))*max/2)

-- while true do
--   -- Extract Fluid (0=Down, 1=Up)
--   local level = cur_transposer.getTankLevel(1)
--   if level > min then
--     cur_transposer.transferFluid(1, 0, level-min)
--   end

--   -- Sleep 5 Seconds
--   computer.pullSignal(5)
-- end