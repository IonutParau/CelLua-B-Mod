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
    if not PushCell(x,y,dir,false,1,id,dir,true,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(dir)},false,false) then return end
  end
end