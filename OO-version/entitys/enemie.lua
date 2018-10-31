local character = require("entitys/character")

local enemie = {}

function enemie.novo(texture, position_x, position_y)
  local enemie = character.novo(texture, position_x, position_y)
  distance_btw_enemies = 40
  return enemie
end

function enemie.makeTable()
  local table_of_enemies = {}
  for r = 2, 7 do
    local texture = enemie.getDirTexture(r)
    for c = 1, 14 do
      table.insert(table_of_enemies, enemie.novo(texture,c*distance_btw_enemies, r*distance_btw_enemies))
    end
  end
  return table_of_enemies
end

function enemie.getDirTexture(row)
  if row == 1 then
    return "images/mysteryb.png"
  elseif row < 4 then
    return "images/saucer1b.png"
  elseif row < 6 then
    return "images/saucer2b.png"
  end
  return "images/saucer3b.png"
end

return enemie
