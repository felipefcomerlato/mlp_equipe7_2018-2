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
    testCollisionShotPlayer()
  end
end

function love.keypressed(key)
  if key == "space" then
    if not shot_player_on_the_screen then
      shot_player_on_the_screen = true
      x_shot_player = x_player
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
  x_shot_player = 0
  y_shot_player = love.graphics.getWidth()
  local y_shot_player_initial
  shot_player_speed = 900
  y_shot_player_shift = 0
  shot_player_on_the_screen = false
end

function setEnemies()
  enemie1_image = love.graphics.newImage("images/saucer1b.png")
  enemie2_image = love.graphics.newImage("images/saucer2b.png")
  enemie3_image = love.graphics.newImage("images/saucer3b.png")
  mystery_enemie_image = love.graphics.newImage("images/mysteryb.png")
  min_x_enemie = 0
  max_x_enemie = love.graphics.getWidth() - enemie1_image:getWidth()
  max_x_mystery_enemie = love.graphics.getWidth() + 500
  min_x_mystery_enemie = -500
  x_mystery_enemie = max_x_mystery_enemie
  y_mystery_enemie = 10
  enemies = {
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1}
            }

  enemies_speed = 5
  mystery_enemie_speed = 20
  x_mystery_enemie_shift = 0
  x_enemies_shift = 0
  y_enemies_shift = 0
  x_distance_btw_enemies = 40
  y_distance_btw_enemies = 30
  dead_enemie = false
end


-- end SET FUNCTIONS ###

--
function drawShotPlayer()
  y_shot_player = y_shot_player_initial - y_shot_player_shift
  love.graphics.draw(shot_player_image, x_shot_player, y_shot_player)
end

function testCollisionShotPlayer()
  if y_shot_player < 0 then
    resetShot()
  end
end

function resetShot()
  y_shot_player = y_player
  shot_player_on_the_screen = false
  y_shot_player_shift = 0
end

function updatePositionShotPlayer(dt)
  if shot_player_on_the_screen then
    y_shot_player_shift = y_shot_player_shift + shot_player_speed*dt
  end
end

function updatePositionEnemies(dt)
  y_enemies_shift = y_enemies_shift + enemies_speed*dt
  --x_enemies_shift = x_enemies_shift + 10*enemies_speed*dt
  if x_mystery_enemie <= min_x_mystery_enemie or x_mystery_enemie >= max_x_mystery_enemie then
    changeDirectionMysteryEnemie()
  end
  x_mystery_enemie_shift = mystery_enemie_speed*dt
end

function changeDirectionMysteryEnemie()
  x_mystery_enemie_shift = x_mystery_enemie_shift * (-1)
  mystery_enemie_speed = mystery_enemie_speed * (-1)
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
  x_mystery_enemie = x_mystery_enemie + x_mystery_enemie_shift
  love.graphics.draw(mystery_enemie_image, x_mystery_enemie, y_mystery_enemie)
end

function verifyCollision()
  limit_left = x_shot_player + shot_player_image:getWidth()/2 - enemie1_image:getWidth()
  limit_right = x_shot_player + shot_player_image:getWidth()/2
  limit_bottom = y_shot_player + shot_player_image:getHeight()/2
  if x_enemie >= limit_left and x_enemie <= limit_right then
    if y_enemie >= limit_bottom then
      dead_enemie = true
      resetShot()
    end
  end
end

function drawEnemieCol(row, enemies_on_the_row)
  x_enemie = enemies_on_the_row * x_distance_btw_enemies -- + x_enemies_shift
  y_enemie = row * y_distance_btw_enemies + y_enemies_shift
  verifyCollision()
  if dead_enemie then
    enemies[row][enemies_on_the_row] = 0
    dead_enemie = false
  end
  if enemies_on_the_row > 0 then
    if enemies[row][enemies_on_the_row] == 1 then
        if row <= 2 then
          love.graphics.draw(enemie1_image, x_enemie, y_enemie)
        elseif row > 2 and row <= 4 then
          love.graphics.draw(enemie2_image, x_enemie, y_enemie)
        else
          love.graphics.draw(enemie3_image, x_enemie, y_enemie)
        end
    end
    drawEnemieCol(row, enemies_on_the_row-1)
  end
end
