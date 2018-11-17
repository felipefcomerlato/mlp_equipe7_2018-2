-- ### LOVE FUNCTIONS
function love.load()

  math.randomseed(os.time())

  screenCenter = love.graphics.getWidth()/2

  setScenario = function()
    hr = love.graphics.newImage("images/border_bottom.png")
    background_image = love.graphics.newImage("images/background.png")
  end

  -- Configura estado inicial dos inimigos
  setEnemies = function()
    enemy1_image = love.graphics.newImage("images/saucer1b.png")
    enemy2_image = love.graphics.newImage("images/saucer2b.png")
    enemy3_image = love.graphics.newImage("images/saucer3b.png")
    mystery_enemy_image = love.graphics.newImage("images/mystery.png")
    max_x_mystery_enemy = love.graphics.getWidth() + 500
    min_x_mystery_enemy = -500
    x_mystery_enemy = max_x_mystery_enemy
    y_mystery_enemy = 10
    initial_state_of_enemies = {
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1}
              }
    states_of_enemies = {initial_state_of_enemies}
    current_state = #states_of_enemies
    enemies_speed_vertical = 1
    enemies_speed_horizontal = 20
    mystery_enemy_speed = 20
    x_mystery_enemy_shift = 0
    x_enemies_shift = 0 -- Controle do quanto os inimigos se moveram para uma direção
    y_enemies_shift = 0
    direction_enemies = 1 -- Inimigos começam se movendo para a direita
    x_distance_btw_enemies = 40
    y_distance_btw_enemies = 30


    setEnemyShot = function()
      enemy_shot_image = love.graphics.newImage("images/shot_enemy.png")
      x_enemy_shot = 0
      y_enemy_shot = love.graphics.getWidth()
      enemy_shot_speed = 400
      y_enemy_shot_shift = 0
      shot_enemy_on = false
    end
    setEnemyShot()

  end

-- Configura estado inicial do player
  setPlayer = function()
    player_image = love.graphics.newImage("images/player.png")
    player_position = {
      x = love.graphics.getWidth() / 2 - player_image:getWidth() / 2,
      y = love.graphics.getHeight() - 100
    }
    max_x_player = love.graphics.getWidth() - player_image:getWidth()
    min_x_player = 0
    x_player_shift = 10
    player_lives = 3
    score = 0
    time = 0

    setPlayerShot = function()
      player_shot_image = love.graphics.newImage("images/shot_enemy.png")
      x_player_shot = 0
      y_player_shot = love.graphics.getWidth()
      player_shot_speed = 900
      y_player_shot_shift = 0
      player_shot_on_the_screen = false
    end
    setPlayerShot()
  end



  setEnemies()
  setPlayer()
  setScenario()
end

make_enemy_shot = function(x, y)
  if not enemy_shot_on_the_screen then
    enemy_shot_on_the_screen = true
    x_enemy_shot = x
    y_enemy_shot_initial = y
  end
end



