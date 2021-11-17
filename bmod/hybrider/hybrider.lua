function getOffFromDir(d)
  local ox, oy = 0, 0
  if d == 0 then ox = 1 elseif d == 2 then ox = -1 end
  if d == 1 then oy = 1 elseif d == 3 then oy = -1 end

  return ox, oy
end

hybriderID = 0

local kylefood = 2

Hybrids = {
  kyle = 0,
  kar = 0,
  brian = 0,
  brai = 0,
  brar = 0,
  ai_cai = 0,
}

function AddHybrids()
  local showHybrids = (config['bmod_show_hybrids'] == 'true')
  BMod.bindUpdate(hybriderID, GetHybrid)

  local hybridsOptions = {invisible = (not showHybrids)}

  Hybrids.kyle = addCell("BM hybrid kyle", "bmod/hybrider/hybrids/Kyle.png", hybridsOptions)
  Hybrids.kar = addCell("BM hybrid kar", "bmod/hybrider/hybrids/Kar.png", hybridsOptions)

  local briantexture = "bmod/hybrider/hybrids/Brian2.png"
  local braitexture = "bmod/hybrider/hybrids/Brai1.png"
  local brartexture = "bmod/hybrider/hybrids/Brar1.png"

  if config['bmod_other_brain_texture'] == 'true' then
    briantexture = "bmod/hybrider/hybrids/Brian1.png"
    braitexture = "bmod/hybrider/hybrids/Brai2.png"
    brartexture = "bmod/hybrider/hybrids/Brar2.png"
  end

  Hybrids.brian = addCell("BM hybrid brian", briantexture, hybridsOptions)
  Hybrids.brai = addCell("BM hybrid brai", braitexture, hybridsOptions)
  Hybrids.brar = addCell("BM hybrid brar", brartexture, hybridsOptions)
  Hybrids.ai_cai = addCell("BM hybrid aiCAI", "bmod/hybrider/hybrids/AI_cai.png", {type = "mover", invisible = (not showHybrids)})

  -- Do bindings
  BMod.bindUpdate(Hybrids.kyle, DoKyle)
  BMod.bindUpdate(Hybrids.ai_cai, DoAICai)
  BMod.bindUpdate(Hybrids.kar, DoKar)
  BMod.bindUpdate(Hybrids.brian, DoBrian)
  BMod.bindUpdate(Hybrids.brai, DoBrai)
  BMod.bindUpdate(Hybrids.brar, DoBrar)

  if EdTweaks and showHybrids then
    local HybridCategory = EdTweaks:AddCategory("Hybrids", "These tiles are combinations of other life tiles.", true, string.sub(briantexture, 1, string.len(briantexture)-4))

    HybridCategory:AddItem("BM hybrid kyle", "Karl + KAI. It moves like a Karl, but is water proof and is a parasite to brains."):SetAlias("Kyle")
    HybridCategory:AddItem("BM hybrid kar", "Karl + AI car. Moves like a Karl, but also kills Killer Karls like a freakin' ninja."):SetAlias("Kar")
    HybridCategory:AddItem("BM hybrid brian", "Karl + Brain. It is like a brain, but it keeps moving in that direction if it has no inputs to give."):SetAlias("Brian")
    HybridCategory:AddItem("BM hybrid brai", "KAI + Brain. Its inputs are what a kai would see, and the neural network decides how much to rotate by."):SetAlias("Brai")
    HybridCategory:AddItem("BM hybrid brar", "AI Car + Brain. It is like a brai but can't self replicate. :("):SetAlias("Brar")
    HybridCategory:AddItem("BM hybrid aiCAI", "AI Car + KAI. It has the intelligence of an AI car, and can reproduce like a kai."):SetAlias("AI cai")
  end

  if Toolbar and showHybrids then
    local HybridCategory = Toolbar:AddCategory("Hybrids", "These tiles are combination of other life tiles", briantexture)

    HybridCategory:AddItem("Kyle", "Karl + KAI. It moves like a Karl, but is water proof and is a parasite to brains.", "BM hybrid kyle")
    HybridCategory:AddItem("Kar", "Karl + AI car. Moves like a Karl, but also kills Killer Karls like a freakin' ninja.", "BM hybrid kar")
    HybridCategory:AddItem("Brian", "Karl + Brain. It is like a brain, but it keeps moving in that direction if it has no inputs to give.", "BM hybrid brian")
    HybridCategory:AddItem("Brai", "KAI + Brain. Its inputs are what a kai would see, and the neural network decides how much to rotate by.", "BM hybrid brai")
    HybridCategory:AddItem("Brar", "AI Car + Brain. It is like a brai but can't self replicate. :(", "BM hybrid brar")
    HybridCategory:AddItem("AI cai", "AI Car + KAI. It has the intelligence of an AI car, and can reproduce like a kai.", "BM hybrid aiCAI")
  end
