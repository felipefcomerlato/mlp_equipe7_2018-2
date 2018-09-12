local enemieImage
local num
local x = 0
local y = 0
local xPlayer = 320
local yPlayer = 608

inimigos = {0,1,1,0,1}
print (inimigos)

function love.load()
  enemieImage = love.graphics.newImage("images/mysteryb.png")
  playerImage = love.graphics.newImage("images/baseshipb.png")
  love.graphics.setBackgroundColor(0,255,255)
end


function love.draw()
  desenha(#inimigos)
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


function desenha(num_vezes)
  if num_vezes > 0 then
    if inimigos[num_vezes] == 1 then
      love.graphics.draw(enemieImage, num_vezes*40, y)
    end
    desenha(num_vezes-1)
  end
end