-- ### LOVE FUNCTIONS

love.load = function()
  -- Configura estado inicial dos inimigos
  setEnemies = function()
    enemie1_image = love.graphics.newImage("images/saucer1b.png")
    enemie2_image = love.graphics.newImage("images/saucer2b.png")
    enemie3_image = love.graphics.newImage("images/saucer3b.png")
    mystery_enemie_image = love.graphics.newImage("images/mysteryb.png")
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
    enemies_speed_vertical = 1
    enemies_speed_horizontal = 20
    mystery_enemie_speed = 20
    x_mystery_enemie_shift = 0
    x_enemies_shift = 0 -- Controle do quanto os inimigos se moveram para uma direção
    y_enemies_shift = 0
    direction_enemies = 1 -- Inimigos começam se movendo para a direita
    x_distance_btw_enemies = 40
    y_distance_btw_enemies = 30
  end

-- Configura estado inicial do player
  setPlayer = function()
    player_image = love.graphics.newImage("images/baseshipb.png")
    x_player = love.graphics.getWidth() / 2 - player_image:getWidth() / 2
    y_player = love.graphics.getHeight() - 2 * player_image:getHeight()
    max_x_player = love.graphics.getWidth() - player_image:getWidth()
    min_x_player = 0
    x_player_shift = 10

    setPlayerShot = function()
      player_shot_image = love.graphics.newImage("images/tiro.png")
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
end

function love.draw()
  -- Desenha as linhas de inimigos
  drawEnemies(#enemies)
  -- Desenha o player na tela
  love.graphics.draw(player_image, x_player, y_player)

  -- Atualiza posição do tiro do player
  updatePlayerShot = function()
    y_player_shot = y_player_shot_initial - y_player_shot_shift
    love.graphics.draw(player_shot_image, x_player_shot, y_player_shot)
  end

  -- Reseta o tiro se ele chegou no topo da tela
  testCollisionPlayerShot = function()
    if y_player_shot < 0 then
      resetShot()
    end
  end

  if player_shot_on_the_screen then
    updatePlayerShot()
    testCollisionPlayerShot()
  end
end

function love.update(dt)

  -- Faz o tiro do player subir na tela
  updatePlayerShotPosition = function(dt)
    if player_shot_on_the_screen then
      y_player_shot_shift = y_player_shot_shift + player_shot_speed*dt
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
    changeMysteryEnemieDirection = function()
      x_mystery_enemie_shift = x_mystery_enemie_shift * (-1)
      mystery_enemie_speed = mystery_enemie_speed * (-1)
    end

    -- Inverte o sentido de movimento do inimigo "mystery"
    if x_mystery_enemie <= min_x_mystery_enemie or x_mystery_enemie >= max_x_mystery_enemie then
      changeMysteryEnemieDirection()
    end

    x_mystery_enemie_shift = mystery_enemie_speed*dt
  end

  -- Controla as ações e estado do jogador
  controlPlayer = function()
    -- Player atira ao pressionar espaço
    love.keypressed = function(key)
      if key == "space" then
        -- Só pode atirar se não existe um tiro do player na tela
        if not player_shot_on_the_screen then
          player_shot_on_the_screen = true
          x_player_shot = x_player
          y_player_shot_initial = y_player
        end
      end
    end
    love.keypressed(key)

    movePlayer = function()
      -- Movimenta o player horizontalmente
      if love.keyboard.isDown("right") then
        if x_player < max_x_player then
          x_player = x_player + x_player_shift
        else
          x_player = max_x_player
        end
      end
      if love.keyboard.isDown("left") then
        if x_player > min_x_player then
          x_player = x_player - x_player_shift
        else
          x_player = min_x_player
        end
      end
    end
    movePlayer()

  end

  updateEnemiesPosition(dt)
  updatePlayerShotPosition(dt)
  controlPlayer()
end

-- end LOVE FUNCTIONS ###

function resetShot()
  y_player_shot = y_player
  player_shot_on_the_screen = false
  y_player_shot_shift = 0
end


-- Desenha a matriz de inimigos na tela
-- rows: número de linhas da matriz, usado na recursão
function drawEnemies(rows)
  if rows > 0 then
    -- Desenha uma linha de inimigos
    drawEnemiesOnTheRow = function(row, enemies_on_the_row)
      x_enemie = enemies_on_the_row * x_distance_btw_enemies + x_enemies_shift
      y_enemie = row * y_distance_btw_enemies + y_enemies_shift

      -- Testa se houve colisão de um inimigo com o tiro
      verifyCollision = function(row, enemies_on_the_row)
        -- Delimita os pontos de colisão do tiro
        limit_left = x_player_shot + player_shot_image:getWidth()/2 - enemie1_image:getWidth()
        limit_right = x_player_shot + player_shot_image:getWidth()/2
        limit_bottom = y_player_shot + player_shot_image:getHeight()/2
        -- Se o inimigo está vivo, testa a colisão dele com o tiro
        if enemies[row][enemies_on_the_row] == 1 then
          if x_enemie >= limit_left and x_enemie <= limit_right then
            if y_enemie + enemie1_image:getHeight() >= limit_bottom then
              -- TEM QUE CRIAR UMA NOVA MATRIZ AQUI
              enemies[row][enemies_on_the_row] = 0
              resetShot()
            end
          end
        end
      end

      verifyCollision(row, enemies_on_the_row)

      if enemies_on_the_row > 0 then
        -- Define inimigos diferentes conforme a linha da matriz
        if enemies[row][enemies_on_the_row] == 1 then
            if row <= 2 then
              love.graphics.draw(enemie1_image, x_enemie, y_enemie)
            elseif row == 3 or row == 4 then
              love.graphics.draw(enemie2_image, x_enemie, y_enemie)
            else
              love.graphics.draw(enemie3_image, x_enemie, y_enemie)
            end
        end
        -- Desenha os demais inimigos da linha recursivamente
        drawEnemiesOnTheRow(row, enemies_on_the_row-1)
      end

    end
    drawEnemiesOnTheRow(rows, #enemies[rows])
    drawEnemies(rows-1)
  end
  -- Desenha o inimigo "mystery"
  x_mystery_enemie = x_mystery_enemie + x_mystery_enemie_shift
  love.graphics.draw(mystery_enemie_image, x_mystery_enemie, y_mystery_enemie)
end
