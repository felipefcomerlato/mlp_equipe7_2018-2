local object = require("entitys/object")

local shot = {}
local texture_player = "images/shot_player.png"
local texture_enemy = "images/shot_enemy.png"


function shot.new(shooter, type)

  if type == "player" then
    texture = texture_player
  else
    texture = texture_enemy
  end

  local shot = object.new(texture, shooter:getPosition().x
                                      + shooter:getTexture():getWidth()/2,
                                      shooter:getPosition().y,
                                      shooter:getSpeedShot())
  local state = 1

  function shot:getState()
    return state
  end

  function shot:getPosition()
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function shot:getTexture()
    return self.texture
  end

  function shot:moveUp()
    self:screenCollisionTest()
    self.position_y = self.position_y - shooter:getSpeedShot()
  end

  function shot:moveDown()
    self:screenCollisionTest()
    self.position_y = self.position_y + shooter:getSpeedShot()
  end

  function shot:screenCollisionTest()
    if self.position_y then
      if self.position_y <= object.getLimitScreen().top
        or self.position_y >= object.getLimitScreen().bottom
                                      - self.texture:getHeight() then
        self:destroy(shooter)
      end
    end
  end

  function shot:destroy(shooter)
    shooter:dShot()
  end

  return shot
end

return shot
