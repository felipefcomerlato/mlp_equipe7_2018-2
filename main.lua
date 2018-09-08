local wallImage

function love.load()
  wallImage = love.graphics.newImage("images/wall.png")
end

function love.draw()
  love.graphics.draw(wallImage, 256, 256)
end
