require("love.graphics")

local player = {}

function player.novo(nome, position_x, position_y)
  return {
    texture = "baseshipb.png",
    position_x = position_x,
    position_y = position_y
  }
end

return player
