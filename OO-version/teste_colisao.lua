local enemy = require("entitys/enemy")
local player = require("entitys/player")


function love.load()
  enemies = {}
  for i = 1, 6 do
    for j = 1, 14 do
      table.insert(enemies, enemy.new("images/saucer1b.png",i*50,j*50,0))
    end
  end
  player1 = player.new()

end

function love.update(dt)
  player1:move()
  body = {
    left = enemy1.position_x,
    right = enemy1.position_x + enemy1.texture:getWidth(),
    top = enemy1.position_y,
    bottom = enemy1.position_y + enemy1.texture:getHeight()
  }

    shot_c = {
      x = player1.position_x + player1.texture:getWidth() / 2,
      y = player1.position_y + player1.texture:getHeight() / 2
    }
end

function love.draw()
  love.graphics.draw(enemy1.texture,enemy1.position_x,enemy1.position_y)
  love.graphics.draw(player1.texture,player1.position_x,player1.position_y)
  love.graphics.print("x: " .. shot_c.x, 150, 150)
  love.graphics.print("y: " .. shot_c.y, 150, 170)

  if body.bottom >= shot_c.y then
    if body.left <= shot_c.x then
      if body.right >= shot_c.x then
        if body.top <= shot_c.y then
          love.graphics.print("COLISÃO",250,250)
        end
      end
    end
  end

  love.graphics.print("X: " .. enemy1.position_x, 400, 300)
  love.graphics.print("Y: " .. enemy1.position_y, 400, 320)
  love.graphics.print("Width: " .. enemy1.texture:getWidth(), 400, 340)
  love.graphics.print("Height: " .. enemy1.texture:getHeight(), 400, 360)
end
