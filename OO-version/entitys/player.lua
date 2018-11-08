local character = require("entitys/character")
local shot = require("entitys/shot")

local player = {}
local texture = "images/player.png"
local position_x = love.graphics.getWidth()/2
local position_y = love.graphics.getHeight() - 100
local speed = 5

function player.new()
  local player = character.new(texture, position_x, position_y, speed)
  player.lives = 3
  player.score = 0
  player.shots = {}
  player.speed_shot = 10

  function player.getLives(self)
    return self.lives
  end

  function player.getScore(self)
    return self.score
  end

  function player.getShot(self)
    if self.shots[1] then
      return self.shots[1]
    end
  end

  function player.getSpeed(self)
    return self.speed
  end

  function player.getSpeedShot(self)
    return self.speed_shot
  end

  function player.getTexture(self)
    return self.texture
  end

  function player.getPosition(self)
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function player.setScore(self)
    self.score = self.score + 50
  end

  function player.setLives(self)
    if self.lives > 0 then
      self.lives = self.lives - 1
      self.position_x = position_x
      self.position_y = position_y
    end
  end

  function player.move(self)
    if love.keyboard.isDown("right") then
      if self.position_x < character.getLimitScreen().right - self.texture:getWidth() then
        self.position_x = self.position_x + speed
      else
        self.position_x = character.getLimitScreen().right - self.texture:getWidth()
      end
    end
    if love.keyboard.isDown("left") then
      if self.position_x > character.getLimitScreen().left then
        self.position_x = self.position_x - speed
      else
        self.position_x = character.getLimitScreen().left
      end
    end
  end

  function player.shot(self)
    function love.keypressed(key)
      if key == "space" then
        if #self.shots < 1 then -- se não há outro tiro "em andamento" na tela
          table.insert(self.shots,shot.new(self, "player"))
        end
      end
    end
  end

  function player.collisionTest(self, char)

    if self.lives > 0 then

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

  return player
end

return player
