local enemieImage
local num
local x = 0
local y = 0
local xPlayer = 320
local yPlayer = 608

enemies = {{0,1,1,0,1}, {0,1,1,1,1},{1,1,1,1,1}}

function love.load()
  enemieImage = love.graphics.newImage("images/mysteryb.png")
  playerImage = love.graphics.newImage("images/baseshipb.png")
  love.graphics.setBackgroundColor(0,255,255)
end


function love.draw()
  draw_enemies(#enemies)
  love.graphics.draw(playerImage, xPlayer, yPlayer)
end


function love.update(dt)
  y = y + 5*dt
  if love.keyboard.isDown("right") then   -- reduce the value
    xPlayer = xPlayer + 10
  end
   if love.keyboard.isDown("left") then   -- increase the value
    xPlayer = xPlayer - 10
  end
end


function draw_enemies(rows)
  if rows > 0 then
    desenha_col(rows, #enemies[rows])
    draw_enemies(rows-1)
  end
end

function desenha_col(row, enemies_on_the_row)
  if enemies_on_the_row > 0 then
    if enemies[row][enemies_on_the_row] == 1 then
      love.graphics.draw(enemieImage, enemies_on_the_row*60, row*20 + y)
    end
    desenha_col(row, enemies_on_the_row-1)
  end
end
