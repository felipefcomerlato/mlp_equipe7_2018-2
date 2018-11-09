local character = require("entitys/character")
local shot = require("entitys/shot")

local enemy = {}
local distance_btw_enemies = 40
local direction_move_init = 1 -- All enemies start moving to the right
local speed = 1.5 -- Speed default except mystery
local increase_speed_factor = 1.01

function enemy.new(texture, position_x, position_y, mystery_h_speed, mystery_v_speed)
  local enemy = character.new(texture, position_x, position_y)
  enemy.speed = mystery_h_speed or speed
  enemy.vertical_speed = mystery_v_speed or speed/40
  enemy.shots = {}
  enemy.speed_shot = 3
  enemy.state = 1 -- 1 = alive; 0 = dead

  function enemy.getState(self)
    return self.state
  end

  function enemy.setState(self)
    self.state = self.state - 1
  end

  function enemy.setSpeed(self)
    self.speed = self.speed * increase_speed_factor
  end

  function enemy.getSpeedShot(self)
    return self.speed_shot
  end

  function enemy.getVerticalSpeed(self)
    return self.vertical_speed
  end

  function enemy.getShot(self)
    if self.shots[1] then
      return self.shots[1]
    end
  end

  function enemy.getTexture(self)
    return self.texture
  end

  function enemy.setShot(self, enemies)
    if self.position_y then
      fire = math.random(1, #enemies * 10)
      -- print(fire)
      ready = true
      if fire == 2 then
        for i=2, #enemies do
          if enemies[i]:getState() == 1 then
            if enemies[i].position_x == self.position_x then
              if enemies[i].position_y > self.position_y then
                ready = false
              end
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

    shot_player = player:getShot()

    shot_coord = {
      x = shot_player:getPosition().x + shot_player:getTexture():getWidth() / 2,
      y = shot_player:getPosition().y + shot_player:getTexture():getHeight() / 2
    }

    if body.bottom >= shot_coord.y then
      if body.left <= shot_coord.x then
        if body.right >= shot_coord.x then
          if body.top <= shot_coord.y then
            shot_player:destroy(player)
            return 1
          end
        end
      end
    end
  end

  return enemy
end

function enemy.updateSpeed(enemies)
  for i=2, #enemies do
    enemies[i]:setSpeed()
  end
end

function enemy.getLimitScreen()
  return character.getLimitScreen()
end

function enemy.getDirectionMoveInit()
  return direction_move_init
end

function enemy.destroy(enemie)
  enemie.position_x = nil
  enemie.position_y = nil
  enemie.position_texture = nil
  return enemie
end

function enemy.makeEnemies()
  -- enemies é uma tabela de OBJETOS (inimigos)
  local enemies = {}
  -- "linha 1" da tela é do mysteryb
  -- "linhas 2 à 7" da tela são dos demais inimigos
  -- cada "linha" tem 14 "colunas" de inimigos
  for r = 1, 6 do
    local texture = enemy.getDirTexture(r)
    if r == 1 then
      -- O primeiro inimigo é o mystery. Inicia na posição 0, velocidade 10 e velocidade vertical 0
      table.insert(enemies, enemy.new(texture, distance_btw_enemies, 10, 3, 0))
    else
      for c = 1, 11 do
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
