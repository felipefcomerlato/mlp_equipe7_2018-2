local character = require("entitys/character")
local shot = require("entitys/shot")

local enemy = {}
local distance_btw_enemies = 40
local direction_move_init = 1 -- All enemies start moving to the right
local default_speed = 1.5 -- Speed default except mystery
local increase_speed_factor = 1.01

function enemy.new(texture, position_x, position_y, mystery_h_speed, mystery_v_speed)
  local enemy = character.new(texture, position_x, position_y)
  local speed = mystery_h_speed or default_speed
  local vertical_speed = mystery_v_speed or speed/40
  local shots = {}
  local speed_shot = 3
  local state = 1 -- 1 = alive; 0 = dead

  function enemy:dShot()
    if #shots > 0 then
      shots[1] = nil
    end
  end

  function enemy:getState()
    return state
  end

  function enemy:setState()
    state = state - 1
  end

  function enemy:setSpeed()
    speed = speed * increase_speed_factor
  end

  function enemy:getSpeedShot()
    return speed_shot
  end

  function enemy:getVerticalSpeed()
    return vertical_speed
  end

  function enemy:getShot()
    if shots[1] then
      return shots[1]
    end
  end

  function enemy:getTexture()
    return self.texture
  end

  function enemy:setShot(enemies)
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
          table.insert(shots,shot.new(self, "enemy"))
        end
      end
    end
  end

  function enemy:move(direction)
    if self.position_x and self.position_y then
      self.position_x = self.position_x + speed * direction
      self.position_y = self.position_y + vertical_speed
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
