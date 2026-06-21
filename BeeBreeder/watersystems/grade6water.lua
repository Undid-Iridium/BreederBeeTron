local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')
local thread = require('thread')
local event = require('event')
local term = require('term')

local system_state = current_component.proxy("ea93b763-46c7-49df-a2e7-9059bf2e01cd", "redstone")
local lens_transposer = current_component.proxy("fad882d8-de64-4c1d-820d-74229938e008", "transposer")
local machineProxy = current_component.proxy("e65e49c7-258c-4d02-a140-4a2c1c632a58", "gt_machine")

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
  

local function pull_lens(prev)
    print_d(" : pulling out " .. prev)
    lens_transposer.transferItem(sides.bottom, sides.top, 1, 1, prev)
end

local function put_lens(current_pos)
    print_d(" : putting in " .. current_pos)
    lens_transposer.transferItem(sides.top, sides.bottom, 1, current_pos, 1)
end

-- ====================== MAIN =======================

local main = thread.create(function()
    -- THE LOOP
    local loop_started = false
    local prevValue = 0
    
    while true do

        print_d("Waiting for start")
        if prevValue ~= machineProxy.getWorkProgress() then
            -- Stupid ass minecraft uses 1 as first slot instead of 0 cringe
            local currentPosToUse = 1
            put_lens(currentPosToUse)
            currentPosToUse = currentPosToUse + 1
            -- lens_transposer.transferItem(sides.top, sides.bottom, 1, 1, 1)
            while currentPosToUse <= 9 do
                print_d("Waiting for redstone")
                local _, _, side, oldValue, newValue = event.pull("redstone_changed")
                if newValue > 0 then
                    print_d(" : Signal received on side: " .. side)
                    local status, err = pcall(pull_lens, currentPosToUse-1)
                    put_lens(currentPosToUse)
                    currentPosToUse = currentPosToUse + 1
                end
            end
            prevValue = machineProxy.getWorkProgress()
            local currentValue = machineProxy.getWorkProgress()+1
            while prevValue <= currentValue do
                prevValue = machineProxy.getWorkProgress()
                os.sleep(1)
                currentValue = machineProxy.getWorkProgress()
            end
            local status, err = pcall(pull_lens, currentPosToUse-1)

        end
        os.sleep(1)
        prevValue = machineProxy.getWorkMaxProgress()

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