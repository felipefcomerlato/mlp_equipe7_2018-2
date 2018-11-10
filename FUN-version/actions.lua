-- thread for actions

movePlayer = function()
  -- Movimenta o player horizontalmente
  if love.keyboard.isDown("right") then
    if x_player < max_x_player then
      x_player = x_player + x_player_shift
    else
      x_player = max_x_player
    end

  elseif love.keyboard.isDown("left") then
    if x_player > min_x_player then
      x_player = x_player - x_player_shift
    else
      x_player = min_x_player
    end

  elseif love.keyboard.isDown("space") then
    -- Só pode atirar se não existe um tiro do player na tela
    if not player_shot_on_the_screen then
      player_shot_on_the_screen = true
      x_player_shot = x_player
      y_player_shot_initial = y_player
    end

  --encerra o jogo
  elseif love.keyboard.isDown("escape") then
    love.event.quit()
  end
end
print ("vishhhh")
movePlayer()
