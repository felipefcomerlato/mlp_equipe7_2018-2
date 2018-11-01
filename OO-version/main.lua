local enemy = require("entitys/enemy")
local player = require("entitys/player")


function love.load()
  table_of_enemies = enemy.makeTable()
  player1 = player.new()
  direction = enemy.getDirectionMoveInit()
  directionMystery = enemy.getDirectionMoveInit()
end

function love.update(dt)
  moveEnemies()
  controlPlayer()
end

function love.draw()

  -- draw enemies
  for i=1,#table_of_enemies do
    if table_of_enemies[i] then
      love.graphics.draw(table_of_enemies[i].texture, table_of_enemies[i].position_x, table_of_enemies[i].position_y)
      if table_of_enemies[i]:collisionTest(player1, i) == 1 then
        table_of_enemies[i] = nil
        -- player1.shots[1] = nil
      end
    end
  end

  -- draw player
  love.graphics.draw(player1.texture, player1.position_x, player1.position_y)

  --draw player shot
  if #player1.shots > 0 then
    love.graphics.draw(player1.shots[1].texture, player1.shots[1].position_x, player1.shots[1].position_y)
  end

end


-- -------------------------------------

function controlPlayer()
  player1:move()
  player1:shot()
  if #player1.shots > 0 then -- se foi disparado um tiro
    player1.shots[1]:moveUp()
  end
end

function moveEnemies()
  if #table_of_enemies > 1 then
    direction = direction * setDirection()
    for i=2,#table_of_enemies do
      if table_of_enemies[i] then
        table_of_enemies[i]:move(direction)
      end
    end
  end
  if table_of_enemies[1] then
    directionMystery = directionMystery * setDirectionMystery()
    table_of_enemies[1]:move(directionMystery)
  end
end

function setDirectionMystery()
  if table_of_enemies[1] then
    local mystery = table_of_enemies[1]
    if mystery.position_x >= enemy.getLimitScreen().right*2 or mystery.position_x <= enemy.getLimitScreen().left - 600 then
      return -1 -- reverse values of shift
    else
      return 1
    end
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
  if first_enemy or last_enemy then
    if last_enemy.position_x >= enemy.getLimitScreen().right or first_enemy.position_x <= enemy.getLimitScreen().left then
      return -1
    else
      return 1
    end
  end
end
