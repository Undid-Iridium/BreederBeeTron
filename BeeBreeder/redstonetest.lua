
local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')

local system_state = current_component.proxy("7345483f-9fcc-460e-afce-938a6653d024", "redstone")

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



while NeedExitFlag ~= true do
    
    if(system_state.getInput(sides.down) > 0) then
       print("What was system state: ", system_state.getInput(sides.down))
    end
    
    os.sleep(5)
    -- computer.pullSignal(5)
end
