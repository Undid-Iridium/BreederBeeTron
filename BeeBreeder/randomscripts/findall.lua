local current_component = require('component')
local me = current_component.me_interface
for k, v in pairs(me) do
  print(k, type(v))
end

