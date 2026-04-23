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

        local _, _, side, oldValue, newValue = event.pull("redstone_changed")
        if newValue > 0 then
            
            print_d(" : Signal received on side: " .. side)
            print_d(" : Signal received on side: " .. newValue)
            local temp_val = tonumber(newValue)
            print_d(" : Signal received on side temp: " .. temp_val)
            print_d(" : Signal received on side: " .. temp_val & 1)
            print_d(" : Signal received on side: " .. temp_val & 2)
            print_d(" : Signal received on side: " .. temp_val & 3)
            print_d(" : Signal received on side: " .. temp_val & 4)
        end
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