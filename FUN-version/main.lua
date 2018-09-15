local enemie_image
local player_image
local shot_player_image
local num
local enemies_speed = 5
local y_enemies_shift = 0
-- local x_player = love.graphics.getWidth() / 2
-- local y_player = love.graphics.getHeight() -
local shot_speed = 900
local x_shot
local y_shot
local y_shot_initial
local y_shot_shift = 0
local shot_on_the_screen = false

enemies = {{1,1,1,1,1,1,1,1,1}, {1,1,1,1,1,1,1,1,1}, {1,1,1,1,1,1,1,1,1}, {1,1,1,1,1,1,1,1,1}}

function love.load()
  enemie_image = love.graphics.newImage("images/saucer1b.png")
  player_image = love.graphics.newImage("images/baseshipb.png")
  shot_player_image = love.graphics.newImage("images/tiro.png")
  x_player = love.graphics.getWidth() / 2 - player_image:getWidth() / 2
  y_player = love.graphics.getHeight() - 2 * player_image:getHeight()
  love.graphics.setBackgroundColor(0,0,0)
end

function love.draw()
  drawEnemies(#enemies)
  love.graphics.draw(player_image, x_player, y_player)
  if shot_on_the_screen then
    y_shot = y_shot_initial - y_shot_shift
    love.graphics.draw(shot_player_image, x_shot, y_shot)
    if y_shot < 0 then
      shot_on_the_screen = false
      y_shot_shift = 0
    end
  end
end

function love.keypressed(key)
  if key == "space" then
    if not shot_on_the_screen then
      shot_on_the_screen = true
      x_shot = x_player
      y_shot_initial = y_player
    end
  end
end

function draw_shot(x_shot, y_shot_initial)
  love.graphics.draw(enemie_image, x_shot, y_shot_initial)
end

function love.update(dt)
  y_enemies_shift = y_enemies_shift + enemies_speed*dt
  if shot_on_the_screen then
    y_shot_shift = y_shot_shift + shot_speed*dt
  end
  if love.keyboard.isDown("right") then   -- reduce the value
    x_player = x_player + 10
  end
  if love.keyboard.isDown("left") then   -- increase the value
    x_player = x_player - 10
  end
end

-- function draw_shot(x_shot, y_shot)
--   love.graphics.draw(shot_player_image, x_shot, y_shot)
-- end

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
