local current_component = require('component')
local transposer = current_component.proxy("address", "transposer")
local bee_api = current_component.proxy("address", "beekeeper")
local config = require("config")
local filesystem = require("filesystem")
local event = require("event")

print(transposer.getAll())





