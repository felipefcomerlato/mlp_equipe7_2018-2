local object = require("entitys/object")

local character = {}

function character.new(texture, position_x, position_y, inst_speed)
  local character = object.new(texture, position_x, position_y)
  local speed = inst_speed

  function character:setShot() end

  function character:getPosition()
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function character:getTexture()
    return self.texture
  end

  function character:getSpeed()
    return speed
  end

  function character:collisionTest(shooter)

    body = {
      left = self.position_x,
      right = self.position_x + self.texture:getWidth(),
      top = self.position_y,
      bottom = self.position_y + self.texture:getHeight()
    }

    shot = shooter:getShot()

    if shot then

      shot_coord = {
        x = shot:getPosition().x + shot:getTexture():getWidth() / 2,
        y = shot:getPosition().y + shot:getTexture():getHeight() / 2
      }
      if body.bottom >= shot_coord.y then
        if body.left <= shot_coord.x then
          if body.right >= shot_coord.x then
            if body.top <= shot_coord.y then
              shot:destroy(shooter)
              return 1
            end
          end
        end
      end

    end
  end

  return character
end

function character.getLimitScreen()
  return {
    top = object:getLimitScreen().top,
    bottom = object:getLimitScreen().bottom,
    left = object:getLimitScreen().left,
    right = object:getLimitScreen().right,
  }
end

return character
