local enemieImage
local num
local x = 0
local y = 0
local xPlayer = 320
local yPlayer = 608

function love.load()
  enemieImage = love.graphics.newImage("images/mysteryb.png")
  playerImage = love.graphics.newImage("images/baseshipb.png")
  love.graphics.setBackgroundColor(0,255,255)
end

function love.draw()
  for i=0,14,1 do
    for j=0,10,1 do
      love.graphics.draw(enemieImage, i*40, y)
    end
  end
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
