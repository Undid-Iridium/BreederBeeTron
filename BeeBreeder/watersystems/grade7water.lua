local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local thread = require('thread')
local event = require('event')
local term = require('term')

local system_state = current_component.proxy("ea93b763-46c7-49df-a2e7-9059bf2e01cd", "redstone")
local lens_transposer = current_component.proxy("fad882d8-de64-4c1d-820d-74229938e008", "transposer")


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


-- ====================== MAIN =======================

local main = thread.create(function()
    -- THE LOOP
    local loop_started = false
    while true do

        -- Stupid ass minecraft uses 1 as first slot instead of 0 cringe
        local lens_to_use = 2
        local prev = lens_to_use-1

        local _, _, side, oldValue, new_value = event.pull("redstone_changed")
        if new_value == 0 then
            -- Super coolant 10000L
        else
            print_d(" : Signal received on side: " .. side)
            print_d(" : Signal received on side: " .. new_value)
            local temp_val = tonumber(new_value)
            print_d(" : Signal received on side temp: " .. temp_val)
            local bruh = temp_val & (1 << 0)
            print("hmm")
            print_d(" : Signal received on side: " .. bruh)
            print_d(" : Signal received on side: " .. (temp_val & 1))
            print_d(" : Signal received on side: " .. (temp_val & 2))
            print_d(" : Signal received on side: " .. (temp_val & 4))
            print_d(" : Signal received on side: " .. (temp_val & 3))

            if temp_val & (1 << 3) ~= 0 then -- bit 4 ( :( 4-1 ))
                goto continue
            elseif temp_val & (1 << 0) ~= 0 then
                -- Take 2 bits for value
                local low_bit = temp_val & (1 << 1)
                local high_bit =  temp_val & (1 << 2)
                local total = 0
                total = total | (low_bit << 0)
                total = total | (high_bit << 1)

                -- Result will be 00 01 10 11 (there are 0's before the 2 but ignore)

                if(total == 0) then
                    -- Helium 10000L
                elseif total == 1 then
                    -- Neon 7500L
                elseif total == 2 then
                    -- Krypton 5000L
                elseif total == 3 then
                    -- Xenon 2500L
                end                
                
            elseif temp_val & (1 << 2) ~= 0 then
                -- Neutronium 4608L
            elseif temp_val & (1 << 1) ~= 0 then
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