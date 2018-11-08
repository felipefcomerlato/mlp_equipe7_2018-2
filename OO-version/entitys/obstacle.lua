local object = require("entitys/object")

local obstacle = {}
local texture = "images/obstacle1.png" -- initial texture

function obstacle.new(position_x, position_y)
  local obstacle = object.new(texture, position_x, position_y)
  obstacle.state = 1

  function obstacle.getState(self)
    return self.state
  end

  function obstacle.getTexture(self)
    return self.texture
  end

  function obstacle.getPosition(self)
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function obstacle.setState(self)
    if self.state < 4 then
      self.state = self.state + 1
      self.texture = love.graphics.newImage(self:generateTexture())
    else
      self:destroy()
    end
  end

  function obstacle.collisionTest(self, char)

    if self.state > 0 then

      body = {
        left = self.position_x,
        right = self.position_x + self.texture:getWidth(),
        top = self.position_y,
        bottom = self.position_y + self.texture:getHeight()
      }

      if char.shots[1] then
        shot_char = char.shots[1]
      end

      shot_c = {
        x = shot_char.position_x + shot_char.texture:getWidth() / 2,
        y = shot_char.position_y + shot_char.texture:getHeight() / 2
      }

      if body.bottom >= shot_c.y then
        if body.left <= shot_c.x then
          if body.right >= shot_c.x then
            if body.top <= shot_c.y then
              shot_char:destroy(char)
              return 1
            end
          end
        end
      end
    end
  end

  function obstacle.destroy(self)
    self.state = 0
  end

  function obstacle.generateTexture(self)
    if self.state == 2 then
      return "images/obstacle2.png"
    elseif self.state == 3 then
      return "images/obstacle3.png"
    elseif self.state == 4 then
      return "images/obstacle4.png"
    end
  end

  return obstacle
end

function obstacle.makeObstacles()
  obstacles = {}
  for i=0, 3 do
    table.insert(obstacles,obstacle.new(70 + i*140,400))
  end
  return obstacles
end

return obstacle
