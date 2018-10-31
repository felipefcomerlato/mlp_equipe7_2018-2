local character = require("entitys/character")

local enemy = {}
local distance_btw_enemies = 40
local move_limit_right = 600
local move_limit_left = 0
local direction_move_init = 1 -- todos inimigos começam se movendo à direita

function enemy.new(texture, position_x, position_y, speed, mysterySpeed)
  local enemy = character.new(texture, position_x, position_y)
  enemy.speed = speed
  enemy.verticalSpeed = mysterySpeed or speed/20

  function enemy.getPosition(self)
    return {
      x = self.position_x,
      y = self.position_y
    }
  end

  function enemy.move(self, direction)
      self.position_x = self.position_x + self.speed * direction
      self.position_y = self.position_y + self.verticalSpeed
  end

  return enemy
end

function enemy.getMoveLimit()
  return{
    right = move_limit_right,
    left = move_limit_left
  }
end

function enemy.getDirectionMoveInit()
  return direction_move_init
end


function enemy.makeTable()
  -- table_of_enemies é uma tabela de OBJETOS (inimigos)
  local table_of_enemies = {}
  -- "linha 1" da tela é do mysteryb
  -- "linhas 2 à 7" da tela são dos demais inimigos
  -- cada "linha" tem 14 "colunas" de inimigos
  for r = 1, 7 do
    local texture = enemy.getDirTexture(r)
    if r == 1 then
      -- O primeiro inimigo é o mystery. Inicia na posição 0, velocidade 10 e velocidade vertical 0
      table.insert(table_of_enemies, enemy.new(texture, distance_btw_enemies, 0, 3, 0))
    else
      for c = 1, 14 do
        table.insert(table_of_enemies, enemy.new(texture,c*distance_btw_enemies, (r-1)*distance_btw_enemies, 1))
      end
    end
  end
  return table_of_enemies
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
