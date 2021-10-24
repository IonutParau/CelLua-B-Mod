function DoKAI(x, y, dir)

    if cells[y][x].kaiFOOD == nil then 
        cells[y][x].kaiFOOD = 69
    end

    local bx,by
    if dir == 0 then bx = x - 1 elseif dir == 2 then bx = x + 1 else bx = x end
    if dir == 1 then by = y - 1 elseif dir == 3 then by = y + 1 else by = y end


    local fx,fy
    if dir == 0 then fx = x + 1 elseif dir == 2 then fx = x - 1 else fx = x end
    if dir == 1 then fy = y + 1 elseif dir == 3 then fy = y - 1 else fy = y end
	
	
	    local kx,ky
    if dir == 0 then kx = x + 2 elseif dir == 2 then kx = x - 2 else kx = x end
    if dir == 1 then ky = y + 2 elseif dir == 3 then ky = y - 2 else ky = y end



    local lx,ly
    if dir == 0 then ly = y - 1 elseif dir == 2 then ly = y + 1 else ly = y end
    if dir == 1 then lx = x + 1 elseif dir == 3 then lx = x - 1 else lx = x end

    local rx,ry
    if dir == 0 then ry = y + 1 elseif dir == 2 then ry = y - 1 else ry = y end
    if dir == 1 then rx = x - 1 elseif dir == 3 then rx = x + 1 else rx = x end

    if cells[y][x].kaiFOOD >= 75 and cells[by][bx].ctype == 0 then --I LOVE REPRODUCING ON A FULL STOMACH!
        cells[by][bx] = {
            ctype = kaiID,
            rot = 0,
            lastvars = cells[by][bx].lastvars,
            kaiFOOD = 69
        }
        cells[y][x].kaiFOOD = 50
        return
    end
    
    if cells[fy][fx].ctype == brainID then
        cells[y][x].kaiFOOD = cells[y][x].kaiFOOD + 1
        return
    end

    if not offgrid(kx, ky) and (isKarl(cells[ky][kx].ctype) or cells[ky][kx].ctype == waterID) then
        cells[ky][kx] = {
            ctype = 0,
            rot = 0,
            lastvars = cells[ky][kx].lastvars
        }
        cells[y][x].kaiFOOD = cells[y][x].kaiFOOD + 17
    end
	
	if isKarl(cells[fy][fx].ctype) or cells[fy][fx].ctype == waterID then
        cells[fy][fx] = {
            ctype = 0,
            rot = 0,
            lastvars = cells[fy][fx].lastvars
        }
        cells[y][x].kaiFOOD = cells[y][x].kaiFOOD + 17
    end


    if cells[fy][fx].ctype ~= 0 and cells[fy][fx].ctype ~= brainID then
        if cells[ly][lx].ctype ~= 0 and cells[ry][rx].ctype == 0 then
            rotateCell(x, y, 1)
        elseif cells[ry][rx].ctype ~= 0 and cells[ly][lx].ctype == 0 then
            rotateCell(x, y, -1)
        elseif cells[ry][rx].ctype ~= 0 and cells[ly][lx].ctype ~= 0 and cells[by][bx].ctype == 0 then
            rotateCell(x, y, 2)
        elseif cells[ry][rx].ctype == 0 and cells[ly][lx].ctype == 0 and cells[by][bx].ctype ~= 0 then
            rotateCell(x, y, 1)
        elseif cells[ry][rx].ctype == 0 and cells[ly][lx].ctype == 0 and cells[by][bx].ctype == 0 then
            rotateCell(x, y, 2)
        else
            return
        end
    end

    if cells[y][x].kaiFOOD <= 0 then
        cells[y][x] = {
            ctype = 0,
            rot = 0,
            lastvars = cells[y][x].lastvars
        }
        return
    end

    cells[y][x].kaiFOOD = cells[y][x].kaiFOOD - 1
    DoMover(x, y, cells[y][x].rot)
end