end

function GetHybrid(x, y, dir)
  local rx, ry = getOffFromDir((dir-1)%4)
  local lx, ly = getOffFromDir((dir+1)%4)

  rx = x + rx
  ry = y + ry
  lx = x + lx
  ly = y + ly

  local combination = {}

  combination[cells[ry][rx].ctype] = true
  combination[cells[ly][lx].ctype] = true

  for k, v in pairs(combination) do
    if isKarl(k) then combination[karlID] = v end
    if IsKAI(k) then combination[kaiID] = v end
  end

  function hasCombination(c1, c2)
    return ((combination[c1] ~= nil) and (combination[c2] ~= nil))
  end

  -- Calculating hybrid time
  local hybrid = 0

  if hasCombination(karlID, BModAIID) then
    hybrid = Hybrids.kar
  elseif hasCombination(karlID, kaiID) then
    hybrid = Hybrids.kyle
  elseif hasCombination(BModAIID, kaiID) then
    hybrid = Hybrids.ai_cai
  elseif hasCombination(brainID, karlID) then
    hybrid = Hybrids.brian
  elseif hasCombination(brainID, kaiID) then
    hybrid = Hybrids.brai
  elseif hasCombination(brainID, BModAIID) then
    hybrid = Hybrids.brar
  end

  if hybrid ~= 0 then
    if PushCell(x, y, dir, nil, nil, hybrid, 0) then
      cells[ry][rx].ctype = 0
      cells[ly][lx].ctype = 0
    end
  end
end

function DoKyle(x, y)
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
  if cells[y+1][x].ctype == brainID then
    if not cells[y+1][x].kaiFOOD then cells[y+1][x].kaiFOOD = 0 end
    cells[y+1][x].kaiFOOD = cells[y+1][x].kaiFOOD + 1
    if cells[y+1][x].kaiFOOD >= kylefood then
      PushCell(x, y, 3, nil, nil, Hybrids.kyle)
      cells[y+1][x].kaiFOOD = cells[y+1][x].kaiFOOD - kylefood
    end
    return
  end
  if cells[y-1][x].ctype == brainID then
    if not cells[y-1][x].kaiFOOD then cells[y-1][x].kaiFOOD = 0 end
    cells[y-1][x].kaiFOOD = cells[y-1][x].kaiFOOD + 1
    if cells[y-1][x].kaiFOOD >= kylefood then
      PushCell(x, y, 1, nil, nil, Hybrids.kyle)
      cells[y-1][x].kaiFOOD = cells[y-1][x].kaiFOOD - kylefood
    end
    return
  end
  if cells[y][x+1].ctype == brainID then
    if not cells[y][x+1].kaiFOOD then cells[y][x+1].kaiFOOD = 0 end
    cells[y][x+1].kaiFOOD = cells[y][x+1].kaiFOOD + 1
    if cells[y][x+1].kaiFOOD >= kylefood then
      PushCell(x, y, 2, nil, nil, Hybrids.kyle)
      cells[y][x+1].kaiFOOD = cells[y][x+1].kaiFOOD - kylefood
    end
    return
  end
  if cells[y][x-1].ctype == brainID then
    if not cells[y][x-1].kaiFOOD then cells[y][x-1].kaiFOOD = 0 end
    cells[y][x-1].kaiFOOD = cells[y][x-1].kaiFOOD + 1
    if cells[y][x-1].kaiFOOD >= kylefood then
      PushCell(x, y, 0, nil, nil, Hybrids.kyle)
      cells[y][x-1].kaiFOOD = cells[y][x-1].kaiFOOD - kylefood
    end
    return
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

  local movement = cells[y][x].movement

  if movement.y < 0 then
    cells[y][x].rot = 3
  elseif movement.y > 0 then
    cells[y][x].rot = 1
  elseif movement.x > 0 then
    cells[y][x].rot = 0
  elseif movement.x < 0 then
    cells[y][x].rot = 2
  end

  if not cells[y][x].kaiFOOD then cells[y][x].kaiFOOD = 0 end
  cells[y][x].kaiFOOD = cells[y][x].kaiFOOD + 1

  -- Movement time
  DoKarlMovement(x, y)
