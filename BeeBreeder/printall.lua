
local component = require("component")

for address, ctype in component.list() do
    print(address, ctype)
end
