-- Epic code

function clamp(n, min, max)
  if n < min then n = min end
  if n > max then n = max end
  return n
end

local karl_charge_default = 1000

-- Karl gud
function DoKarl(x, y)
  if not cells[y][x].movement then cells[y][x].movement = {x = 0, y = 0} end
  if not cells[y][x].karl_age then cells[y][x].karl_age = 0 end

  cells[y][x].testvar = "Karl"

  cells[y][x].karl_age = cells[y][x].karl_age + 1

  local calcMovement = {x = 0, y = 0}

  local neighborCount = 0

  if cells[y+1][x].ctype ~= 0 or cells[y-1][x].ctype == -1 then
    calcMovement.y = calcMovement.y - 1
    neighborCount = neighborCount + 1
  end
  if cells[y-1][x].ctype ~= 0 or cells[y+1][x].ctype == -1 then
    calcMovement.y = calcMovement.y + 1
    neighborCount = neighborCount + 1
  end
  if cells[y][x+1].ctype ~= 0 or cells[y][x-1].ctype == -1 then
    calcMovement.x = calcMovement.x - 1
    neighborCount = neighborCount + 1
  end
  if cells[y][x-1].ctype ~= 0 or cells[y][x+1].ctype == -1 then
    calcMovement.x = calcMovement.x + 1
    neighborCount = neighborCount + 1
  end

  
  if neighborCount < 4 then
    if calcMovement.x ~= 0 or calcMovement.y ~= 0 then
      cells[y][x].movement = calcMovement
    end
  else
    cells[y][x].movement = {x = 0, y = 0}
  end

  -- Movement time

  local movement = cells[y][x].movement

  -- if cells[y][x].karl_age > 75 and love.math.random(1, 100) > 90 then
  --   local movements = {
  --     {
  --       x = 1,
  --       y = 0,
  --     },
  --     {
  --       x = -1,
  --       y = 0,
  --     },
  --     {
  --       x = 0,
  --       y = 1,
  --     },
  --     {
  --       x = 0,
  --       y = -1,
  --     },
  --   }

  --   movement = movements[love.math.random(1, #movements)]
  -- end

  if y+movement.y < 0 or x+movement.x < 0 or movement.x + x > width-1 or movement.y + y > height-1 then
    return
  end

  if cells[y+movement.y][x+movement.x].ctype == 0 or cells[y+movement.y][x+movement.x].ctype == -1 then
    local replicating = false
    if cells[y+movement.y][x+movement.x].ctype == -1 and cells[y][x].karl_age < 20 then
      cells[y+movement.y][x+movement.x].ctype = 0
      if love.math.random(1, 100) < 1 then
        replicating = true
      end
    end
    local karl = CopyTable(cells[y][x])
    if not replicating then
      cells[y][x].ctype = 0
      cells[y][x].karl_age = nil
      cells[y][x].testvar = ""
    end
    if cells[y][x].ctype == 0 then cells[y][x].movement = nil end
    cells[y+movement.y][x+movement.x] = CopyTable(karl)
    SetChunk(x+movement.x, y+movement.y, karl.ctype)
  end
end

function FeedKarl(x, y, amount)
end
karlID = 0

function AddLife()
  karlID = addCell("BM life karl", "bmod/karl.png", function() return true end, "trash")
end
