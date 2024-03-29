-- Code by UndefinedMonitor

require("bmod.brain.script")

function IsKAI(id)
  local label = getCellLabelById(id)

  if string.sub(label, 1, string.len("BM kai")) == "BM kai" then
    return true
  end

  return false
end

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
local iceKarlMutationChance = 1

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

-- Interactions
deadKarlID = 0
reprogrammedKarlID = 0
reprogrammedMedicKarlID = 0

function DoKarlHate(x, y)
  local offs = {
    {x=0,y=1},
    {x=0,y=-1},
    {x=1,y=0},
    {x=-1,y=0},
    {x=-1,y=-1},
    {x=1,y=-1},
    {x=-1,y=1},
    {x=1,y=1},
  }

  local id = cells[y][x].ctype

  for _, off in ipairs(offs) do
    local cx, cy = x + off.x, y + off.y

    local ctype = cells[cy][cx].ctype

    if ctype == deadKarlID or (id == karlID and ctype == kaiexplorerID) or (ctype == brainID and (not cells[cy][cx].brain_isleached)) then
      cells[cy][cx].ctype = 0
      cells[y][x].karl_must_replicate = true
    end
  end
end

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
  local offs = {
    {x=1,y=0},
    {x=-1,y=0},
    {x=0,y=1},
    {x=0,y=-1},
  }
  for _, off in ipairs(offs) do
    local ox, oy = x + off.x, y + off.y
    if cells[oy][ox].ctype == meanKarlID or cells[oy][ox].ctype == killerKarlID then
      cells[oy][ox].ctype = karlID
    elseif cells[oy][ox].ctype == deadbirdID then
      cells[oy][ox].ctype = birdID
    elseif cells[oy][ox].ctype == dead_soilID then
      cells[oy][ox].ctype = soilID
    elseif cells[oy][ox].ctype == deadslowbirdID then
      cells[oy][ox].ctype = slowbirdID
    end
    SetChunk(ox, oy, cells[oy][ox].ctype)
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

  DoKarlHate(x, y)

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
    if x+movement.x == 0 or x+movement.x == width-1 then
      i = i - 1
      movement.x = -movement.x
    end
    if y+movement.y == 0 or y+movement.y == height-1 then
      i = i - 1
      movement.y = -movement.y
    end
    if cells[y+movement.y][x+movement.x].ctype == 0 or cells[y+movement.y][x+movement.x].ctype == -1 then
      local replicating = false
      if cells[y+movement.y][x+movement.x].ctype == -1 or cells[y][x].karl_must_replicate == true then
        cells[y+movement.y][x+movement.x].ctype = 0
        replicating = true
        cells[y][x].karl_must_replicate = nil
      end
      local karl = CopyTable(cells[y][x])
      if not replicating then
        cells[y][x].ctype = 0
        cells[y][x].karl_age = nil
        cells[y][x].testvar = ""
      else
        -- Reproduction tiem
        DoKarlReproduction(x, y)
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
  if cells[y][x].ctype == healKarlID or cells[y][x].ctype == reprogrammedMedicKarlID then
    if love.math.random(1, 100) <= farmerKarlMutationChance then
      cells[y][x].ctype = farmerKarlID
    end
  end

  if cells[y][x].ctype == reprogrammedKarlID then
    cells[y][x].ctype = kaiID
  end

  SetChunk(x, y, cells[y][x].ctype)
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

    if isKarl(fid) then
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
    if kx > 0 and kx < width-1 and ky > 0 and ky < height-1 then
      local kid = cells[ky][kx].ctype
      if (isKarl(kid) and kid ~= killerKarlID and kid ~= meanKarlID) or IsKAI(kid) or kid == brainID or kid == BModAIID then
        cells[ky][kx].ctype = 0
      end
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

function DoReprogrammedMedic(x, y)
  if IsKAI(cells[y+1][x].ctype) then cells[y+1][x].kaiFOOD = cells[y+1][x].kaiFOOD + 30 end
  if IsKAI(cells[y-1][x].ctype) then cells[y-1][x].kaiFOOD = cells[y-1][x].kaiFOOD + 30 end
  if IsKAI(cells[y][x+1].ctype) then cells[y][x+1].kaiFOOD = cells[y][x+1].kaiFOOD + 30 end
  if IsKAI(cells[y][x-1].ctype) then cells[y][x-1].kaiFOOD = cells[y][x-1].kaiFOOD + 30 end
  DoKarl(x, y)
end

function FeedKarl(x, y, amount)
end

function DoDeadKarl(x, y)
  if not cells[y][x].karl_dead_age then cells[y][x].karl_dead_age = 0 end
  cells[y][x].karl_dead_age = cells[y][x].karl_dead_age + 1

  if cells[y][x].karl_dead_age == 10 then
    cells[y][x].karl_dead_age = nil
    cells[y][x].ctype = -1
  end
end

