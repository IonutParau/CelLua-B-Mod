-- Heater cell

local function UpdateCell(id, x, y, dir)
  if id == 1 then
    DoMover(x, y, dir)
  elseif id == 2 or id == 39 or id == 22 then
    DoGenerator(x,y,dir,dir,id == 39)
    if id == 22 then
      dir = (dir-1)%4
      DoGenerator(x,y,dir,dir,false)
    end
  elseif id == 25 then
    DoGenerator(x, y, (dir-1)%4, dir)
  elseif id == 26 then
    DoGenerator(x, y, (dir+1)%4, dir)
  elseif id == 44 or id == 45 then
    DoReplicator(x,y,dir,id ~= 45)
    if id == 45 then
      dir = (dir-1)%4
      DoReplicator(x,y,dir,false)
    end
  elseif id == 29 then
    for i=-1,1,2 do	--when lazy
      if cells[y][x+i].ctype == 8 then cells[y][x+i].ctype = 9 
      elseif cells[y][x+i].ctype == 9 then cells[y][x+i].ctype = 8 
      elseif cells[y][x+i].ctype == 17 then cells[y][x+i].ctype = 18
      elseif cells[y][x+i].ctype == 18 then cells[y][x+i].ctype = 17 
      elseif cells[y][x+i].ctype == 25 then cells[y][x+i].ctype = 26 cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4
      elseif cells[y][x+i].ctype == 26 then cells[y][x+i].ctype = 25 cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4
      elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
      elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
      elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
      elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 1 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
      elseif hasFlipperTranslation(cells[y][x+i].ctype) then cells[y][x+i].ctype = makeFlipperTranslation(cells[y][x+i].ctype) SetChunk(x+i, y, cells[y][x+i].ctype)
      else cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4 end
    end
    for i=-1,1,2 do
      if cells[y+i][x].ctype == 8 then cells[y+i][x].ctype = 9 
      elseif cells[y+i][x].ctype == 9 then cells[y+i][x].ctype = 8 
      elseif cells[y+i][x].ctype == 17 then cells[y+i][x].ctype = 18
      elseif cells[y+i][x].ctype == 18 then cells[y+i][x].ctype = 17 
      elseif cells[y+i][x].ctype == 25 then cells[y+i][x].ctype = 26 cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4
      elseif cells[y+i][x].ctype == 26 then cells[y+i][x].ctype = 25 cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4
      elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
      elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
      elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
      elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
      elseif hasFlipperTranslation(cells[y+i][x].ctype) then cells[y+i][x].ctype = makeFlipperTranslation(cells[y+i][x].ctype) SetChunk(x, y+i, cells[y+i][x].ctype)
      else cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4 end
    end
  elseif id == 56 then
    if cells[y][x].rot == 0 then
      cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
      cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
      cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
      cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
    elseif cells[y][x].rot == 1 then
      cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
      cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
      cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
      cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
    elseif cells[y][x].rot == 2 then
      cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
      cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
      cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
      cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
    else
      cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
      cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
      cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
      cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
    end
  elseif id == 8 then
    cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
    cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
    cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
    cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
  elseif id == 9 then
    cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
    cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
    cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
    cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
  elseif id == 10 then
    cells[y][x-1].rot = (cells[y][x-1].rot - 2)%4
    cells[y][x+1].rot = (cells[y][x+1].rot - 2)%4
    cells[y-1][x].rot = (cells[y-1][x].rot - 2)%4
    cells[y+1][x].rot = (cells[y+1][x].rot - 2)%4
  elseif id == 17 then
    local jammed = false
    for i=0,8 do
      if i ~= 4 then
        cx = i%3-1
        cy = math.floor(i/3)-1
        if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 40 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 or cells[y+cy][x+cx].ctype == 50 then
          jammed = true
        end
        if cells[y+cy][x+cx].ctype > initialCellCount then
          if isModdedTrash(cells[y+cy][x+cx].ctype) or (GetSidedTrash(cells[y+cy][x+cx].ctype) ~= nil and GetSidedTrash(cells[y+cy][x+cx].ctype)(cx, cy, direction) == false) then
            jammed = true
          else
            jammed = not canPushCell(x+cx, y+cy, x, y, "gear")
          end
        end
        if config['gears_restrictions'] ~= 'true' then
          jammed = false
        end
      end
    end
    if not jammed then
      local oldcell
      local storedcell = CopyCell(x-1,y)
      for i=-1,1 do
        oldcell = CopyCell(x+i,y-1)	
        cells[y-1][x+i] = storedcell
        if i == 0 then
          cells[y-1][x+i].rot = (storedcell.rot+1)%4
        end
        storedcell = oldcell
      end
      oldcell = CopyCell(x+1,y)	
      cells[y][x+1] = storedcell
      cells[y][x+1].rot = (storedcell.rot+1)%4
      storedcell = oldcell
      for i=1,-1,-1 do
        oldcell = CopyCell(x+i,y+1)	
        cells[y+1][x+i] = storedcell
        if i == 0 then
          cells[y+1][x+i].rot = (storedcell.rot+1)%4
        end
        storedcell = oldcell
      end
      cells[y][x-1] = storedcell
      cells[y][x-1].rot = (storedcell.rot+1)%4
      SetChunk(x+1,y+1,cells[y+1][x+1].ctype)
      SetChunk(x,y+1,cells[y+1][x].ctype)
      SetChunk(x-1,y+1,cells[y+1][x-1].ctype)
      SetChunk(x+1,y,cells[y][x+1].ctype)
      SetChunk(x+1,y-1,cells[y-1][x+1].ctype)
      SetChunk(x,y-1,cells[y-1][x].ctype)
      SetChunk(x-1,y-1,cells[y-1][x-1].ctype)
      SetChunk(x-1,y,cells[y][x-1].ctype)
    end
  elseif id == 18 then
    local jammed = false
    for i=0,8 do
      if i ~= 4 then
        cx = i%3-1
        cy = math.floor(i/3)-1
        if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 40 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 or cells[y+cy][x+cx].ctype == 50 then
          jammed = true
        end
        if cells[y+cy][x+cx].ctype > initialCellCount then
          if isModdedTrash(cells[y+cy][x+cx].ctype) or (GetSidedTrash(cells[y+cy][x+cx].ctype) ~= nil and GetSidedTrash(cells[y+cy][x+cy].ctype)(x+cx, y+cy, direction) == false) then
            jammed = true
          else
            jammed = not canPushCell(x+cx, y+cy, x, y, "gear")
          end
        end
        if config['gears_restrictions'] ~= 'true' then
          jammed = false
        end
      end
    end
    if not jammed then
      local oldcell
      local storedcell = CopyCell(x+1,y)
      for i=1,-1,-1 do
        oldcell = CopyCell(x+i,y-1)	
        cells[y-1][x+i] = storedcell
        if i == 0 then
          cells[y-1][x+i].rot = (storedcell.rot-1)%4
        end
        storedcell = oldcell
      end
      oldcell = CopyCell(x-1,y)	
      cells[y][x-1] = storedcell
      cells[y][x-1].rot = (storedcell.rot-1)%4
      storedcell = oldcell
      for i=-1,1 do
        oldcell = CopyCell(x+i,y+1)	
        cells[y+1][x+i] = storedcell
        if i == 0 then
          cells[y+1][x+i].rot = (storedcell.rot-1)%4
        end
        storedcell = oldcell
      end
      cells[y][x+1] = storedcell
      cells[y][x+1].rot = (storedcell.rot-1)%4
      SetChunk(x+1,y+1,cells[y+1][x+1].ctype)
      SetChunk(x,y+1,cells[y+1][x].ctype)
      SetChunk(x-1,y+1,cells[y+1][x-1].ctype)
      SetChunk(x+1,y,cells[y][x+1].ctype)
      SetChunk(x+1,y-1,cells[y-1][x+1].ctype)
      SetChunk(x,y-1,cells[y-1][x].ctype)
      SetChunk(x-1,y-1,cells[y-1][x-1].ctype)
      SetChunk(x-1,y,cells[y][x-1].ctype)
    end
  elseif id == 16 then
    if cells[y][x-1].ctype ~= 16 then cells[y][x-1].rot = cells[y][x].rot end
    if cells[y][x+1].ctype ~= 16 then cells[y][x+1].rot = cells[y][x].rot end
    if cells[y-1][x].ctype ~= 16 then cells[y-1][x].rot = cells[y][x].rot end
    if cells[y+1][x].ctype ~= 16 then cells[y+1][x].rot = cells[y][x].rot end
  elseif id == 28 then
    if x > 1 then PullCell(x-2,y,0,false,1) end
    if x < width-2 then PullCell(x+2,y,2,false,1) end
    if y > 1 then PullCell(x,y-2,3,false,1) end
    if y < height-2 then PullCell(x,y+2,1,false,1) end
  elseif id == 20 then
    PushCell(x,y,0)
    PushCell(x,y,2)
    PushCell(x,y,3)
    PushCell(x,y,1)
  elseif id == 49 then
    DoSuperRepulser(x,y,0)
    supdatekey = supdatekey + 1
    DoSuperRepulser(x,y,2)
    supdatekey = supdatekey + 1
    DoSuperRepulser(x,y,3)
    supdatekey = supdatekey + 1
    DoSuperRepulser(x,y,1)
    supdatekey = supdatekey + 1
  elseif id == 57 then
    DoDriller(x,y,dir)
  elseif id == 27 then
    DoAdvancer(x, y, dir)
  elseif id == 13 then
    cells[y][x].updated = false
		PullCell(x,y,dir)
    --UpdatePullers()
  elseif id > 30 and id < 37 then
    DoGate(x, y, dir, id-30)
  elseif id == 24 then
    cells[y+1][x].updated = (cells[y+1][x].ctype ~= 19 and not isUnfreezable(cells[y+1][x].ctype))	--mold disappears if .updated is true
    cells[y-1][x].updated = (cells[y-1][x].ctype ~= 19 and not isUnfreezable(cells[y-1][x].ctype))
    cells[y][x+1].updated = (cells[y][x+1].ctype ~= 19 and not isUnfreezable(cells[y][x+1].ctype))
    cells[y][x-1].updated = (cells[y][x-1].ctype ~= 19 and not isUnfreezable(cells[y][x-1].ctype))
  elseif id == 42 then
    for cx=x-1,x+1 do
      for cy=y-1,y+1 do
        cells[cy][cx].protected = true
      end
    end
  elseif id == 14 or id == 55 then
    local rotSide = (dir%2 == 0) or (id == 55)
    local rotUp = (dir%2 == 1) or (id == 55)
    if rotSide then
      local canPushLeft = true
      local canPushRight = true
      if cells[y][x-1] ~= nil then
        if cells[y][x-1].ctype > initialCellCount then
          canPushLeft = canPushCell(x-1, y, x, y, "mirror")
        end
      end
      if cells[y][x+1] ~= nil then
        if cells[y][x+1].ctype > initialCellCount then
          canPushRight = canPushCell(x+1, y, x, y, "mirror")
        end
      end
      if isModdedTrash(cells[y][x-1].ctype) or ((GetSidedTrash(cells[y][x-1].ctype) ~= nil and GetSidedTrash(cells[y][x-1].ctype)(x-1, y, 2) == false)) then
        canPushLeft = false
      end
      if isModdedTrash(cells[y][x+1].ctype) or (GetSidedTrash(cells[y][x+1].ctype) ~= nil and GetSidedTrash(cells[y][x+1].ctype)(x+1, y, 2) == false) then
        canPushRight = false
      end
      if (cells[y][x-1].ctype ~= 11 and cells[y][x-1].ctype ~= 50 and cells[y][x-1].ctype ~= 55 and cells[y][x-1].ctype ~= -1 and cells[y][x-1].ctype ~= 40 and (cells[y][x-1].ctype ~= 14 or cells[y][x-1].rot%2 == 1) and canPushLeft
      and cells[y][x+1].ctype ~= 11 and cells[y][x+1].ctype ~= 50 and cells[y][x+1].ctype ~= 55 and cells[y][x+1].ctype ~= -1 and cells[y][x+1].ctype ~= 40 and (cells[y][x+1].ctype ~= 14 or cells[y][x+1].rot%2 == 1) and canPushRight) or config['mirror_restrictions'] ~= 'true' then
        local oldcell = CopyCell(x-1,y)
        cells[y][x-1] = CopyCell(x+1,y)
        cells[y][x+1] = oldcell
        SetChunk(x-1,y,cells[y][x-1].ctype)
        SetChunk(x+1,y,cells[y][x+1].ctype)
      end
    elseif rotUp then
      local canPushUp = true
      local canPushDown = true
      if cells[y-1] ~= nil then
        if cells[y-1][x].ctype > initialCellCount then
          canPushUp = canPushCell(x, y-1, x, y, "mirror")
        end
      end
      if cells[y+1] ~= nil then
        if cells[y+1][x].ctype > initialCellCount then
          canPushDown = canPushCell(x, y+1, x, y, "mirror")
        end
      end
      if cells[y-1] ~= nil then
        if isModdedTrash(cells[y-1][x].ctype) or ((GetSidedTrash(cells[y-1][x].ctype) ~= nil and GetSidedTrash(cells[y-1][x].ctype)(x, y-1, 3) == false)) then
          canPushUp = false
        end
      end
      if cells[y+1] ~= nil then
        if isModdedTrash(cells[y+1][x].ctype) or ((GetSidedTrash(cells[y+1][x].ctype) ~= nil and GetSidedTrash(cells[y+1][x].ctype)(x, y+1, 3) == false)) then
          canPushDown = false
        end
      end
      if not cells[y][x].updated and (cells[y][x].ctype == 14 and (cells[y][x].rot == 1 or cells[y][x].rot == 3) or cells[y][x].ctype == 55) then
        if cells[y-1][x].ctype ~= 11 and cells[y-1][x].ctype ~= 55 and cells[y-1][x].ctype ~= 50 and cells[y-1][x].ctype ~= -1 and cells[y-1][x].ctype ~= 40 and (cells[y-1][x].ctype ~= 14 or cells[y-1][x].rot%2 == 0)
        and cells[y+1][x].ctype ~= 11 and cells[y+1][x].ctype ~= 55 and cells[y+1][x].ctype ~= -1 and cells[y+1][x].ctype ~= 40 and (cells[y+1][x].ctype ~= 14 or cells[y+1][x].rot%2 == 0) and canPushUp and canPushDown or config['mirror_restrictions'] ~= 'true' then
          local oldcell = CopyCell(x,y-1)
          cells[y-1][x] = CopyCell(x,y+1)
          cells[y+1][x] = oldcell
          SetChunk(x,y-1,cells[y-1][x].ctype)
          SetChunk(x,y+1,cells[y+1][x].ctype)
        end
      end
    end
  elseif id == 43 then
    local canPushUp = true
    local canPushDown = true
    if cells[y-1] ~= nil then
      if cells[y-1][x].ctype > initialCellCount then
        canPushUp = canPushCell(x, y-1, x, y, "mirror")
      end
    end
    if cells[y+1] ~= nil then
      if cells[y+1][x].ctype > initialCellCount then
        canPushDown = canPushCell(x, y+1, x, y, "mirror")
      end
    end
    if cells[y-1] ~= nil then
      if isModdedTrash(cells[y-1][x].ctype) or ((GetSidedTrash(cells[y-1][x].ctype) ~= nil and GetSidedTrash(cells[y-1][x].ctype)(x, y-1, 3) == false)) then
        canPushUp = false
      end
    end
    if cells[y+1] ~= nil then
      if isModdedTrash(cells[y+1][x].ctype) or ((GetSidedTrash(cells[y+1][x].ctype) ~= nil and GetSidedTrash(cells[y+1][x].ctype)(x, y+1, 3) == false)) then
        canPushDown = false
      end
    end
    if not cells[y][x].updated and (cells[y][x].ctype == 14 and (cells[y][x].rot == 1 or cells[y][x].rot == 3) or cells[y][x].ctype == 55) then
      if cells[y-1][x].ctype ~= 11 and cells[y-1][x].ctype ~= 55 and cells[y-1][x].ctype ~= 50 and cells[y-1][x].ctype ~= -1 and cells[y-1][x].ctype ~= 40 and (cells[y-1][x].ctype ~= 14 or cells[y-1][x].rot%2 == 0)
      and cells[y+1][x].ctype ~= 11 and cells[y+1][x].ctype ~= 55 and cells[y+1][x].ctype ~= -1 and cells[y+1][x].ctype ~= 40 and (cells[y+1][x].ctype ~= 14 or cells[y+1][x].rot%2 == 0) and canPushUp and canPushDown or config['mirror_restrictions'] ~= 'true' then
        local oldcell = CopyCell(x,y-1)
        cells[y-1][x] = CopyCell(x,y+1)
        cells[y+1][x] = oldcell
        SetChunk(x,y-1,cells[y-1][x].ctype)
        SetChunk(x,y+1,cells[y+1][x].ctype)
      end
    end
  elseif id == 54 then
    DoSuperGenerator(x,y,dir)
		supdatekey = supdatekey + 1
  elseif id > initialCellCount and id ~= heaterID then
    DoModded(id, x, y, dir)
  end
end

function DoHeater(x, y)
  local offs = {
    {x=1,y=0},
    {x=-1,y=0},
    {x=0,y=1},
    {x=0,y=-1},
  }

  for _, off in ipairs(offs) do
    local ox = x + off.x
    local oy = y + off.y
    UpdateCell(cells[oy][ox].ctype, ox, oy, cells[oy][ox].rot)
  end
end