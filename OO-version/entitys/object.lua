local object = {}

function object.new(texture, position_x, position_y)
  return {
    texture = love.graphics.newImage(texture),
    position_x = position_x,
    position_y = position_y
  }
end

return object
