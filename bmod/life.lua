-- Code by UndefinedMonitor

function clamp(n, min, max)
  return math.min(math.max(n, min), max)
end

-- Karl mutations
local evilKarlMutationChance = 2
local goodKarlMutationChance = 3
local karlbonMutationChance = 1
local karlpulsorMutationChance = 1
local thunderKarlMutationChance = 2

-- Karlbon mutations
local karlbon8MutationChance = 2
local iceKarlMutationChance = 5

-- Good Karl mutations
local farmerKarlMutationChance = 5

-- Mean Karl mutations
local killerKarlMutationChance = 2

local karl_mean_fail = 50

-- Karl itself
karlID = 0

-- Karl easter eggs
randomizerKarlID = 0
crashKarlID = 0

-- Karl mutations
meanKarlID = 0
healKarlID = 0
karlbonID = 0
karlpulsorID = 0

thunderKarlID = 0

-- Karlbon Mutations
karlbon8ID = 0
iceKarlID = 0

-- Good Karl Mutations
farmerKarlID = 0

-- Mean Karl Mutations
killerKarlID = 0

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

  --cells[y][x].testvar = "Karl"

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
        -- Reproduction tiem
        DoKarlReproduction(x, y)
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

function DoElectricKarl(x, y)
  local potentialEnergy = (cells[y][x].karl_energy) or 0

  cells[y][x].testvar = potentialEnergy

  if potentialEnergy == 0 then
    local gatheredEnergy = 0
    if type(cells[y+1][x].elec) == "number" then
      gatheredEnergy = gatheredEnergy + cells[y+1][x].elec
      cells[y+1][x].elec = nil
    end
    if type(cells[y-1][x].elec) == "number" then
      gatheredEnergy = gatheredEnergy + cells[y-1][x].elec
      cells[y-1][x].elec = nil
    end
    if type(cells[y][x+1].elec) == "number" then
      gatheredEnergy = gatheredEnergy + cells[y][x+1].elec
      cells[y][x+1].elec = nil
    end
    if type(cells[y][x-1].elec) == "number" then
      gatheredEnergy = gatheredEnergy + cells[y][x-1].elec
      cells[y][x-1].elec = nil
    end
    cells[y][x].karl_energy = gatheredEnergy

    if gatheredEnergy >= 50 then
      for cx=x-2,x+2 do
        for cy=y-2,y+2 do
          cells[cy][cx] = {
            ctype = 0,
            rot = 0,
            testvar="Kaboom",
            lastvars = cells[cy][cx].lastvars,
          }
        end
      end
    end
  elseif potentialEnergy > 0 then
    local canSpread = false
    
    if cells[y+1][x].ctype == elecoffID then canSpread = true end
    if cells[y-1][x].ctype == elecoffID then canSpread = true end
    if cells[y][x+1].ctype == elecoffID then canSpread = true end
    if cells[y][x-1].ctype == elecoffID then canSpread = true end
    
    if canSpread then
      cells[y][x].elec = potentialEnergy
      SpreadElec(y, x)
      cells[y][x].elec = nil
      cells[y][x].karl_energy = 0
    end
  end
  DoKarl(x, y)
end

function isKarl(id)
  local label = getCellLabelById(id)

  local signature = "BM life karl"

  if string.sub(label, 1, string.len(signature)) == signature then
    return true
  end
  return false
end

function DoKarlReproduction(x, y)
  -- Karl mutations
  if cells[y][x].ctype == karlID then
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
    if love.math.random(1, 100) <= thunderKarlMutationChance then
      cells[y][x].ctype = thunderKarlID
    end
  end

  -- Karlbon mutations
  if cells[y][x].ctype == karlbonID then
    if love.math.random(1, 100) <= iceKarlMutationChance then
      cells[y][x].ctype = iceKarlID
    end
  end

  -- Mean Karl mutations
  if cells[y][x].ctype == meanKarlID then
    if love.math.random(1, 100) <= killerKarlMutationChance then
      cells[y][x].ctype = killerKarlID
    end
  end

  -- Good Karl mutations
  if cells[y][x].ctype == healKarlID then
    if love.math.random(1, 100) <= farmerKarlMutationChance then
      cells[y][x].ctype = farmerKarlID
    end
  end
end

function DoIceKarl(x, y)
  local freezes = {
    {
      x = 1,
      y = 0,
    },
    {
      x = -1,
      y = 0,
    },
    {
      x = 0,
      y = 1,
    },
    {
      x = 0,
      y = -1,
    },
  }

  for _, freeze in pairs(freezes) do
    local fx = x + freeze.x
    local fy = y + freeze.y
    local fid = cells[fy][fx].ctype

    if isKarl(fid) and fid ~= iceKarlID then
      cells[fy][fx].movement = nil
      cells[fy][fx].updated = true
    end
  end
  
  DoKarlbon(x, y)
end

function Vec(x, y)
  return {x = x, y = y}
end

