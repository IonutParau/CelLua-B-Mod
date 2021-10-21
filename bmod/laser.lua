local weakLaserID, stronkLaserID, stronkerLaserID

function AddLasers()
  weakLaserID = addCell("BM weak-laser", "bmod/laser.png",{type = "mover"})
  stronkLaserID = addCell("BM stronk-laser", "bmod/laser2.png",{type = "mover"})
  stronkerLaserID = addCell("BM stronker-laser", "bmod/laser3.png",{type = "mover"})
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