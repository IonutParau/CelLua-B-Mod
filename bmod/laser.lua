local weakLaserID, stronkLaserID, stronkerLaserID

function AddLasers()
  weakLaserID = addCell("BM weak-laser", "textures/generator.png", function() return true end, "mover")
  stronkLaserID = addCell("BM stronk-laser", "textures/generator.png", function() return true end, "mover")
  stronkerLaserID = addCell("BM stronker-laser", "textures/generator.png", function() return true end, "mover")
end

function UpdateLasers(id, x, y, dir)
  local power = nil
  
  if id == weakLaserID then
    power = 1
  elseif id == stronkLaserID then
    power = 2
  elseif id == stronkerLaserID then
    power = 4
  end

  if power ~= nil then
    DoLaser(id, x, y, dir, power)
  end
end

function DoLaser(id, x, y, dir, powaaaah)
  for i=1,powaaaah do
    local lastvars = CopyTable(cells[y][x].lastvars)
    if dir == 0 then x = x - 1 elseif dir == 2 then x = x + 1 end
    if dir == 1 then y = y - 1 elseif dir == 3 then y = y + 1 end

    if not PushCell(x, y, dir, true, 0, id, dir, true, lastvars) then return end

    if dir == 0 then x = x + 2 elseif dir == 2 then x = x - 2 end
    if dir == 1 then y = y + 2 elseif dir == 3 then y = y - 2 end
  end
end