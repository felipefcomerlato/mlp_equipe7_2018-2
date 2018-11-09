local object = {}

local limit_screen_right = love.graphics.getWidth()
local limit_screen_left = 0
local limit_screen_top = 0
local limit_screen_bottom = love.graphics.getHeight() - 60

function object.new(texture, position_x, position_y)
  return {
    texture = love.graphics.newImage(texture),
    position_x = position_x,
    position_y = position_y
  }
end

function object.getLimitScreen()
  return {
    top = limit_screen_top,
    bottom = limit_screen_bottom,
    left = limit_screen_left,
    right = limit_screen_right
  }
end

return object
