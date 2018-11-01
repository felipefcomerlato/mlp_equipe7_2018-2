local character = require("entitys/character")
local shot = require("entitys/shot")

local player = {}
local texture = "images/baseshipb.png"
local position_x = love.graphics.getWidth()/2
local position_y = love.graphics.getHeight() - 50
local speed = 10
local move_limit_right = 600
local move_limit_left = 0

function player.new()
  local player = character.new(texture, position_x, position_y, 20)
  player.lifes = 3
  player.score = 0

  function player.move(self)
    if love.keyboard.isDown("right") then
      if self.position_x < move_limit_right then
        self.position_x = self.position_x + speed
      else
        self.position_x = move_limit_right
      end
    end
    if love.keyboard.isDown("left") then
      if self.position_x > move_limit_left then
        self.position_x = self.position_x - speed
      else
        self.position_x = move_limit_left
      end
    end
  end

  function player.shot(self)

    function love.keypressed(key)
      if key == "space" then
        print("TIRO")
      end
    end

  end

  return player
end

return player
