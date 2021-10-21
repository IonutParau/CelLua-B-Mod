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

function electunnel(x,y,dir)
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	cells[y][x].updated = true
	while true do							--what cell to copy?
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
			local olddir = direction
			if (cells[cy][cx].rot+3)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif cells[cy][cx].ctype == 30 then
			local olddir = direction
			if (cells[cy][cx].rot+3)%2 == direction%2 then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and (cells[cy][cx].rot+2)%2 ~= direction%2 then
			local olddir = direction
			if (cells[cy][cx].rot+1)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			break
		end
	end 
	addedrot = addedrot
	cells[cy][cx].testvar = "gen'd"
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and cells[cy][cx].ctype ~= -1  and cells[cy][cx].ctype ~= 11  and cells[cy][cx].ctype ~= 50 and (cells[cy][cx].ctype <= #cellsForIDManagement or canPushCell(cx,cy,x,y,"deleting generator")) then
        local outx, outy

        if dir == 0 then outx = x + 1 elseif dir == 2 then outx = x - 1 else outx = x end
        if dir == 1 then outy = y + 1 elseif dir == 3 then outy = y - 1 else outy = y end
        
        if cells[outy][outx].ctype == eleconID or cells[outy][outx].ctype == elecoffID then
            cells[cy][cx].ctype = 0
            cells[outy][outx].elec = 11
            cells[outy][outx].ctype = eleconID
            SpreadElec(outy,outx)
        elseif cells[outy][outx].ctype == redeleconID or cells[outy][outx].ctype == redelecoffID then
            cells[cy][cx].ctype = 0
            cells[outy][outx].elec = 11
            cells[outy][outx].ctype = redeleconID
            SpreadRedElec(outy,outx)
        end
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