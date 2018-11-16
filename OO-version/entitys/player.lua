local character = require("entitys/character")
local shot = require("entitys/shot")

local player = {}
local texture = "images/player.png"
local position_x = love.graphics.getWidth()/2
local position_y = love.graphics.getHeight() - 100
local speed = 5

function player.new()
  local player = character.new(texture, position_x, position_y, speed)
  local lives = 3
  local score = 0
  local shots = {}
  local speed_shot = 10

  function player:dShot()
    if #shots > 0 then
      shots[1] = nil
    end
  end

  function player:getLives()
    return lives
  end

  function player:getScore()
    return score
  end

  function player:getShot()
    if shots[1] then
      return shots[1]
    end
  end

  function player:getSpeedShot()
    return speed_shot
  end

  function player:setScore(time)
    score = score + math.floor((1/time) * 5000)
  end

  function player:setLives()
    if lives > 0 then
      lives = lives - 1
      self.position_x = position_x
      self.position_y = position_y
    end
  end

  function player:move()
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

  function player:keyboard(game)
    function love.keypressed(key)
      if key == "space" then
        if #shots < 1 then -- se não há outro tiro "em andamento" na tela
          table.insert(shots,shot.new(self, "player"))
        end
      end
      if game == "menuscreen" or game == "gameover" or game == "playerwin" then
        if key == "return" then
          love.load("play")
        end
      end
    end
  end

  return player
end

return player
