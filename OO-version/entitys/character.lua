local object = require("entitys/object")

local character = {}

local limit_screen_right = love.graphics.getWidth()
local limit_screen_left = 0
local limit_screen_top = 0
local limit_screen_bottom = love.graphics.getHeight()

function character.new(texture, position_x, position_y, speed)
  local character = object.new(texture, position_x, position_y)

  character.speed = speed

  return character
end

function character.getLimitScreen()
  return {
    top = limit_screen_top,
    bottom = limit_screen_bottom,
    left = limit_screen_left,
    right = limit_screen_right
  }
end

return character
