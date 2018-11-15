local enemy = require("entitys/enemy")
local player = require("entitys/player")
local obstacle = require("entitys/obstacle")

local game = "menuscreen" -- The game begin in menu screen
local screenCenter = love.graphics.getWidth() / 2

function love.load(menuKey)
  player1 = player.new()

  if menuKey == "play" then
    game = menuKey
  end

  math.randomseed(os.time())
  time = 0 -- Time init: the time is used for score calculus

  enemies = enemy.makeEnemies()
  obstacles = obstacle.makeObstacles()

  direction = enemy.getDirectionMoveInit()
  directionMystery = enemy.getDirectionMoveInit()

  background = love.graphics.newImage("images/background.png")
  hr = love.graphics.newImage("images/border_bottom.png")
end

function love.update(dt)
  incTime(dt)
  winTest()
  moveEnemies()
  makeEnemiesShots()
  controlPlayer()
  deleteEnemies()
end

function love.draw()
  love.graphics.draw(background,0,0)

  if game == "menuscreen" then
    printMenuScreen()
  elseif game == "gameover" then
    printGameOverScreen()
  elseif game == "playerwin" then
    printPlayerWin()
  else
    drawObstacles()
    drawEnemies()
    drawPlayer()
    drawPanel()
  end

end

function winTest()
  if not enemies then
    game = "playerwin"
  end
end

function deleteEnemies()
  -- Delete dead enemies
  for i=#enemies, 2, -1 do
    if enemies[i]:getState() == 0 then
      table.remove(enemies, i)
    end
  end
end

function incTime(dt)
  -- Game time is not shown anywhere.
  -- It is used only for score calculus.
  time = time + dt
end

function printMenuScreen()
  love.graphics.printf("SPACE INVADERS", 0, 200, screenCenter, "center", 0, 2, 2)
  love.graphics.printf("2018-2 ", 0, 250, screenCenter, "center", 0, 2, 2)
  love.graphics.printf("PRESS ENTER TO START", 0, 450, screenCenter, "center", 0, 2, 2)
end

function printGameOverScreen()
  enemywin = love.graphics.newImage("images/enemy-win.png")
  love.graphics.draw(enemywin, screenCenter - enemywin:getWidth() / 2, 180)
  love.graphics.printf("GAMEOVER", 0, 400, screenCenter, "center", 0, 2, 2)
  love.graphics.printf("YOUR SCORE: " .. player1:getScore(), 0, 440, screenCenter, "center", 0, 2, 2)
  love.graphics.printf("PRESS ENTER TO RESTART", 0, 550, screenCenter, "center", 0, 2, 2)
end

function printPlayerWin()
  player_win_big = love.graphics.newImage("images/player.png")
  love.graphics.draw(player_win_big, screenCenter - enemywin:getWidth() / 2, 180)
  love.graphics.printf("YOU WIN", 0, 400, screenCenter, "center", 0, 2, 2)
  love.graphics.printf("YOUR SCORE: " .. player1:getScore(), 0, 440, screenCenter, "center", 0, 2, 2)
  love.graphics.printf("PRESS ENTER TO RESTART", 0, 550, screenCenter, "center", 0, 2, 2)
end

function drawObstacles()
  for i=1, #obstacles do
    if obstacles[i] then
      if obstacles[i]:getState() > 0 then
        love.graphics.draw(obstacles[i]:getTexture(), obstacles[i]:getPosition().x, obstacles[i]:getPosition().y)
        if player1:getShot() then
          if obstacles[i]:collisionTest(player1) == 1 then
            obstacles[i]:setState()
          end
        end
      else
        obstacles[i] = nil
      end
    end
  end
end