function DoKillerKarl(x, y)
  local offs = {
    Vec(1, 0),
    Vec(-1, 0),
    Vec(0, 1),
    Vec(0, -1),
  }

  for _, off in ipairs(offs) do
    local kx, ky = x + off.x, y + off.y
    local kid = cells[ky][kx].ctype
    if isKarl(kid) and kid ~= killerKarlID and kid ~= meanKarlID then
      cells[ky][kx].ctype = 0
    end
  end
  
  DoKarl(x, y)
end

function DoFarmerKarl(x, y)
  local offs = {
    Vec(1, 0),
    Vec(-1, 0),
    Vec(0, 1),
    Vec(0, -1),
  }

  for _, off in ipairs(offs) do
    local px, py = x + off.x, y + off.y
    local pid = cells[py][px].ctype
    if pid == soilID then
      cells[py][px].ctype = plantID
    end
  end
  
  DoHealKarl(x, y)
end

function DoKarlbon8(x, y)
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
    },
    Vec(2, 2),
    Vec(-2, 2),
    Vec(2, -2),
    Vec(-2, -2),
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

function FeedKarl(x, y, amount)
end

function AddLife()
  local showKarls = (config['bmod_show_karls'] ~= 'true')

  local karlPushability = (function() return true end)

  iceKarlID = addCell("BM life karl-ice", "bmod/karls/karl-ice.png",{move = karlPushability, type = "trash", invisible = showKarls})
  killerKarlID = addCell("BM life karl-killer", "bmod/karls/karl-killer.png",{move = karlPushability, type = "trash", invisible = showKarls})
  karlbonID = addCell("BM life karl-bon", "bmod/karls/karl-bon.png",{move = karlPushability, type = "trash", invisible = showKarls})
  karlbon8ID = addCell("BM life karl-bon8", "bmod/karls/karl-bon8.png",{move = karlPushability, type = "trash", invisible = showKarls})
  karlpulsorID = addCell("BM life karl-pulsor", "bmod/karls/karl-pulsor.png",{move = karlPushability, type = "trash", invisible = showKarls})
  healKarlID = addCell("BM life karl-heal", "bmod/karls/karl-heal.png",{move = karlPushability, type = "trash", invisible = showKarls})
  meanKarlID = addCell("BM life karl-mean", "bmod/karls/karl-mean.png",{move = karlPushability, type = "trash", invisible = showKarls})
  thunderKarlID = addCell("BM life karl-thunder", "bmod/karls/karl-thunder.png",{move = karlPushability, type = "trash", invisible = showKarls})
  farmerKarlID = addCell("BM life karl-farmer", "bmod/karls/karl-farmer.png",{move = karlPushability, type = "trash", invisible = showKarls})
  karlID = addCell("BM life karl", "bmod/karls/karl.png",{move = karlPushability, type = "trash"})

  BMod.bindUpdate(thunderKarlID, DoElectricKarl)
  BMod.bindUpdate(iceKarlID, DoIceKarl)
  BMod.bindUpdate(killerKarlID, DoKillerKarl)
  BMod.bindUpdate(farmerKarlID, DoFarmerKarl)
  BMod.bindUpdate(karlbon8ID, DoKarlbon8)

  ToggleFreezability(karlID)
  ToggleFreezability(karlbonID)
  ToggleFreezability(karlpulsorID)
  ToggleFreezability(healKarlID)
  ToggleFreezability(meanKarlID)
  ToggleFreezability(thunderKarlID)
  ToggleFreezability(iceKarlID)

  if EdTweaks then
    -- Add editor tweaks support
    local LifeCategory = EdTweaks:AddCategory("Life", "Tiles that use simple rules to exist and might even self-replicate (Karls only)", true, "bmod/karl")

    -- Add items
    LifeCategory:AddItem("BM life karl", "This tile has basic intelligence. It is also kimosynthetic, meaning it eats walls, and when it eats it also replicates."):SetAlias("Karl")
    LifeCategory:AddItem("BM life karl-mean", "This Karl can appear when a Karl replicates as a mutation. It hosts a virus that can spread."):SetAlias("Virus Karl")
    LifeCategory:AddItem("BM life karl-heal", "This Karl can appear when a Karl replicates as a mutation. It disinfects all karls with a virus from a virus karl."):SetAlias("Medic Karl")
    LifeCategory:AddItem("BM life karl-bon", "This Karl can appear when a Karl replicates as a mutation. It is the only Karl with the unique ability to make a 4-way bond."):SetAlias("Karlbon")
    LifeCategory:AddItem("BM life karl-pulsor", "This Karl can appear when a Karl replicates as a mutation. It is the opposite of the Karlbon."):SetAlias("Karlpulsor")

    if showKarls then
      
    end

    -- Add plant (less important then Karls tho)
    LifeCategory:AddItem("BM plant", "This tile is cool plant. Can only be placed on soil tile."):SetAlias("Plant")
    LifeCategory:AddItem("BM soil", "This tile is soil."):SetAlias("Soil")
    LifeCategory:AddItem("BM dead-soil", "This tile is bad soil."):SetAlias("Bad Soil")
    LifeCategory:AddItem("BM water", "This tile makes bad soil good again. Also allows plant to reproduce."):SetAlias("Water")
  end
end
