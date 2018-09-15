-- ### LOVE FUNCTIONS

function love.load()
  setEnemies()
  setPlayer()
end

function love.draw()
  drawEnemies(#enemies)
  love.graphics.draw(player_image, x_player, y_player)
  if shot_player_on_the_screen then
    drawShotPlayer()
    testColisionShotPlayer()
  end
end

function love.keypressed(key)
  if key == "space" then
    if not shot_player_on_the_screen then
      shot_player_on_the_screen = true
      x_shot = x_player
      y_shot_player_initial = y_player
    end
  end
end

function love.update(dt)
  updatePositionEnemies(dt)
  updatePositionShotPlayer(dt)
  controlPlayer()
end

-- end LOVE FUNCTIONS ###

-- ### SET FUNCTIONS

function setPlayer()
  player_image = love.graphics.newImage("images/baseshipb.png")
  x_player = love.graphics.getWidth() / 2 - player_image:getWidth() / 2
  y_player = love.graphics.getHeight() - 2 * player_image:getHeight()
  max_x_player = love.graphics.getWidth() - player_image:getWidth()
  min_x_player = 0
  x_player_shift = 10
  setShotPlayer()
end

function setShotPlayer()
  shot_player_image = love.graphics.newImage("images/tiro.png")
  local x_shot_player
  local y_shot_player
  local y_shot_player_initial
  shot_player_speed = 900
  y_shot_player_shift = 0
  shot_player_on_the_screen = false
end

function setEnemies()
  enemie_image = love.graphics.newImage("images/saucer1b.png")
  enemies = {
              {1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1}
            }
  enemies_speed = 5
  y_enemies_shift = 0
end


-- end SET FUNCTIONS ###

--
function drawShotPlayer()
  y_shot = y_shot_player_initial - y_shot_player_shift
  love.graphics.draw(shot_player_image, x_shot, y_shot)
end

function testColisionShotPlayer()
  -- Aqui implementar colisão do tiro com inimigo
  -- Por enquanto só tá testando limite da tela
  if y_shot < 0 then
    shot_player_on_the_screen = false
    y_shot_player_shift = 0
  end
end

function updatePositionShotPlayer(dt)
  if shot_player_on_the_screen then
    y_shot_player_shift = y_shot_player_shift + shot_player_speed*dt
  end
end

function updatePositionEnemies(dt)
  y_enemies_shift = y_enemies_shift + enemies_speed*dt
end

function controlPlayer()
  if love.keyboard.isDown("right") then   -- reduce the value
    if x_player < max_x_player then
      x_player = x_player + x_player_shift
    else
      x_player = max_x_player
    end
  end
  if love.keyboard.isDown("left") then   -- increase the value
    if x_player > min_x_player then
      x_player = x_player - x_player_shift
    else
      x_player = min_x_player
    end
  end
end

function drawEnemies(rows)
  if rows > 0 then
    drawEnemieCol(rows, #enemies[rows])
    drawEnemies(rows-1)
  end
end

function drawEnemieCol(row, enemies_on_the_row)
  if enemies_on_the_row > 0 then
    if enemies[row][enemies_on_the_row] == 1 then
      love.graphics.draw(enemie_image, enemies_on_the_row*60, row*25 + y_enemies_shift)
    end
    drawEnemieCol(row, enemies_on_the_row-1)
  end
end
