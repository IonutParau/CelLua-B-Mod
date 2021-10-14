-- Code by UndefinedMonitor

function clamp(n, min, max)
  return math.min(math.max(n, min), max)
end

local evilKarlMutationChance = 2
local goodKarlMutationChance = 3
local karlbonMutationChance = 1
local karlpulsorMutationChance = 1
local karl_mean_fail = 50

meanKarlID = 0
karlID = 0
healKarlID = 0
karlbonID = 0
karlpulsorID = 0

function offgrid(x, y)
  return (x < 0 or x > width-1) or (y < 0 or y > height-1)
end

function applyKarlForce(x, y, force)
  local movement = cells[y][x].movement or {x = 0, y = 0}
  movement.x = clamp(movement.x + force.x, -1, 1)
  movement.y = clamp(movement.y + force.y, -1, 1)
  cells[y][x].movement = movement
end

-- Karl but transports kinetic energy
function DoKarlpulsor(x, y)
  local forces = {
    {
      x = 1,
      y = 0
    },
    {
      x = -1,
      y = 0
    },
    {
      x = 0,
      y = 1
    },
    {
      x = 0,
      y = -1
    }
  }
  for _, force in ipairs(forces) do
    local pos = {x = (x + force.x), y = (y + force.y)}
    if not offgrid(pos.x, pos.y) then
      local label = getCellLabelById(cells[pos.y][pos.x].ctype) -- Using label to make it work on all karls automatically
      if string.sub(label, 0, string.len("BM life karl")) == "BM life karl" then
        applyKarlForce(pos.x, pos.y, force)
      end
    end
  end
  
  DoKarl(x, y)
end

-- Karl-bon is gonna allow for more complex karloids.
-- A karloid is a structure made of karls.
function DoKarlbon(x, y)
  local forces = {
    {
      x = 2,
      y = 0
    },
    {
      x = -2,
      y = 0
    },
    {
      x = 0,
      y = 2
    },
    {
      x = 0,
      y = -2
    }
  }
  for _, force in ipairs(forces) do
    local pos = {x = (x - force.x), y = (y - force.y)}
    if not offgrid(pos.x, pos.y) then
      local label = getCellLabelById(cells[pos.y][pos.x].ctype) -- Using label to make it work on all karls automatically
      if string.sub(label, 0, string.len("BM life karl")) == "BM life karl" then
        applyKarlForce(pos.x, pos.y, force)
      end
    end
  end
  
  DoKarl(x, y)
end

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

  DoKarlMovement(x, y)
end

function DoKarlMovement(x, y)
  local movement = cells[y][x].movement or {x = 0, y = 0}

  if y+movement.y < 0 or x+movement.x < 0 or movement.x + x > width-1 or movement.y + y > height-1 then
    return
  end

  local backup = CopyTable(movement)

  for i=1,3 do
    if cells[y+movement.y][x+movement.x].ctype == 0 or cells[y+movement.y][x+movement.x].ctype == -1 then
      local replicating = false
      if cells[y+movement.y][x+movement.x].ctype == -1 then
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
        if love.math.random(1, 100) <= karlbonMutationChance then
          cells[y][x].ctype = karlbonID
        end
        if love.math.random(1, 100) <= karlpulsorMutationChance then
          cells[y][x].ctype = karlpulsorID
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
  meanKarlID = addCell("BM life karl-mean", "bmod/karl-mean.png", function() return true end, "trash")
  healKarlID = addCell("BM life karl-heal", "bmod/karl-heal.png", function() return true end, "trash")
  karlbonID = addCell("BM life karl-bon", "bmod/karl-bon.png", function() return true end, "trash")
  karlpulsorID = addCell("BM life karl-pulsor", "bmod/karl-pulsor.png", function() return true end, "trash")

  if EdTweaks then
    -- Add editor tweaks support
    local LifeCategory = EdTweaks:AddCategory("Life", "Tiles that use simple rules to exist and might even self-replicate (Karls only)", true, "bmod/karl")

    -- Add items
    LifeCategory:AddItem("BM life karl", "This tile has basic intelligence. It is also kimosynthetic, meaning it eats walls, and when it eats it also replicates."):SetAlias("Karl")
    LifeCategory:AddItem("BM life karl-mean", "This Karl can appear when a Karl replicates as a mutation. It hosts a virus that can spread."):SetAlias("Virus Karl")
    LifeCategory:AddItem("BM life karl-heal", "This Karl can appear when a Karl replicates as a mutation. It disinfects all karls with a virus from a virus karl."):SetAlias("Medic Karl")
    LifeCategory:AddItem("BM life karl-bon", "This Karl can appear when a Karl replicates as a mutation. It is the only Karl with the unique ability to make a 4-way bond."):SetAlias("Karlbon")
    LifeCategory:AddItem("BM life karl-pulsor", "This Karl can appear when a Karl replicates as a mutation. It is the opposite of the Karlbon."):SetAlias("Karlpulsor")
  end
end
