local character = require("entitys/character")

local shot = {}
local texture = "images/shot.png"
local speed = 5

function shot.new(shooter)
  local shot = character.new(texture, shooter.position_x, shooter.position_y, speed)

  function shot.moveUp(self)
    self:screenCollisionTest()
    self.position_y = self.position_y - speed
  end

  function shot.moveDown(self)
    self.screenCollisionTest()
    self.position_y = self.position_y + speed
  end

  function shot.screenCollisionTest(self)
    if self.position_y <= character.getLimitScreen().top or self.position_y >= character.getLimitScreen().bottom then
      self:destroy(shooter)
    end
  end

  function shot.destroy(self, shooter)
    shooter.shots[1] = nil
  end

  return shot
end

return shot
