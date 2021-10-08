function DoForceDiaMover(x,y,dir)
	cells[y][x].updated = true
	local cx
	local cy
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if PushCell(cx,cy,dir,true,1) then
		local ccx,ccy
		if dir == 0 then ccx = x + 1 elseif dir == 2 then ccx = x - 1 else ccx = x end
		if dir == 1 then ccy = y + 1 elseif dir == 3 then ccy = y - 1 else ccy = y end
		local newdir = (dir-1)%4
		local cccx,cccy
		if newdir == 0 then cccx = ccx - 1 elseif newdir == 2 then cccx = ccx + 1 else cccx = ccx end
		if newdir == 1 then cccy = ccy - 1 elseif newdir == 3 then cccy = ccy + 1 else cccy = ccy end
		PushCell(cccx,cccy,newdir,true,1)
	else
		local newdir = (dir-1)%4
		if newdir == 0 then cx = x - 1 elseif newdir == 2 then cx = x + 1 else cx = x end
		if newdir == 1 then cy = y - 1 elseif newdir == 3 then cy = y + 1 else cy = y end
		PushCell(cx,cy,newdir,true,1)
	end
end

function DoForceFastDiaMover(x,y,dir)
	cells[y][x].updated = true
	local cx
	local cy
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if PushCell(cx,cy,dir,true,1) then
		local ccx,ccy
		if dir == 0 then ccx = x + 1 elseif dir == 2 then ccx = x - 1 else ccx = x end
		if dir == 1 then ccy = y + 1 elseif dir == 3 then ccy = y - 1 else ccy = y end
		local newdir = (dir-1)%4
		local cccx,cccy
		if newdir == 0 then cccx = ccx - 1 elseif newdir == 2 then cccx = ccx + 1 else cccx = ccx end
		if newdir == 1 then cccy = ccy - 1 elseif newdir == 3 then cccy = ccy + 1 else cccy = ccy end
		if PushCell(cccx,cccy,newdir,true,1) then
            cx = cccx
            cy = cccy
            if newdir == 0 then cx = cx + 2 elseif newdir == 2 then cx = cx - 2 else cx = cx end
            if newdir == 1 then cy = cy + 2 elseif newdir == 3 then cy = cy - 2 else cy = cy end
            if dir == 0 then cx = cx - 1 elseif dir == 2 then cx = cx + 1 else cx = cx end
            if dir == 1 then cy = cy - 1 elseif dir == 3 then cy = cy + 1 else cy = cy end
            if PushCell(cx,cy,dir,true,1) then
                if dir == 0 then cx = cx + 2 elseif dir == 2 then cx = cx - 2 else cx = cx end
                if dir == 1 then cy = cy + 2 elseif dir == 3 then cy = cy - 2 else cy = cy end
                newdir = (dir-1)%4
                if newdir == 0 then cx = cx - 1 elseif newdir == 2 then cx = cx + 1 else cx = cx end
                if newdir == 1 then cy = cy - 1 elseif newdir == 3 then cy = cy + 1 else cy = cy end
                PushCell(cx,cy,newdir,true,1)
            else
                if dir == 0 then cx = cx + 1 elseif dir == 2 then cx = cx - 1 else cx = cx end
                if dir == 1 then cy = cy + 1 elseif dir == 3 then cy = cy - 1 else cy = cy end
                newdir = (dir-1)%4
                if newdir == 0 then cx = cx - 1 elseif newdir == 2 then cx = cx + 1 else cx = cx end
                if newdir == 1 then cy = cy - 1 elseif newdir == 3 then cy = cy + 1 else cy = cy end
                PushCell(cx,cy,newdir,true,1)
            end
        else
            cx = cccx
            cy = cccy
            newdir = (dir-1)%4
            if newdir == 0 then cx = x + 1 elseif dir == 2 then cx = x - 1 else cx = x end
            if newdir == 1 then cy = y + 1 elseif dir == 3 then cy = y - 1 else cy = y end
            if PushCell(cx,cy,dir,true,1) then
                if dir == 0 then cx = cx + 2 elseif dir == 2 then cx = cx - 2 else cx = cx end
                if dir == 1 then cy = cy + 2 elseif dir == 3 then cy = cy - 2 else cy = cy end
                newdir = (dir-1)%4
                if newdir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
                if newdir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
                PushCell(cx,cy,newdir,true,1)
            else
                newdir = (dir-1)%4
                if newdir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
                if newdir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
                PushCell(cx,cy,newdir,true,1)
            end
        end
	else
		local newdir = (dir-1)%4
		if newdir == 0 then cx = x - 1 elseif newdir == 2 then cx = x + 1 else cx = x end
		if newdir == 1 then cy = y - 1 elseif newdir == 3 then cy = y + 1 else cy = y end
		if PushCell(cx,cy,newdir,true,1) then
            newdir = (dir-1)%4
            if newdir == 0 then cx = x + 1 elseif dir == 2 then cx = x - 1 else cx = x end
            if newdir == 1 then cy = y + 1 elseif dir == 3 then cy = y - 1 else cy = y end
            if dir == 0 then cx = cx - 1 elseif dir == 2 then cx = cx + 1 else cx = cx end
            if dir == 1 then cy = cy - 1 elseif dir == 3 then cy = cy + 1 else cy = cy end
            if PushCell(cx,cy,dir,true,1) then
                if dir == 0 then cx = cx + 2 elseif dir == 2 then cx = cx - 2 else cx = cx end
                if dir == 1 then cy = cy + 2 elseif dir == 3 then cy = cy - 2 else cy = cy end
                newdir = (dir-1)%4
                if newdir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
                if newdir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
                PushCell(cx,cy,newdir,true,1)
            else
                newdir = (dir-1)%4
                if newdir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
                if newdir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
                PushCell(cx,cy,newdir,true,1)
            end
        else
            cx = x
            cy = y
            if dir == 0 then cx = cx - 1 elseif dir == 2 then cx = cx + 1 else cx = cx end
            if dir == 1 then cy = cy - 1 elseif dir == 3 then cy = cy + 1 else cy = cy end
            if PushCell(cx,cy,dir,true,1) then
                if dir == 0 then cx = cx + 2 elseif dir == 2 then cx = cx - 2 else cx = cx end
                if dir == 1 then cy = cy + 2 elseif dir == 3 then cy = cy - 2 else cy = cy end
                newdir = (dir-1)%4
                if newdir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
                if newdir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
                PushCell(cx,cy,newdir,true,1)
            else
                newdir = (dir-1)%4
                if newdir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
                if newdir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
                PushCell(cx,cy,newdir,true,1)
            end
        end
	end
end

fastdiamoverID = 0
slowdiamoverID = 0
slowerdiamoverID = 0

function adddiamover()
    diamoverID = addCell("BM diamover","bmod/dmover.png",function() return true end)
end

function adddiamovers()
    fastdiamoverID = addCell("BM fastdiamover","bmod/fastdmover.png",function() return true end)
    slowdiamoverID = addCell("BM slowdiamover","bmod/slowdmover.png",function() return true end)
    slowerdiamoverID = addCell("BM slowerdiamover","bmod/slowerdmover.png",function() return true end)
end