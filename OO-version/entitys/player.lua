local character = require("entitys/character")
local shot = require("entitys/shot")

local player = {}
local texture = "images/baseshipb.png"
local position_x = love.graphics.getWidth()/2
local position_y = love.graphics.getHeight() - 50
local speed = 5

function player.new()
  local player = character.new(texture, position_x, position_y, 20)
  player.lifes = 3
  player.score = 0
  player.shots = {}

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
    if love.keyboard.isDown("up") then
      if self.position_y > character.getLimitScreen().top then
        self.position_y = self.position_y - speed
      else
        self.position_y = character.getLimitScreen().top
      end
    end
    if love.keyboard.isDown("down") then
      if self.position_y < character.getLimitScreen().bottom then
        self.position_y = self.position_y + speed
      else
        self.position_y = character.getLimitScreen().bottom
      end
    end
  end

  function player.shot(self)
    function love.keypressed(key)
      if key == "space" then
        if #self.shots < 1 then -- se não há outro tiro "em andamento" na tela
          table.insert(self.shots,shot.new(self))
        end
      end
    end
  end

  return player
end

return player
