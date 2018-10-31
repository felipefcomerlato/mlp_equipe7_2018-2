require("love.graphics")

local character = {}

function character.novo(texture, position_x, position_y)
  print("Um novo PERSONAGEM foi criado")
  return {
    texture = love.graphics.newImage(texture),
    position_x = position_x,
    position_y = position_y
  }
end

return character