function drawEnemies()
  for i=1,#enemies do
    if enemies[i]:getState() == 1 then
      love.graphics.draw(enemies[i]:getTexture(), enemies[i]:getPosition().x, enemies[i]:getPosition().y)
      if player1:getShot() then
        if enemies[i]:collisionTest(player1) == 1 then
          enemy.destroy(enemies[i])
          enemies[i]:setState()
          enemy.updateSpeed(enemies)
          player1:setScore(time)
        end
      end
      if enemies[i] and enemies[i]:getShot() then
        love.graphics.draw(enemies[i]:getShot().texture, enemies[i]:getShot().position_x,enemies[i]:getShot().position_y)
        for j=1, #obstacles do
          if obstacles[j] then
            if obstacles[j]:collisionTest(enemies[i]) == 1 then
              obstacles[j]:setState()
            end
          end
        end
        if player1:collisionTest(enemies[i]) == 1 then
          player1:setLives()
        end
      end
    end
  end
end

function drawPlayer()
  if player1:getLives() > 0 then
    love.graphics.draw(player1:getTexture(), player1:getPosition().x, player1:getPosition().y)
  end
  -- draw shot player
  if player1:getShot() then
    love.graphics.draw(player1:getShot():getTexture(), player1:getShot():getPosition().x, player1:getShot():getPosition().y)
  end
end

function drawPanel()
  love.graphics.draw(hr, 0, 580)
  -- draw score and lives
  if player1 then
    if player1:getLives() > 0 then
      for i=1, player1:getLives() do
        love.graphics.draw(player1:getTexture(), 350 + i*player1:getTexture():getWidth(), 600)
      end
    else
      game = "gameover"
    end
    love.graphics.printf( "LIVES", 310, 600, 640, "left", 0, 2, 2 )
    love.graphics.printf( "SCORE ", 10, 600, 640, "left", 0, 2, 2)
    love.graphics.printf( player1:getScore(), 110, 600, 640, "left", 0, 2, 2)
  end
end


-- -------------------------------------

function controlPlayer()
  player1:move()
  player1:keyboard(game)
  if player1:getShot() then -- If a shot was fired
    player1:getShot():moveUp()
  end
end

function makeEnemiesShots()
  for i=2,#enemies do
    if enemies[i]:getState() == 1 then
      if not enemies[i]:getShot() then
        enemies[i]:setShot(enemies)
      end
      if enemies[i]:getShot() then
        enemies[i]:getShot():moveDown()
      end
    end
  end
end

function moveEnemies()
  -- move all enemies
  if #enemies > 1 then
    direction = direction * setDirection()
    for i=2,#enemies do
      if enemies[i]:getState() == 1 then
        enemies[i]:move(direction)
      end
    end
  end
  -- move mystery enemy
  if enemies[1]:getState() == 1 then
    if enemies[1]:getPosition().x then
      directionMystery = directionMystery * reviewDirectionMystery()
      enemies[1]:move(directionMystery)
    end
  end
end

function setDirection()
  last_enemy = getFirstOrLastEnemy().last
  first_enemy = getFirstOrLastEnemy().first
  if first_enemy and last_enemy then
    if last_enemy:getPosition().x >= enemy.getLimitScreen().right - last_enemy:getTexture():getWidth() or first_enemy:getPosition().x <= enemy.getLimitScreen().left then
      return -1
    else
      return 1
    end
  else
    return 0
  end
end

function reviewDirectionMystery()
  if enemies[1]:getState() == 1 then
    local mystery = enemies[1]
    if mystery:getPosition().x >= enemy.getLimitScreen().right*2 or mystery:getPosition().x <= enemy.getLimitScreen().left - 600 then
      return -1 -- reverse values of shift
    else
      return 1
    end
  end
end

function getFirstOrLastEnemy()
  local enemies_ordered = {}
  for i = 2, #enemies do
    if enemies[i]:getState() == 1 then
      if enemies[i]:getPosition().x then
        table.insert(enemies_ordered,enemies[i])
      end
    end
  end

  function sortByPos(a,b)
    return a:getPosition().x > b:getPosition().x
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