end

function DoAICai(x, y, dir)

  local cx,cy
  if dir == 0 then cx = x + 1 elseif dir == 2 then cx = x - 1 else cx = x end
if dir == 1 then cy = y + 1 elseif dir == 3 then cy = y - 1 else cy = y end

  local ffx,ffy
  if dir == 0 then ffx = cx + 1 elseif dir == 2 then ffx = cx - 1 else ffx = cx end
if dir == 1 then ffy = cy + 1 elseif dir == 3 then ffy = cy - 1 else ffy = cy end

  local lfx,lfy
  if dir == 0 then lfy = cy - 1 elseif dir == 2 then lfy = cy + 1 else lfy = cy end
if dir == 1 then lfx = cx + 1 elseif dir == 3 then lfx = cx - 1 else lfx = cx end

  local rfx,rfy
  if dir == 0 then rfy = cy + 1 elseif dir == 2 then rfy = cy - 1 else rfy = cy end
if dir == 1 then rfx = cx - 1 elseif dir == 3 then rfx = cx + 1 else rfx = cx end

  local lx,ly
  if dir == 0 then ly = y - 1 elseif dir == 2 then ly = y + 1 else ly = y end
if dir == 1 then lx = x + 1 elseif dir == 3 then lx = x - 1 else lx = x end

  local llx,lly
  if dir == 0 then lly = ly - 1 elseif dir == 2 then lly = ly + 1 else lly = ly end
if dir == 1 then llx = lx + 1 elseif dir == 3 then llx = lx - 1 else llx = lx end

  local rx,ry
  if dir == 0 then ry = y + 1 elseif dir == 2 then ry = y - 1 else ry = y end
if dir == 1 then rx = x - 1 elseif dir == 3 then rx = x + 1 else rx = x end

  local rrx,rry
  if dir == 0 then rry = ry + 1 elseif dir == 2 then rry = ry - 1 else rry = ry end
if dir == 1 then rrx = rx - 1 elseif dir == 3 then rrx = rx + 1 else rrx = rx end

  local bx,by
  if dir == 0 then bx = x - 1 elseif dir == 2 then bx = x + 1 else bx = x end
if dir == 1 then by = y - 1 elseif dir == 3 then by = y + 1 else by = y end

  local bbx,bby
  if dir == 0 then bbx = bx - 1 elseif dir == 2 then bbx = bx + 1 else bbx = bx end
