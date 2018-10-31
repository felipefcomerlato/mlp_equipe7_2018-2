local character = require("entitys/character")

local player = {}
local texture = "images/baseshipb.png"
local position_x = love.graphics.getWidth()/2
local position_y = love.graphics.getHeight() - 50

function player.new()
  local player = character.new(texture, position_x, position_y, 20)
  return player
end

return player
