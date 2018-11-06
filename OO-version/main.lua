local enemy = require("entitys/enemy")
local player = require("entitys/player")


function love.load()
  enemies = enemy.makeEnemies()
  player1 = player.new()
  direction = enemy.getDirectionMoveInit()
  directionMystery = enemy.getDirectionMoveInit()
end

x=0
function love.update(dt)
  x = x + dt
  moveEnemies()
  -- print(x)
  makeEnemiesShots()
  controlPlayer()
end

function love.draw()

  -- draw enemies
  for i=1,#enemies do
    if enemies[i].texture and enemies[i].position_x and enemies[i].position_y then
      love.graphics.draw(enemies[i].texture, enemies[i].position_x, enemies[i].position_y)
      if player1.shots[1] then
        if enemies[i]:collisionTest(player1) == 1 then
          enemy.destroy(enemies[i])
        end
      end
      if enemies[i].shots[1] then
        love.graphics.draw(enemies[i].shots[1].texture, enemies[i].shots[1].position_x,enemies[i].shots[1].position_y)
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

function makeEnemiesShots()
  for i=2,#enemies do
    if enemies[i].position_x then
      if #enemies[i].shots < 1 then
        enemies[i]:shot(enemies)
      end
    end
    -- if #enemies[i].shots > 0 then
    --   enemies[i].shots[1]:moveDown()
    -- end
  end
  for i=2,#enemies do
    if enemies[i].position_x then
      if enemies[i].shots[1] then
        enemies[i].shots[1]:moveDown()
      end
    end
  end
end

function moveEnemies()
  -- move all enemies
  if #enemies > 1 then
    direction = direction * setDirection()
    for i=2,#enemies do
      if enemies[i] then
        enemies[i]:move(direction)
      end
    end
  end
  -- move mystery enemy
  if enemies[1].position_x then
    directionMystery = directionMystery * reviewDirectionMystery()
    enemies[1]:move(directionMystery)
  end
end

function setDirection()
  last_enemy = getFirstOrLastEnemy().last
  first_enemy = getFirstOrLastEnemy().first
  if first_enemy and last_enemy then
    if last_enemy.position_x >= enemy.getLimitScreen().right - last_enemy.texture:getWidth() or first_enemy.position_x <= enemy.getLimitScreen().left then
      return -1
    else
      return 1
    end
  else
    return 0
  end
end

function reviewDirectionMystery()
  if enemies[1] then
    local mystery = enemies[1]
    if mystery.position_x >= enemy.getLimitScreen().right*2 or mystery.position_x <= enemy.getLimitScreen().left - 600 then
      return -1 -- reverse values of shift
    else
      return 1
    end
  end
end

function getFirstOrLastEnemy()
  local enemies_ordered = {}
  for i = 2, #enemies do
    if enemies[i].position_x then
      table.insert(enemies_ordered,enemies[i])
    end
  end

  function sortByPos(a,b)
    return a.position_x > b.position_x
  end

  table.sort(enemies_ordered,sortByPos)

  if enemies_ordered[1] and enemies_ordered[#enemies_ordered] then
    return {
      last = enemies_ordered[1],
      first = enemies_ordered[#enemies_ordered]
    }
  else
    return {
      last = nil,
      first = nil
    }
  end
end
