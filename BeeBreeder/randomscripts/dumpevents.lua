local event = require("event")

while true do
  local data = {event.pull()}
  
  for i, v in ipairs(data) do
    print(i, v, type(v))
  end
  
  print("----")
end