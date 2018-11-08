local character = require("entitys/character")

local shot = {}
local texture_player = "images/shot_player.png"
local texture_enemy = "images/shot_enemy.png"
-- local texture = "images/shot_enemy.png"
-- local speed = 15

function shot.new(shooter, type)

  if type == "player" then
    texture = texture_player
  else
    texture = texture_enemy
  end

  local shot = character.new(texture, shooter:getPosition().x
                                      + shooter:getTexture():getWidth()/2,
                                      shooter:getPosition().y,
                                      shooter:getSpeedShot())

  function shot.moveUp(self)
    self:screenCollisionTest()
    self.position_y = self.position_y - shooter:getSpeedShot()
  end

  function shot.moveDown(self)
    self:screenCollisionTest()
    self.position_y = self.position_y + shooter:getSpeedShot()
  end

  function shot.screenCollisionTest(self)
    if self.position_y then
      if self.position_y <= character.getLimitScreen().top
        or self.position_y >= character.getLimitScreen().bottom
                                      - self.texture:getHeight() then
        self:destroy(shooter)
      end
    end
  end

  function shot.destroy(self, shooter)
    shooter.shots[1] = nil
  end

  return shot
end

return shot
