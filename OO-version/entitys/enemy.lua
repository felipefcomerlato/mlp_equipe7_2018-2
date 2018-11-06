local character = require("entitys/character")
local shot = require("entitys/shot")

local enemy = {}
local distance_btw_enemies = 40
local direction_move_init = 1 -- todos inimigos começam se movendo à direita

function enemy.new(texture, position_x, position_y, speed, mystery_v_speed)
  local enemy = character.new(texture, position_x, position_y)
  enemy.speed = speed
  enemy.verticalSpeed = mystery_v_speed or speed/30
  enemy.shots = {}
  enemy.speed_shot = 5

  function enemy.getPosition(self)
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function enemy.move(self, direction)
    if self.position_x and self.position_y then
      self.position_x = self.position_x + self.speed * direction
      self.position_y = self.position_y + self.verticalSpeed
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

  function enemy.shot(self, enemies)
    -- if self:thereEnemiesBelow() == false then
    --   print("livre")
    -- end
    if self.position_y then
      fire = math.random(1, 2000)
      ready = true
      a = 0
      if fire == 50 then
        for i=2, #enemies do
          -- print(enemies[i].position_x)
          if enemies[i].position_x == self.position_x then
            if enemies[i].position_y > self.position_y then
              ready = false
            end
          end
        end
        -- print(ready)
        if ready then
          table.insert(self.shots,shot.new(self))
        end
      end
    end
  end

  -- function enemy.thereEnemiesBelow(self)
  --   for
  -- end



  return enemy
end

function enemy.destroy(enemy)
  enemy.texture = nil
  enemy.position_x = nil
  enemy.position_y = nil
  return enemy
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
      table.insert(enemies, enemy.new(texture, distance_btw_enemies, 0, 3, 0))
    else
      for c = 1, 14 do
        table.insert(enemies, enemy.new(texture,c*distance_btw_enemies, (r-1)*distance_btw_enemies, 1.8))
      end
    end
  end
  return enemies
end

function enemy.getDirTexture(row)
  if row == 1 then
    return "images/mysteryb.png"
  elseif row < 4 then
    return "images/saucer1b.png"
  elseif row < 6 then
    return "images/saucer2b.png"
  end
  return "images/saucer3b.png"
end

return enemy