if dir == 1 then bby = by - 1 elseif dir == 3 then bby = by + 1 else bby = by end

  if InGrid(ffx,ffy) and cells[ffy][ffx].ctype == killerKarlID then
      cells[ffy][ffx].ctype = deadKarlID
      SetChunk(ffx,ffy,deadKarlID)
  end

  if InGrid(bbx,bby) and cells[bby][bbx].ctype == killerKarlID then
      cells[bby][bbx].ctype = deadKarlID
      SetChunk(bbx,bby,deadKarlID)
  end

  if InGrid(rrx,rry) and cells[rry][rrx].ctype == killerKarlID then
      cells[rry][rrx].ctype = deadKarlID
      SetChunk(rrx,rry,deadKarlID)
  end

  if InGrid(llx,lly) and cells[lly][llx].ctype == killerKarlID then
      cells[lly][llx].ctype = deadKarlID
      SetChunk(llx,lly,deadKarlID)
  end

  if cells[cy][cx].ctype == waterID then
    cells[cy][cx] = {
      ctype = 0,
      rot = 0,
      lastvars = {
        cx,
        cy,
        0,
      }
    }
    DoMover(x, y, cells[y][x].rot)
    local dir = cells[y][x].rot
    PushCell(x, y, (dir+2)%4, nil, nil, Hybrids.ai_cai, (dir+2)%4)
    return
  end

  if cells[cy][cx].ctype == spawnerID or cells[cy][cx].ctype == rotateSpawnerID then
      DoMover(x,y,cells[y][x].rot)
      cells[cy][cx].spawner_dir_off = 0
      return
  end
  if cells[ry][rx].ctype == spawnerID or cells[ry][rx].ctype == rotateSpawnerID then
      cells[y][x].rot = (cells[y][x].rot+1)%4
      DoMover(x,y,cells[y][x].rot)
      cells[ry][rx].spawner_dir_off = 0
      return
  end
  if cells[ly][lx].ctype == spawnerID or cells[ly][lx].ctype == rotateSpawnerID then
      cells[y][x].rot = (cells[y][x].rot-1)%4
      DoMover(x,y,cells[y][x].rot)
      cells[ly][lx].spawner_dir_off = 0
      return
  end

  if cells[cy][cx].ctype ~= 0 and cells[by][bx].ctype ~= 0 then
    if (cells[ly][lx].ctype == 0 and cells[ry][rx].ctype ~= 0)then
        cells[y][x].rot = (dir-1)%4
    elseif (cells[ly][lx].ctype ~= 0 and cells[ry][rx].ctype == 0) or (cells[ly][lx].ctype == 0 and cells[ry][rx].ctype == 0) then
        cells[y][x].rot = (dir+1)%4
    else
        return "no good path to go please help im going to die"
    end
  elseif (cells[rfy][rfx].ctype ~= 0 and cells[ly][lx].ctype == 0 and cells[cy][cx].ctype ~= 0 and cells[lfy][lfx].ctype == 0) or (cells[ly][lx].ctype == 0 and cells[cy][cx].ctype ~= 0 and cells[ry][rx].ctype ~= 0) then
    cells[y][x].rot = (dir-1)%4
  elseif (cells[lfy][lfx].ctype ~= 0 and cells[ry][rx].ctype == 0 and cells[cy][cx].ctype ~= 0 and cells[rfy][rfx].ctype == 0) or (cells[ry][rx].ctype == 0 and cells[cy][cx].ctype ~= 0 and cells[ly][lx].ctype ~= 0) then
    cells[y][x].rot = (dir+1)%4
  elseif cells[cy][cx].ctype ~= 0 then
    cells[y][x].rot = (dir+2)%4
  end

  DoMover(x,y,cells[y][x].rot)
end

function DoKar(x, y)
  local offs = {
    {x=0,y=2},
    {x=0,y=-2},
    {x=2,y=0},
    {x=-2,y=0},
    {x=0,y=1},
    {x=0,y=-1},
    {x=1,y=0},
    {x=-1,y=0},
  }
  for _, off in ipairs(offs) do
    local ox = x + off.x
    local oy = y + off.y

    if InGrid(ox, oy) and cells[oy][ox].ctype == killerKarlID then
      cells[oy][ox].ctype = 0
    end
  end

  DoKarl(x, y)
end

