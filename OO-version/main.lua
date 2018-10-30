local character = require("entitys/character")


function love.load()
  personagem1 = character.novo("images/mysteryb.png",100,100)
  personagem2 = character.novo("images/saucer3b.png",300,300)
end

function love.update(dt)
end

function love.draw()
  love.graphics.draw(personagem1.texture, personagem1.position_x, personagem1.position_y)
  love.graphics.draw(personagem2.texture, personagem2.position_x, personagem2.position_y)
end
