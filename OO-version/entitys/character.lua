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
