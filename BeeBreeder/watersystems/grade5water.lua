-- local cur_transposer = component.proxy(component.list('transposer')())
-- local max = cur_transposer.getTankCapacity(1)

local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local helium_plasma_transposer = current_component.proxy("342bcc77-0447-4ee7-8cf5-baa578e39f62", "transposer")
local coolant_transposer = current_component.proxy("38842681-ccea-4257-8b55-3c453ad29e53", "transposer")
-- local temp = current_component.proxy("6117fa01-b4ba-4e77-9638-9ec2d2f5ae6e", "adapter")
local helium_plasma_interface = current_component.proxy("52d4bba2-21f3-4235-af50-ff301bd6a466", "me_interface")
local coolant_interface = current_component.proxy("633f76d0-16e4-4b47-a409-2e5fafd84a2b", "me_interface")

local helium_plasma_interface_db = current_component.proxy("63114057-ae92-4a19-95d7-7f244d3631dd", "database")
local coolant_interface_db = current_component.proxy("57a78c64-9707-4028-8108-1c5d2ef69a6e", "database")

local system_state = current_component.proxy("7345483f-9fcc-460e-afce-938a6653d024", "redstone")
local machineProxy = current_component.proxy("c1a281d2-211a-4eb9-bd71-fa5fee8ceaff", "gt_machine")

local thread = require('thread')
local event = require('event')
local term = require('term')
local thread = require("thread")

local keyHandler = thread.create(function()
    local keyboard = require('keyboard')
    while true do
      _, _, _, code, _ = term.pull('key_down')
    --   if code == keyboard.keys.p then printDashboard()
    --   elseif code == keyboard.keys.u then
    --     pumps = {}
    --     findPumps()
    --   end
    end
  end)

local function print_d(msg)
    print(os.date() .. " : " .. msg)
end


-- raise 10 times (add 100L/s of helium plasma, 100k per hit = 1000k)
-- raise 1 time (1000L/s)
-- reduce 200 times (5k per hit, 200 * 5k = 1000k, 100L/s)
-- faster reduce 20 times (1000L/s)
-- fasterr 2 times (10000L/s)
-- so
-- raise 1 (1000L)
-- wait 1 second
-- reduce 1 (10000L)
-- wait 1 second
-- reduce 1 (10000L)
-- wait 1 second
-- wait 1 second
-- repeat 3 times in total.
-- pause for remaining time (wait for time or wait for restone switch)


local function transfer_coolant()
    local count = 0
    while count < 10 do
        coolant_transposer.transferFluid(sides.south, sides.north, 200) 
        count = count + 1
    end
end

local function regulate_system()

    -- hydro_me_interface.getItemInNetwork(1, 0)
    -- hydro_me_interface_upgrade.requestFluids(current_component.database.address, 1, 1000)

    local count = 0
    while count < 3 do
        print_d( "Transferring helium")
        helium_plasma_transposer.transferFluid(sides.west, sides.east, 100)
        os.sleep(11) -- 10L/S so 10 seconds to get to 1000k (100K * 10) -> 10 seconds
        print_d("Transferring coolant")
        transfer_coolant() -- 100L/S so 10000/100 -> 100 seconds? -> 10000 - 200 runs needed 
        os.sleep(21)
        count = count + 1
    end
end

-- 100 * 20 = 2000L
-- 1,000,000
-- /   5,000
-- = 200

-- alias clean="rm -f grade5water.lua"
-- alias ec="edit grade5water.lua"
-- alias run="grade5water"



local main = thread.create(function()
    -- THE LOOP
    local fluid_name = "plasma.helium"
    local db_index = 1
    local damage = 0
    local fluid_index = 0
    helium_plasma_interface_db.set(db_index, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", fluid_name))
    helium_plasma_interface.setFluidInterfaceConfiguration(fluid_index, helium_plasma_interface_db.address, db_index)

    local coolant_name = "supercoolant"
    local db_index_coolant = 2
    coolant_interface_db.set(db_index_coolant, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", coolant_name))
    coolant_interface.setFluidInterfaceConfiguration(fluid_index, coolant_interface_db.address, db_index_coolant)

    local loop_started = false
    local prevValue = 0
    while true do
        print_d("Waiting for start")
        if prevValue < machineProxy.getWorkProgress() then
            regulate_system()
            local current_progress = machineProxy.getWorkProgress()
            print_d("Waiting for start again")
            while prevValue <= current_progress do
                prevValue = current_progress
                os.sleep(1)
                current_progress = machineProxy.getWorkProgress()
                os.sleep(1)
            end
            print_d("Progress prev is greater than current, must be starting")
            prevValue = machineProxy.getWorkProgress()
        end
        os.sleep(1)
    end
  end)

  



local cleanUp = thread.create(function()
    event.pull('interrupted')
    term.clear()
    print('Received Exit Command!')
    main.kill()
    keyhandler.kill()
    os.exit(0)
end)



thread.waitForAny({main, keyHandler, cleanUp})
os.exit(0)


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