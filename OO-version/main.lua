local enemie = require("entitys/enemie")


function love.load()
  table_of_enemies = enemie.makeTable()
end

function love.update(dt)
end

function love.draw()
  for i=1,#table_of_enemies do
      love.graphics.draw(table_of_enemies[i].texture, table_of_enemies[i].position_x, table_of_enemies[i].position_y)
  end
end
