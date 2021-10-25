BModAIID = 0

function addAI()
    BModAIID = addCell("BM AI","bmod/AI.png",{type = "mover"})
end

function DoAI(x,y,dir)
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

    if inGrid(ffx,ffy) and cells[ffy][ffx].ctype == killerKarlID then
        cells[ffy][ffx].ctype = deadKarlID
        SetChunk(ffx,ffy,deadKarlID)
    end

    if inGrid(bbx,bby) and cells[bby][bbx].ctype == killerKarlID then
        cells[bby][bbx].ctype = deadKarlID
        SetChunk(bbx,bby,deadKarlID)
    end

    if inGrid(rrx,rry) and cells[rry][rrx].ctype == killerKarlID then
        cells[rry][rrx].ctype = deadKarlID
        SetChunk(rrx,rry,deadKarlID)
    end

    if inGrid(llx,lly) and cells[lly][llx].ctype == killerKarlID then
        cells[lly][llx].ctype = deadKarlID
        SetChunk(llx,lly,deadKarlID)
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