function love.draw()
  --set background image
  love.graphics.draw(background_image, 0,0)
  love.graphics.draw(hr, 0, 580)


  if player_lives > 0 then


    love.graphics.printf( "LIVES", 310, 600, 640, "left", 0, 2, 2 )
    love.graphics.printf( "SCORE ", 10, 600, 640, "left", 0, 2, 2)
    love.graphics.printf( score, 110, 600, 640, "left", 0, 2, 2)

    print_lives = function(num_lives)
      if num_lives > 0 then
        love.graphics.draw(player_image, 350+num_lives*player_image:getWidth(), 600)
        print_lives(num_lives-1)
      end
    end
    print_lives(player_lives)


    -- Desenha as linhas de inimigos
    -- Envia para a função drawEnemies o estado mais atual dos inimigos no jogo
    drawEnemies(#states_of_enemies[current_state])
    -- Desenha o player na tela
    love.graphics.draw(player_image, player_position.x, player_position.y)

    -- Atualiza posição do tiro do player
    updatePlayerShot = function()
      y_player_shot = y_player_shot_initial - y_player_shot_shift
      love.graphics.draw(player_shot_image, x_player_shot, y_player_shot)
    end


      -- Atualiza posição do tiro do player
    updateEnemyShot = function()
      y_enemy_shot = y_enemy_shot_initial + y_enemy_shot_shift
      love.graphics.draw(enemy_shot_image, x_enemy_shot, y_enemy_shot)
    end


    -- Reseta o tiro se ele chegou no topo da tela
    testCollisionPlayerShot = function()
      if y_player_shot < 0 then
        resetShot()
      end
    end

     -- Reseta o tiro do inimigo ele chegou no fim da tela
    testCollisionEnemyShot = function()
      if y_enemy_shot > love.graphics.getHeight() then
        resetEnemyShot()
      end
    end


    if enemy_shot_on_the_screen then
      updateEnemyShot()
      testCollisionEnemyShot()
    end

    if player_shot_on_the_screen then
      updatePlayerShot()
      testCollisionPlayerShot()
    end

  else
    enemywin = love.graphics.newImage("images/enemy-win.png")
    love.graphics.draw(enemywin, screenCenter - enemywin:getWidth()/2, 150)
    love.graphics.printf("GAMEOVER", 0, 400, screenCenter, "center", 0, 2, 2)
    love.graphics.printf("PRESS ENTER TO RESTART", 0, 550, screenCenter, "center", 0, 2, 2)
  end


end

function love.update(dt)

  time = time + dt

  -- Faz o tiro do player subir na tela
  updatePlayerShotPosition = function(dt)
    if player_shot_on_the_screen then
      y_player_shot_shift = y_player_shot_shift + player_shot_speed*dt
    end
  end

  updateEnemyShotPosition = function(dt)
    if enemy_shot_on_the_screen then
      y_enemy_shot_shift = y_enemy_shot_shift + enemy_shot_speed*dt
    end
  end

  -- Atualiza posição dos inimigos
  updateEnemiesPosition = function(dt)
    y_enemies_shift = y_enemies_shift + (enemies_speed_vertical)*dt
    x_enemies_shift = x_enemies_shift + enemies_speed_horizontal*dt*direction_enemies
    if x_enemies_shift >= 40 or x_enemies_shift <= -30 then
      direction_enemies = direction_enemies*(-1)
    end

    -- Movimenta o inimigo "mystery"
    changeMysteryenemyDirection = function()
      x_mystery_enemy_shift = x_mystery_enemy_shift * (-1)
      mystery_enemy_speed = mystery_enemy_speed * (-1)
    end

    -- Inverte o sentido de movimento do inimigo "mystery"
    if x_mystery_enemy <= min_x_mystery_enemy or x_mystery_enemy >= max_x_mystery_enemy then
      changeMysteryenemyDirection()
    end

    x_mystery_enemy_shift = mystery_enemy_speed*dt
  end

  -- Controla as ações e estado do jogador
  controlPlayer = function()

    movePlayer = function()
      -- Movimenta o player horizontalmente
      if love.keyboard.isDown("right") then
        if player_position.x < max_x_player then
          player_position.x = player_position.x + x_player_shift
        else
          player_position.x = max_x_player
        end

      elseif love.keyboard.isDown("left") then
        if player_position.x > min_x_player then
          player_position.x = player_position.x - x_player_shift
        else
          player_position.x = min_x_player
        end

      elseif love.keyboard.isDown("return") then
        love.load()

      elseif love.keyboard.isDown("space") then
        -- Só pode atirar se não existe um tiro do player na tela
        if not player_shot_on_the_screen then
          player_shot_on_the_screen = true
          x_player_shot = player_position.x
          y_player_shot_initial = player_position.y
        end

      --encerra o jogo
      elseif love.keyboard.isDown("escape") then
        love.event.quit()
      end
    end
    movePlayer()

  end

  updateEnemiesPosition(dt)
  updatePlayerShotPosition(dt)
  updateEnemyShotPosition(dt)
  controlPlayer()
end

-- end LOVE FUNCTIONS ###

function resetShot()
  y_player_shot = player_position.y
  player_shot_on_the_screen = false
  y_player_shot_shift = 0
end

function resetEnemyShot()
  --y_player_shot = y_player
  enemy_shot_on_the_screen = false
  y_enemy_shot_shift = 0
end



-- Recebe a matriz de inimigos e devolve uma cópia
function newStateOfEnemies(enemies,death_row,death_col)
  copyEnemies = {}
  insertRows = function(r)
    if r > 0 then
      copyEnemies[r] = {}
      insertCols = function(c)
        if c > 0 then
          if r == death_row and c == death_col then
            copyEnemies[r][c] = 0
          else
            copyEnemies[r][c] = enemies[r][c]
          end
          insertCols(c-1)
        end
      end
      insertCols(#enemies[r])
      insertRows(r-1)
    end
  end
  insertRows(#enemies)
  return copyEnemies
end

function currying2(f)
  return function(a)
    return function(b)
      return f(a, b)
    end
  end
end

-- Função não utilizada.
-- Implementada apenas como exemplo de função de ordem superior
function map(fun, t, sizeT)
  if sizeT > 0 then
    fun(t[sizeT])
    map(fun, t, sizeT-1)
  end
end

-- Desenha a matriz de inimigos na tela
-- rows: número de linhas da matriz, usado na recursão
function drawEnemies(rows)

  if rows > 0 then
    -- Desenha uma linha de inimigos
    drawEnemiesOnTheRow = function(row, enemies_on_the_row)
      x_enemy = enemies_on_the_row * x_distance_btw_enemies + x_enemies_shift
      y_enemy = row * y_distance_btw_enemies + y_enemies_shift

      if states_of_enemies[current_state][row][enemies_on_the_row] == 1 then
        fire = math.random(1, 20)
          if fire > 10 and fire < 20 then
            make_enemy_shot(x_enemy + enemy1_image:getWidth()/2, y_enemy+enemy1_image:getHeight())
        end
      end

      -- Testa se houve colisão de um inimigo com o tiro
      verifyCollision = function(row, enemies_on_the_row)
        -- Delimita os pontos de colisão do tiro
        limit_left = x_player_shot + player_shot_image:getWidth()/2 - enemy1_image:getWidth()
        limit_right = x_player_shot + player_shot_image:getWidth()/2
        limit_bottom = y_player_shot + player_shot_image:getHeight()/2

        -- Se o inimigo está vivo, testa a colisão dele com o tiro
        if states_of_enemies[current_state][row][enemies_on_the_row] == 1 then
          if x_enemy >= limit_left and x_enemy <= limit_right then
            if y_enemy + enemy1_image:getHeight() >= limit_bottom then
              -- Gera novo estado dos inimigos a partir de uma cópia do estado atual
              table.insert(states_of_enemies, newStateOfEnemies(states_of_enemies[current_state],row,enemies_on_the_row))
              current_state = #states_of_enemies
              score = score + math.floor((1/time) * 5000)
              resetShot()
            end
          end
        end
      end


      -- Testa se houve colisão do player com o tiro
      verifyCollisionPlayer = function(player_y, player_x)
        -- Delimita os pontos de colisão do tiro
        limit_side = x_enemy_shot
        limit_bottom = y_enemy_shot + enemy_shot_image:getHeight()

        if player_x <= limit_side and player_x + player_image:getWidth() >= limit_side then
          if player_y <= limit_bottom and player_y + player_image:getHeight() >= limit_bottom then
            if enemy_shot_on_the_screen then
              player_lives = player_lives - 1
              resetEnemyShot()
            end
          end
        end
      end

      verifyCollisionPlayer(player_position.y,player_position.x)

      -- Implementação currying
      local verifyCollision = currying2(verifyCollision)
      local funRow = verifyCollision(row)
      local funCol = funRow(enemies_on_the_row)

      if enemies_on_the_row > 0 then
        -- Define inimigos diferentes conforme a linha da matriz
        if states_of_enemies[current_state][row][enemies_on_the_row] == 1 then
            if row <= 2 then
              love.graphics.draw(enemy1_image, x_enemy, y_enemy)
            elseif row == 3 or row == 4 then
              love.graphics.draw(enemy2_image, x_enemy, y_enemy)
            else
              love.graphics.draw(enemy3_image, x_enemy, y_enemy)
            end
        end
        -- Desenha os demais inimigos da linha recursivamente
        drawEnemiesOnTheRow(row, enemies_on_the_row-1)
      end

    end
    drawEnemiesOnTheRow(rows, #states_of_enemies[current_state][rows])
    drawEnemies(rows-1)
  end
  -- Desenha o inimigo "mystery"
  x_mystery_enemy = x_mystery_enemy + x_mystery_enemy_shift
  love.graphics.draw(mystery_enemy_image, x_mystery_enemy, y_mystery_enemy)
end
