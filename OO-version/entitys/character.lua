local object = require("entitys/object")

local character = {}
local move_limit_right = 600
local move_limit_left = 0

function character.new(texture, position_x, position_y, speed)
  local character = object.new(texture, position_x, position_y)

  character.speed = speed

  return character
end


return character
