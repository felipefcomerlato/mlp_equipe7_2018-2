local character = require("entitys/enemie")


function love.load()
  enemie1 = enemie.novo("images/mysteryb.png",100,100)
  enemie2 = enemie.novo("images/saucer3b.png",300,300)
end

function love.update(dt)
end

function love.draw()
  love.graphics.draw(enemie1.texture, enemie1.position_x, enemie1.position_y)
  love.graphics.draw(enemie2.texture, enemie2.position_x, enemie2.position_y)
end
