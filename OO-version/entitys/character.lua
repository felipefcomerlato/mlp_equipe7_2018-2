local object = require("entitys/object")

local character = {}

function character.new(texture, position_x, position_y, speed)
  local character = object.new(texture, position_x, position_y)
  character.speed = speed

  function character.setShot() end

  function character.getPosition(self)
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function character.getTexture(self)
    return self.texture
  end

  function character.getSpeed(self)
    return self.speed
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
