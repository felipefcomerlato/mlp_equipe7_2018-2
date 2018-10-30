local character = require("entitys/character")

local enemie = {}

function enemie.novo(texture, position_x, position_y)
  local enemie = character.novo(texture, position_x, position_y)
  return enemie
end

return enemie
