fastmoverID = 0
fastpullerID = 0
fastadvancerID = 0

fastermoverID = 0
fasterpullerID = 0
fasteradvancerID = 0

velocityID = 0

function addfastcells()
    fastmoverID = addCell("BM fastmove","bmod/fastmover.png",function() return true end,"mover")
    fastpullerID = addCell("BM fastpull","bmod/fastpuller.png",function() return true end,"mover")
    fastadvancerID = addCell("BM fastadvance","bmod/fastadvancer.png",function() return true end,"mover")

    fastermoverID = addCell("BM fastermove","bmod/fastermover.png",function() return true end,"mover")
    fasterpullerID = addCell("BM fasterpull","bmod/fasterpuller.png",function() return true end,"mover")
    --fasteradvancerID = addCell("BM fasteradvance","bmod/fasteradvancer.png",function() return true end,"mover")

    velocityID = addCell("BM velocity", "textures/mover.png", function() return true end, "mover")
    B-Mod.bindUpdate(velocityID, doVelocity)
end

function doVelocity(x, y, dir)
    if not cells[y][x].vel then cells[y][x].vel = 1 end
    cells[y][x].vel = cells[y][x].vel + 0.5

    doSpecificMover(x, y, dir, math.floor(cells[y][x].vel))
end

function doFastMover(x,y,dir)
    cells[y][x].updated = true
    local cx
    local cy
    if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
    if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
    if PushCell(cx,cy,dir,true,0) then --it'll come across itself as it moves and get 1 totalforce
        cy = y
        cx = x
        PushCell(cx,cy,dir,true,0)
    end
end

function doSpecificMover(x,y,dir,amount)
    cells[y][x].updated = true
    local cx, px = x, x
    local cy, py = y, y
    if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
    if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
    for i = 1,amount,1 do
        if not PushCell(cx,cy,dir,true,0) then return end
        if dir == 0 then cx = cx + 1 elseif dir == 2 then cx = cx - 1 else cx = cx end
        if dir == 1 then cy = cy + 1 elseif dir == 3 then cy = cy - 1 else cy = cy end
    end
end

function doSpecificPuller(x,y,dir,amount)
    local nx,ny = x,y
    local px,py = x,y
    for i = 0,(amount-1) do
        local success
        if i ~= (amount-1) then success = PullCell(nx,ny,dir,nil,nil,nil,false) else success = PullCell(nx,ny,dir,nil,nil,nil,true) end
        if not success then return end
        if dir == 0 then nx = nx + 1 elseif dir == 2 then nx = nx - 1 else nx = nx end
        if dir == 1 then ny = ny + 1 elseif dir == 3 then ny = ny - 1 else ny = ny end
    end
end

function doSpecificAdvancer(x,y,dir,amount)
    local cy,cx = x,y
    if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
    local nx,ny = x,y
    for i = 1,amount do
        if PushCell(cx,cy,dir,true,0) and cells[y][x].ctype == 0 then	--this is why i made pushcell return whether movement was a success or not
            if i ~= amount then PullCell(nx,ny,dir,nil,nil,nil,false) else PullCell(nx,ny,dir,nil,nil,nil,true) end
            if dir == 0 then cx = cx + 1 elseif dir == 2 then cx = cx - 1 else cx = cx end
            if dir == 1 then cy = cy + 1 elseif dir == 3 then cy = cy - 1 else cy = cy end
            if dir == 0 then nx = nx + 1 elseif dir == 2 then nx = nx - 1 else nx = nx end
            if dir == 1 then ny = ny + 1 elseif dir == 3 then ny = ny - 1 else ny = ny end
        else
            return
        end
    end
end

function doFasterAdvancer()
end

function doFastPuller(x,y,dir)
    if PullCell(x,y,dir,nil,nil,nil,false) then
        local ny,nx
        if dir == 0 then nx = x + 1 elseif dir == 2 then nx = x - 1 else nx = x end
        if dir == 1 then ny = y + 1 elseif dir == 3 then ny = y - 1 else ny = y end
        PullCell(nx,ny,dir,nil,nil,nil,true)
    end
end

function doFastAdvancer(x,y,dir)
    local cx,cy
    cells[y][x].updated = true
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if PushCell(cx,cy,dir,true,0) and cells[y][x].ctype == 0 then	--this is why i made pushcell return whether movement was a success or not
		PullCell(x,y,dir,true,1,true,false,true)
        if PushCell(x,y,dir,true,0) then
            local ny,nx
            if dir == 0 then nx = x + 1 elseif dir == 2 then nx = x - 1 else nx = x end
            if dir == 1 then ny = y + 1 elseif dir == 3 then ny = y - 1 else ny = y end
            PullCell(nx,ny,dir,true,1,true,true,true)
        end
	end
end