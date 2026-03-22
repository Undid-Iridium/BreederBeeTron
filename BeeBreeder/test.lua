

local current_component = require('component')
local event = require("event")
local sides = require('sides')
local computer = require('computer')

-- local quantum_anomaly_transposer = current_component.proxy("589ff1f6-e41c-4785-be9d-fcf00cfc97ee", "transposer")
-- local temp = current_component.proxy("6117fa01-b4ba-4e77-9638-9ec2d2f5ae6e", "adapter")

local temp_interface = current_component.proxy("f9f5683a-4731-4323-ad74-980e327b9782", "me_interface")

local temp_db = current_component.proxy("077c0408-8271-46b4-afa7-fdd0af436b79", "database")



local function generate_quantum_anomaly()
    local db_index = 9
    temp_db.set(db_index, "gregtech:gt.comb", 49)
    temp_interface.setInterfaceConfiguration(1, temp_db.address, db_index)
end

generate_quantum_anomaly()