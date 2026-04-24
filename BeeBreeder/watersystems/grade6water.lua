local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local thread = require('thread')
local event = require('event')
local term = require('term')

local system_state = current_component.proxy("ea93b763-46c7-49df-a2e7-9059bf2e01cd", "redstone")
local lens_transposer = current_component.proxy("fad882d8-de64-4c1d-820d-74229938e008", "transposer")


-- alias clean="rm -f grade6water.lua"
-- alias ec="edit grade6water.lua"
-- alias run="grade6water"


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
  

local function swap_lens(prev)
    print_d(" : pulling out " .. prev)
    lens_transposer.transferItem(sides.bottom, sides.top, 1, 1, prev)
end

-- ====================== MAIN =======================

local main = thread.create(function()
    -- THE LOOP
    local loop_started = false
    while true do

        -- Stupid ass minecraft uses 1 as first slot instead of 0 cringe
        local lens_to_use = 2
        local prev = lens_to_use-1

        -- os.sleep(5)
        local status, err = pcall(swap_lens, 9)
        lens_transposer.transferItem(sides.top, sides.bottom, 1, 1, 1)

        -- lens_transposer.transferItem(sides.top, sides.bottom, 1, 1, 1)
        while lens_to_use <= 10 do
            print_d("Waiting for redstone")
            local _, _, side, oldValue, newValue = event.pull("redstone_changed")
            if newValue > 0 then
                print_d(" : Signal received on side: " .. side)
                local status, err = pcall(swap_lens, prev)
                lens_transposer.transferItem(sides.top, sides.bottom, 1, lens_to_use, 1)
                prev = lens_to_use
                lens_to_use = lens_to_use + 1
            end
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