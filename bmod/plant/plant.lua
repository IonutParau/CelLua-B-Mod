plantID, soilID, dead_soilID, waterID = 0, 0, 0, 0

function AddPlant()
  -- Cells stuffs
  local pushability = function() return true end

  plantID = addCell("BM plant", "bmod/plant/plant.png",{move = pushability})
  soilID = addCell("BM soil", "bmod/plant/soil.png",{move = pushability})
  dead_soilID = addCell("BM dead-soil", "bmod/plant/dead_soil.png",{move = pushability})
  waterID = addCell("BM water", "bmod/plant/water.png",{move = pushability})
end

function Hidrate(x, y)
  if cells[y+1][x].ctype == dead_soilID then
    cells[y+1][x].ctype = soilID
  end
  if cells[y-1][x].ctype == dead_soilID then
    cells[y-1][x].ctype = soilID
  end
  if cells[y][x+1].ctype == dead_soilID then
    cells[y][x+1].ctype = soilID
  end
  if cells[y][x-1].ctype == dead_soilID then
    cells[y][x-1].ctype = soilID
  end
end

function SpreadPlant(x, y)
  if not IsHidrated(x, y) then return end

  if cells[y+1][x].ctype == soilID then
    cells[y+1][x].ctype = plantID
  end
  if cells[y-1][x].ctype == soilID then
    cells[y-1][x].ctype = plantID
  end
  if cells[y][x+1].ctype == soilID then
    cells[y][x+1].ctype = plantID
  end
  if cells[y][x-1].ctype == soilID then
    cells[y][x-1].ctype = plantID
  end
end

function IsHidrated(x, y)
  if cells[y+1][x].ctype == waterID then
    return true
  end
  if cells[y-1][x].ctype == waterID then
    return true
  end
  if cells[y][x+1].ctype == waterID then
    return true
  end
  if cells[y][x-1].ctype == waterID then
    return true
  end

  return false
end

function DoPlant(x, y)
  local lifespan = (cells[y][x].plant_lifespan) or 0
  cells[y][x].plant_lifespan = lifespan + 1
  if lifespan >= 15 then
    if not IsHidrated(x, y) then
      cells[y][x].ctype = dead_soilID
      cells[y][x].plant_lifespan = nil
    end
    SpreadPlant(x, y)
  end
end