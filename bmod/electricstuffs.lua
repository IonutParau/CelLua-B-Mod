function elecgen(x,y,dir)
    local cy = y
    local cx = x
    local elec = 0
    local elec2 = 0
    if dir == 0 then cy = cy-1 elseif dir == 1 then cx = cx + 1 elseif dir == 2 then cy = cy + 1 elseif dir == 3 then cx = cx - 1 end
    if cells[cy] and cells[cy][cx] then
        if cells[cy][cx].elec == nil then cells[cy][cx].elec = 0 end
        elec = cells[cy][cx].elec
    end
    cy = y
    cx = x
    if dir == 0 then cy = cy+1 elseif dir == 1 then cx = cx - 1 elseif dir == 2 then cy = cy - 1 elseif dir == 3 then cx = cx + 1 end
    if cells[cy] and cells[cy][cx] then
        if cells[cy][cx].elec == nil then cells[cy][cx].elec = 0 end
        elec2 = cells[cy][cx].elec
    end
    cx = x
    cy = y
    if elec2 > 0 or elec > 0 then
        DoGenerator(x,y,dir,dir,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
    end
end

function elecmover(x,y,dir)
    if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
    if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
    if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
    if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
    local elec = cells[y][x+1].elec
    local elec2 = cells[y][x-1].elec
    local elec3 = cells[y+1][x].elec
    local elec4 = cells[y-1][x].elec
    if elec > 0 or elec2 > 0 or elec3 > 0 or elec4 > 0 then
        DoMover(x,y,dir)
    end
end

function elecrot(type,x,y,dir)
    if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
    if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
    if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
    if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
    local elec = cells[y][x+1].elec
    local elec2 = cells[y][x-1].elec
    local elec3 = cells[y+1][x].elec
    local elec4 = cells[y-1][x].elec
    if elec > 0 or elec2 > 0 or elec3 > 0 or elec4 > 0 then
        if type == "cw" then
            rotateCell(x+1,y,1)
            rotateCell(x-1,y,1)
            rotateCell(x,y+1,1)
            rotateCell(x,y-1,1)
        elseif type == "ccw" then
            rotateCell(x+1,y,-1)
            rotateCell(x-1,y,-1)
            rotateCell(x,y+1,-1)
            rotateCell(x,y-1,-1)
        end
    end
end