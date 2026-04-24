local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local thread = require('thread')
local event = require('event')
local term = require('term')

local system_state = current_component.proxy("ea93b763-46c7-49df-a2e7-9059bf2e01cd", "redstone")
local liquid_transposer = current_component.proxy("be563785-1819-4dfd-bfc5-0365abbb43f4", "transposer")
local interface_db = current_component.proxy("fb98c6be-291f-41f7-8c23-15a4f26e1c7c", "database")
local interface = current_component.proxy("51eeade4-c328-471d-a8ce-d4f5496f6848", "me_interface")

local coolant = "supercoolant"
local helium = "helium"
local neon = "neon"
local krypton = "krypton"
local xenon = "xenon"
local neutronium = "molten.neutronium"
local superconductor = "molten.longasssuperconductornameforuhvwire"

-- alias clean="rm -f grade7water.lua"
-- alias ec="edit grade7water.lua"
-- alias run="grade7water"

local function print_d(msg)
    print(os.date() .. " : " .. msg)
end
  

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

local function set_liquid(incoming_liquid_name)
    local db_index = 1
    local damage = 0
    local fluid_index = 0
    interface_db.set(db_index, "ae2fc:fluid_drop", damage , string.format("{ Fluid: %s }", incoming_liquid_name))
    interface.setFluidInterfaceConfiguration(fluid_index, interface_db.address, db_index)
end



local function process_liquid(incoming_liquid_name, amount)
    set_liquid(incoming_liquid_name)
    print_d("Transferring liquid " .. incoming_liquid_name .. " for " .. amount)
    local ok, success, res = pcall(liquid_transposer.transferFluid, sides.east, sides.down, amount, 0)
    if not ok then
        print("Lua error:", success)  -- this is the crash message
    else
        if success then
            print("Transferred:", res)
        else
            print("Failed:", res)
        end
    end
end
  

-- ====================== MAIN =======================

local main = thread.create(function()
    -- THE LOOP
    while true do

        local _, _, side, oldValue, new_value = event.pull("redstone_changed")
        if new_value == 0 then
            print("It wanted coolant")
            -- Super coolant 10000L
            process_liquid(coolant, 10000)
        else
            print_d(" : Signal received on side: " .. side)
            print_d(" : Signal received on side: " .. new_value)
            local temp_val = tonumber(new_value)
            print_d(" : Signal received on side temp: " .. temp_val)
            if temp_val & (1 << 3) ~= 0 then -- bit 4 ( :( 4-1 )) - if 0, skip
                print_d("Skipping due to the bit being set for 8+")
                goto continue
            end

            if temp_val & (1 << 0) ~= 0 then
                -- Take 2 bits for value
                local low_bit = temp_val & (1 << 1)
                local high_bit =  temp_val & (1 << 2)
                print("Low bit: " .. low_bit .. " and high bit: " .. high_bit)
                local total = 0
                total = total | (low_bit << 0)
                total = total | (high_bit << 1)

                -- Result will be 00 01 10 11 (there are 0's before the 2 but ignore)
                print_d("It was looking for liquid; therefore, current total equals: " .. total)
                if(total == 0) then
                    process_liquid(helium, 10000)
                    -- Helium 10000L
                    -- lens_transposer.transferFluid
                elseif total == 1 then
                    process_liquid(neon, 7500)
                    -- Neon 7500L
                elseif total == 2 then
                    process_liquid(krypton, 5000)
                    -- Krypton 5000L
                elseif total == 3 then
                    process_liquid(xenon, 2500)
                    -- Xenon 2500L
                end                
                
            end
            if temp_val & (1 << 2) ~= 0 then
                -- Neutronium 4608L
                print_d("It wanted neutronium")
                process_liquid(neutronium, 4608)
            end
            if temp_val & (1 << 1) ~= 0 then
                print_d("It wanted a superconductor")
                process_liquid(superconductor, 1440)
                --  1440 L of any Molten Superconductor Base of at least UV tier
            end
        end
        ::continue::
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