function AddLife()
  local brainTexture = "bmod/brain/texture.png"
  local cancerbrainTexture = "bmod/brain/cancer.png"
  if config['bmod_other_brain_texture'] == 'true' then brainTexture = "bmod/brain/shittier.png" end
  if config['bmod_other_brain_texture'] == 'true' then cancerbrainTexture = "bmod/brain/shittiercancer.png" end
  brainID = addCell("BM life brain", brainTexture)
  cancerbrainID = addCell("BM life cancer brain", cancerbrainTexture)

  BMod.bindUpdate(cancerbrainID, DoBrainCancer)

  local showKarls = (config['bmod_show_karls'] ~= 'true')

  local karlOptions = Options.combine({type = Options.trash}, {invisible = showKarls})

  local reprogrammedOptions = {invisible = true}
  reprogrammedKarlID = addCell("BM life karl remade", "bmod/karls/karl-remade.png", reprogrammedOptions)
  reprogrammedMedicKarlID = addCell("BM life karl-heal remade", "bmod/karls/medic-remade.png", reprogrammedOptions)

  deadKarlID = addCell("BM life karl-dead", "bmod/karls/karl-dead.png", Options.invisible)
  iceKarlID = addCell("BM life karl-ice", "bmod/karls/karl-ice.png",{push = karlPushability, invisible = showKarls})
  killerKarlID = addCell("BM life karl-killer", "bmod/karls/karl-killer.png",{push = karlPushability, invisible = showKarls})
  karlbonID = addCell("BM life karl-bon", "bmod/karls/karl-bon.png",{push = karlPushability, invisible = showKarls})
  karlbon8ID = addCell("BM life karl-bon8", "bmod/karls/karl-bon8.png",{push = karlPushability, invisible = showKarls})
  karlpulsorID = addCell("BM life karl-pulsor", "bmod/karls/karl-pulsor.png",{push = karlPushability, invisible = showKarls})
  healKarlID = addCell("BM life karl-heal", "bmod/karls/karl-heal.png",{push = karlPushability, invisible = showKarls})
  meanKarlID = addCell("BM life karl-mean", "bmod/karls/karl-mean.png",{push = karlPushability, invisible = showKarls})
  thunderKarlID = addCell("BM life karl-thunder", "bmod/karls/karl-thunder.png",{push = karlPushability, invisible = showKarls})
  farmerKarlID = addCell("BM life karl-farmer", "bmod/karls/karl-farmer.png",{push = karlPushability, invisible = showKarls})
  karlID = addCell("BM life karl", "bmod/karls/karl.png",{push = karlPushability})

  BMod.bindUpdate(thunderKarlID, DoElectricKarl)
  BMod.bindUpdate(iceKarlID, DoIceKarl)
  BMod.bindUpdate(killerKarlID, DoKillerKarl)
  BMod.bindUpdate(farmerKarlID, DoFarmerKarl)
  BMod.bindUpdate(karlbon8ID, DoKarlbon8)

  BMod.bindUpdate(deadKarlID, DoDeadKarl)

  -- Reprogrammed
  BMod.bindUpdate(reprogrammedKarlID, DoKarl)

  -- Freezability
  ToggleFreezability(karlID)
  ToggleFreezability(karlbonID)
  ToggleFreezability(karlpulsorID)
  ToggleFreezability(healKarlID)
  ToggleFreezability(meanKarlID)
  ToggleFreezability(thunderKarlID)
  ToggleFreezability(iceKarlID)
  ToggleFreezability(reprogrammedMedicKarlID)
  ToggleFreezability(reprogrammedKarlID)

  local hybridName = "???"
  local hybridDesc = "[UNIDENTIFIED, PLEASE FIND OUT MANUALLY]"

  if config['bmod_show_hybrids'] == 'true' then hybridName = "Hybrid Maker" end
  if config['bmod_show_hybrids'] == 'true' then hybridDesc = "Can combine two living tiles into one hybrid" end

  if EdTweaks then
    -- Add editor tweaks support
    local LifeCategory = EdTweaks:AddCategory("Life", "Tiles that use rules to exist or interact with other living tiles. Some of them reproduce.", true, "bmod/karls/karl")

    -- Add items
    LifeCategory:AddItem("BM life karl", "This tile has basic intelligence. It is also chemosynthetic, meaning it eats walls, and when it eats it also replicates. They also die when they are in contact with water."):SetAlias("Karl")
    
    if not showKarls then
      LifeCategory:AddItem("BM life karl-mean", "This Karl can appear when a Karl replicates as a mutation. It hosts a virus that can spread."):SetAlias("Virus Karl")
      LifeCategory:AddItem("BM life karl-heal", "This Karl can appear when a Karl replicates as a mutation. It disinfects all karls with a virus from a virus karl."):SetAlias("Medic Karl")
      LifeCategory:AddItem("BM life karl-bon", "This Karl can appear when a Karl replicates as a mutation. It is the only Karl with the unique ability to make a 4-way bond."):SetAlias("Karlbon")
      LifeCategory:AddItem("BM life karl-pulsor", "This Karl can appear when a Karl replicates as a mutation. It is the opposite of the Karlbon."):SetAlias("Karlpulsor")
      LifeCategory:AddItem("BM life karl-farmer", "This Karl will grow plants on hydrated soil."):SetAlias("Farmer Karl")
      LifeCategory:AddItem("BM life karl-bon8", "This Karl is like Karlbon, except it makes 8-way bonds."):SetAlias("Karlbon8")
      LifeCategory:AddItem("BM life karl-ice", "This Karl is a Karlbon with bonds so strong no other Karl can escape without help."):SetAlias("Ice Karl")
      LifeCategory:AddItem("BM life karl-killer", "This Karl will kill other Karls and other life forms."):SetAlias("Killer Karl")
    end

    LifeCategory:AddItem("BM hybrider", hybridDesc):SetAlias(hybridName)
    
    -- Add brain (less importatn the Karls tho)
    LifeCategory:AddItem("BM life brain", "This cell has a simple randomly generated neural network inside of it (Can cause lag.)."):SetAlias("Brain")
    LifeCategory:AddItem("BM life cancer brain", "This cell takes over any brain cells next to it."):SetAlias("Cancerous Brain")
    
    -- Add plant (less important then Brains tho, because yes)
    LifeCategory:AddItem("BM plant", "This tile is cool plant. Can only be placed on soil tile. It will die after a while unless it is hydrated, and if it is hydrated instead of dying it replicates on other good soil. When it dies it turns into bad soil."):SetAlias("Plant")
    LifeCategory:AddItem("BM soil", "This tile is soil."):SetAlias("Soil")
    LifeCategory:AddItem("BM dead-soil", "This tile is bad soil."):SetAlias("Bad Soil")
    LifeCategory:AddItem("BM water", "This tile makes bad soil good again. Also allows plant to reproduce. It hydrates when it is placed and every tick, and that hydration also kills Karls. It is also food for KAIs."):SetAlias("Water")
  end

  if Toolbar then
    local lifeCat = Toolbar:AddCategory("Life", "Tiles that use rules to exist or interact with other living tiles. Some of them reproduce.", "bmod/karls/karl.png")

    local karlCat

    if showKarls then
      karlCat = lifeCat
    else
      karlCat = lifeCat:AddCategory("Karls", "All the types of karls", "bmod/karls/karl.png")
    end

    karlCat:AddItem("Karl", "This tile has basic intelligence. It is also chemosynthetic, meaning it eats walls, and when it eats it also replicates. They also die when they are in contact with water.", "BM life karl")
  
    if not showKarls then
      karlCat:AddItem("Virus Karl", "This Karl can appear when a Karl replicates as a mutation. It hosts a virus that can spread.", "BM life karl-mean")
      karlCat:AddItem("Medic Karl", "This Karl can appear when a Karl replicates as a mutation. It disinfects all karls with a virus from a virus karl.", "BM life karl-heal")
      karlCat:AddItem("Karlbon", "This Karl can appear when a Karl replicates as a mutation. It is the only Karl with the unique ability to make a 4-way bond.", "BM life karl-bon")
      karlCat:AddItem("Karlpulsor", "This Karl can appear when a Karl replicates as a mutation. It is the opposite of the Karlbon.", "BM life karl-pulsor")
      karlCat:AddItem("Farmer Karl", "This Karl will grow plants on hydrated soil.", "BM life karl-farmer")
      karlCat:AddItem("Karlbon-8", "This Karl is like Karlbon, except it makes 8-way bonds.", "BM life karl-bon8")
      karlCat:AddItem("Ice Karl", "This Karl is a Karlbon with bonds so strong no other Karl can escape without help.", "BM life karl-ice")
      karlCat:AddItem("Killer Karl", "This Karl will kill other Karls and other life forms.", "BM life karl-killer")
    end

    lifeCat:AddItem(hybridName, hybridDesc, hybriderID)
    lifeCat:AddItem("Brain", "This cell has a simple randomly generated neural network inside of it (Can cause lag.).", "BM life brain")
    lifeCat:AddItem("Cancerous Brain", "This cell takes over any brain cells next to it.", "BM life cancer brain")

    lifeCat:AddItem("Plant", "This tile is cool plant. Can only be placed on soil tile. It will die after a while unless it is hydrated, and if it is hydrated instead of dying it replicates on other good soil. When it dies it turns into bad soil.", "BM plant")
    lifeCat:AddItem("Soil", "This tile is soil.", "BM soil")
    lifeCat:AddItem("Bad Soil", "This tile is bad soil.", "BM dead-soil")
    lifeCat:AddItem("Water", "This tile makes bad soil good again. Also allows plant to reproduce. It hydrates when it is placed and every tick, and that hydration also kills Karls. It is also food for KAIs.", "BM water")
  end
end
