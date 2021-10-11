-- Code by UndefinedMonitor

local karl_charge_default = 1000
local evilKarlMutationChance = 85
local goodKarlMutationChance = 85
local karl_mean_fail = 50

meanKarlID = 0
karlID = 0
healKarlID = 0

-- Mean karl too mean so we must stonp him
function DoHealKarl(x, y)
  if cells[y+1][x].ctype == meanKarlID then
    cells[y+1][x].ctype = karlID
  end
  if cells[y-1][x].ctype == meanKarlID then
    cells[y-1][x].ctype = karlID
  end
  if cells[y][x+1].ctype == meanKarlID then
    cells[y][x+1].ctype = karlID
  end
  if cells[y][x-1].ctype == meanKarlID then
    cells[y][x-1].ctype = karlID
  end
  DoKarl(x, y)
end

-- O no mean karl y karl mean
function DoMeanKarl(x, y)
  if cells[y+1][x].ctype == karlID then
    if love.math.random(1, 100) <= karl_mean_fail then
      cells[y][x].ctype = karlID
    else
      cells[y+1][x].ctype = meanKarlID
    end
  end
  if cells[y-1][x].ctype == karlID then
    if love.math.random(1, 100) <= karl_mean_fail then
      cells[y][x].ctype = karlID
    else
      cells[y-1][x].ctype = meanKarlID
    end
  end
  if cells[y][x+1].ctype == karlID then
    if love.math.random(1, 100) <= karl_mean_fail then
      cells[y][x].ctype = karlID
    else
      cells[y][x+1].ctype = meanKarlID
    end
  end
  if cells[y][x-1].ctype == karlID then
    if love.math.random(1, 100) <= karl_mean_fail then
      cells[y][x].ctype = karlID
    else
      cells[y][x-1].ctype = meanKarlID
    end
  end
  DoKarl(x, y)
end

-- Karl gud
function DoKarl(x, y)
  if not cells[y][x].movement then cells[y][x].movement = {x = 0, y = 0} end
  if not cells[y][x].karl_age then cells[y][x].karl_age = 0 end

  cells[y][x].testvar = "Karl"

  cells[y][x].karl_age = cells[y][x].karl_age + 1

  local calcMovement = {x = 0, y = 0}

  local neighborCount = 0

  if (cells[y+1][x].ctype ~= 0 and cells[y+1][x].ctype ~= -1) or cells[y-1][x].ctype == -1 then
    calcMovement.y = calcMovement.y - 1
    neighborCount = neighborCount + 1
  end
  if (cells[y-1][x].ctype ~= 0 and cells[y-1][x].ctype ~= -1) or cells[y+1][x].ctype == -1 then
    calcMovement.y = calcMovement.y + 1
    neighborCount = neighborCount + 1
  end
  if (cells[y][x+1].ctype ~= 0 and cells[y][x+1].ctype ~= -1) or cells[y][x-1].ctype == -1 then
    calcMovement.x = calcMovement.x - 1
    neighborCount = neighborCount + 1
  end
  if (cells[y][x-1].ctype ~= 0 and cells[y][x-1].ctype ~= -1) or cells[y][x+1].ctype == -1 then
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

  local backup = CopyTable(movement)

  for i=1,3 do
    if cells[y+movement.y][x+movement.x].ctype == 0 or cells[y+movement.y][x+movement.x].ctype == -1 then
      local replicating = false
      if cells[y+movement.y][x+movement.x].ctype == -1 and cells[y][x].karl_age < 20 then
        cells[y+movement.y][x+movement.x].ctype = 0
        replicating = true
      end
      local karl = CopyTable(cells[y][x])
      if not replicating then
        cells[y][x].ctype = 0
        cells[y][x].karl_age = nil
        cells[y][x].testvar = ""
      else
        if love.math.random(1, 100) <= goodKarlMutationChance then
          cells[y][x].ctype = healKarlID
        end
        if love.math.random(1, 100) <= evilKarlMutationChance then
          cells[y][x].ctype = meanKarlID
        end
      end
      if cells[y][x].ctype == 0 then cells[y][x].movement = nil end
      cells[y+movement.y][x+movement.x] = CopyTable(karl)
      SetChunk(x+movement.x, y+movement.y, karl.ctype)
      return
    elseif i == 1 then
      movement.x = 0
      movement.y = backup.y
    elseif i == 2 then
      movement.x = backup.x
      movement.y = 0
    end
  end
end

function FeedKarl(x, y, amount)
end

function AddLife()
  karlID = addCell("BM life karl", "bmod/karl.png", function() return true end, "trash")
  meanKarlID = addCell("BM life karl-mean", "bmod/karl-mean.png", function() return true end, "trash", true)
  healKarlID = addCell("BM life karl-heal", "bmod/karl-heal.png", function() return true end, "trash")
end