function DoBrian(x, y, dir)
  if not cells[y][x].brain_nn then GiveNeuralNetwork(x, y) end

  local inputs = {}
  local offs = {
    {x = 0, y = 1},
    {x = 0, y = -1},
    {x = 1, y = 0},
    {x = -1, y = 0},
  }
  local inputSum = 0
  for _, off in ipairs(offs) do
    local cx, cy = x + off.x, y + off.y
    local ctype = cells[cy][cx].ctype
    local input = 1
    if ctype == 0 then input = 0 end
    if ctype == plantID then input = 0.5 end

    inputSum = inputSum + input
    table.insert(inputs, input)
  end
  if inputSum > 0 then
    dir = math.floor(ExecuteNeuralNetwork(cells[y][x].brain_nn, inputs)) % 4
    ResetNLValues(cells[y][x].brain_nn)
    cells[y][x].rot = dir
  end

  cells[y][x].testvar = dir

  local cx, cy = x, y
  if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 end
  if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 end
  local fx, fy = x, y
  if dir == 0 then fx = x + 1 elseif dir == 2 then fx = x - 1 end
  if dir == 1 then fy = y + 1 elseif dir == 3 then fy = y - 1 end
  if cells[fy][fx].ctype == plantID then
    cells[fy][fx] = CopyTable(cells[y][x])
    rotateCell(x, y, 2)
    if love.math.random(1, 100) <= 1 then
      cells[fy][fx].ctype = cancerbrainID
    end
  else
    PushCell(cx, cy, dir)
  end
end

function DoBrai(x, y, dir)
  if not cells[y][x].brain_nn then GiveNeuralNetwork(x, y) end

  local inputs = {}
  local offs = {}

  local fx, fy = getOffFromDir((dir)%4)
  table.insert(offs, {fx, fy})
  local bx, by = getOffFromDir((dir+2)%4)
  table.insert(offs, {bx, by})
  local rx, ry = getOffFromDir((dir-1)%4)
  table.insert(offs, {fx + rx, fy + ry})
  local lx, ly = getOffFromDir((dir+1)%4)
  table.insert(offs, {fx + lx, fy + ly})

  for _, off in ipairs(offs) do
    local cx, cy = x + off[1], y + off[2]
    local ctype = cells[cy][cx].ctype
    local input = 1
    if ctype == 0 then input = 0 end
    if ctype == plantID then input = 0.5 end
    table.insert(inputs, input)
  end

  local rot = math.floor(ExecuteNeuralNetwork(cells[y][x].brain_nn, inputs)) % 5 - 1
  ResetNLValues(cells[y][x].brain_nn)
  dir = (dir + rot) % 4

  cells[y][x].testvar = dir

  if dir < 0 then return end

  local cx, cy = x, y
  if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 end
  if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 end
  local fx, fy = x, y
  if dir == 0 then fx = x + 1 elseif dir == 2 then fx = x - 1 end
  if dir == 1 then fy = y + 1 elseif dir == 3 then fy = y - 1 end
  if cells[fy][fx].ctype == waterID then
    cells[fy][fx] = CopyTable(cells[y][x])
    rotateCell(x, y, 2)
    if love.math.random(1, 100) <= 1 then
      cells[fy][fx].ctype = cancerbrainID
    end
  else
    PushCell(cx, cy, dir)
  end
end

function DoBrar(x, y, dir)
  if not cells[y][x].brain_nn then GiveNeuralNetwork(x, y) end

  local inputs = {}
  local offs = {}

  local fx, fy = getOffFromDir((dir)%4)
  table.insert(offs, {fx, fy})
  local bx, by = getOffFromDir((dir+2)%4)
  table.insert(offs, {bx, by})
  local rx, ry = getOffFromDir((dir-1)%4)
  table.insert(offs, {fx + rx, fy + ry})
  local lx, ly = getOffFromDir((dir+1)%4)
  table.insert(offs, {fx + lx, fy + ly})

  for _, off in ipairs(offs) do
    local cx, cy = x + off[1], y + off[2]
    local ctype = cells[cy][cx].ctype
    local input = 1
    if ctype == 0 then input = 0 end
    if ctype == plantID then input = 0.5 end
    table.insert(inputs, input)
  end

  local rot = math.floor(ExecuteNeuralNetwork(cells[y][x].brain_nn, inputs)) % 5 - 1
  ResetNLValues(cells[y][x].brain_nn)
  dir = (dir + rot) % 4

  cells[y][x].testvar = dir

  if dir < 0 then return end

  local cx, cy = x, y
  if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 end
  if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 end
  PushCell(cx, cy, dir)
end