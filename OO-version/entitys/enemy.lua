local character = require("entitys/character")
local shot = require("entitys/shot")

local enemy = {}
local distance_btw_enemies = 40
local direction_move_init = 1 -- todos inimigos começam se movendo à direita
local speed = 1.5 -- speed default except mystery

function enemy.new(texture, position_x, position_y, mystery_h_speed, mystery_v_speed)
  local enemy = character.new(texture, position_x, position_y)
  enemy.speed = mystery_h_speed or speed
  enemy.vertical_speed = mystery_v_speed or speed/40
  enemy.shots = {}
  enemy.speed_shot = 3
  enemy.inverse_freq_shots = 1500


  function enemy.getSpeed(self)
    return self.speed
  end

  function enemy.getSpeedShot(self)
    return self.speed_shot
  end

  function enemy.getInverseFreqShots(self)
    return self.inverse_freq_shots
  end

  function enemy.getVerticalSpeed(self)
    return self.vertical_speed
  end

  function enemy.getShot(self)
    if self.shots[1] then
      return self.shots[1]
    end
  end

  function enemy.getPosition(self)
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function enemy.getTexture(self)
    return self.texture
  end

  function enemy.setShot(self, enemies)
    if self.position_y then
      fire = math.random(1, self.inverse_freq_shots)
      ready = true
      if fire == 2 then
        for i=2, #enemies do
          if enemies[i].position_x == self.position_x then
            if enemies[i].position_y > self.position_y then
              ready = false
            end
          end
        end
        if ready then
          table.insert(self.shots,shot.new(self, "enemy"))
        end
      end
    end
  end

  function enemy.move(self, direction)
    if self.position_x and self.position_y then
      self.position_x = self.position_x + self.speed * direction
      self.position_y = self.position_y + self.vertical_speed
    end
  end

  function enemy.collisionTest(self, player)

    body = {
      left = self.position_x,
      right = self.position_x + self.texture:getWidth(),
      top = self.position_y,
      bottom = self.position_y + self.texture:getHeight()
    }

    shot_player = player.shots[1]

    shot_c = {
      x = shot_player.position_x + shot_player.texture:getWidth() / 2,
      y = shot_player.position_y + shot_player.texture:getHeight() / 2
    }

    if body.bottom >= shot_c.y then
      if body.left <= shot_c.x then
        if body.right >= shot_c.x then
          if body.top <= shot_c.y then
            shot_player:destroy(player)
            return 1
          end
        end
      end
    end
  end

  return enemy
end

function enemy.destroy(enemy)
  enemy.texture = nil
  enemy.position_x = nil
  enemy.position_y = nil
  return enemy
end

function enemy.updateSkills(enemies)
  for i=2, #enemies do
    enemies[i].speed = enemies[i].speed * 1.01
    if enemies[i].speed > 3.9 then
      enemies[i].inverse_freq_shots = 5
    elseif enemies[i].speed > 3.3 then
      enemies[i].inverse_freq_shots = 100
    elseif enemies[i].speed > 2.9 then
      enemies[i].inverse_freq_shots = 400
    elseif enemies[i].speed > 2.3 then
      enemies[i].inverse_freq_shots = 800
    end
  end
end

function enemy.getLimitScreen()
  return character.getLimitScreen()
end

function enemy.getDirectionMoveInit()
  return direction_move_init
end


function enemy.makeEnemies()
  -- enemies é uma tabela de OBJETOS (inimigos)
  local enemies = {}
  -- "linha 1" da tela é do mysteryb
  -- "linhas 2 à 7" da tela são dos demais inimigos
  -- cada "linha" tem 14 "colunas" de inimigos
  for r = 1, 7 do
    local texture = enemy.getDirTexture(r)
    if r == 1 then
      -- O primeiro inimigo é o mystery. Inicia na posição 0, velocidade 10 e velocidade vertical 0
      table.insert(enemies, enemy.new(texture, distance_btw_enemies, 10, 3, 0))
    else
      for c = 1, 14 do
        table.insert(enemies, enemy.new(texture,c*distance_btw_enemies, (r-1)*distance_btw_enemies))
      end
    end
  end
  return enemies
end

function enemy.getDirTexture(row)
  if row == 1 then
    return "images/mystery.png"
  elseif row < 4 then
    return "images/saucer1b.png"
  elseif row < 6 then
    return "images/saucer2b.png"
  end
  return "images/saucer3b.png"
end

return enemy
