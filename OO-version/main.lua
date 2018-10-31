local enemy = require("entitys/enemy")
local player = require("entitys/player")


function love.load()
  table_of_enemies = enemy.makeTable()
  player1 = player.new()
  limit_right = enemy.getMoveLimit().right
  limit_left = enemy.getMoveLimit().left
  direction = enemy.getDirectionMoveInit()
  directionMystery = enemy.getDirectionMoveInit()
end

function love.update(dt)
  moveEnemies()
end

function love.draw()
  for i=1,#table_of_enemies do
      love.graphics.draw(table_of_enemies[i].texture, table_of_enemies[i].position_x, table_of_enemies[i].position_y)
  end
  love.graphics.draw(player1.texture, player1.position_x, player1.position_y)
end



-- -------------------------------------

function moveEnemies()
  direction = direction * setDirection()
  for i=2,#table_of_enemies do
    table_of_enemies[i]:move(direction)
  end
  directionMystery = directionMystery * setDirectionMystery()
  table_of_enemies[1]:move(directionMystery)
end

function setDirectionMystery()
  local mystery = table_of_enemies[1]
  if mystery.position_x >= enemy.getMoveLimit().right*2 or mystery.position_x <= enemy.getMoveLimit().left - 600 then
    return -1
  else
    return 1
  end
end

function getFirstOrLastEnemy()
  local enemies_ordered = {}
  for i = 2, #table_of_enemies do
    table.insert(enemies_ordered,table_of_enemies[i])
  end

  function sortByPos(a,b)
    return a.position_x > b.position_x
  end

  table.sort(enemies_ordered,sortByPos)

  return {
    last = enemies_ordered[1],
    first = enemies_ordered[#enemies_ordered]
  }
end

function setDirection()
  last_enemy = getFirstOrLastEnemy().last
  first_enemy = getFirstOrLastEnemy().first
  if last_enemy.position_x >= enemy.getMoveLimit().right or first_enemy.position_x <= enemy.getMoveLimit().left then
    return -1
  else
    return 1
  end
end
