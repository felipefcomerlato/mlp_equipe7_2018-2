local character = require("entitys/character")

local shot = {}
local texture = "images/shot.png"
local speed = 5

function shot.new(shooter)
  local shot = character.new(texture, shooter.position_x, shooter.position_y, speed)

  function shot.move(self)
    self.position_y = self.position_y - speed
  end

  return shot
end

return shot
