fastmoverID = 0
fastpullerID = 0
fastadvancerID = 0

fastermoverID = 0
fasterpullerID = 0
fasteradvancerID = 0

velocityID = 0
accelerationID = 0

velocity = 0.5
acceleration = 0.5

function addfastcells()
    fastmoverID = addCell("BM fastmove","bmod/fastmover.png",function() return true end,"mover")
    fastpullerID = addCell("BM fastpull","bmod/fastpuller.png",function() return true end,"mover")
    fastadvancerID = addCell("BM fastadvance","bmod/fastadvancer.png",function() return true end,"mover")

    fastermoverID = addCell("BM fastermove","bmod/fastermover.png",function() return true end,"mover")
    fasterpullerID = addCell("BM fasterpull","bmod/fasterpuller.png",function() return true end,"mover")
    fasteradvancerID = addCell("BM fasteradvance","bmod/fasteradvancer.png",function() return true end,"mover")

    velocityID = addCell("BM velocity", "textures/mover.png", function() return true end, "mover")
    BMod.bindUpdate(velocityID, doVelocity)

    accelerationID = addCell("BM acceleration", "textures/mover.png", function() return true end, "mover")
    BMod.bindUpdate(accelerationID, doAcceleration)
end

function doAcceleration(x, y, dir)
    if not cells[y][x].acc then cells[y][x].acc = velocity end
    local velBackup = velocity
    velocity = cells[y][x].acc
    cells[y][x].acc = cells[y][x].acc + acceleration
    doVelocity(x, y, dir)
    velocity = velBackup
end

function doVelocity(x, y, dir)
    if not cells[y][x].vel then cells[y][x].vel = 1 end
    cells[y][x].vel = cells[y][x].vel + velocity

    doSpecificMover(x, y, dir, math.floor(cells[y][x].vel))
end

function doFastMover(x,y,dir)
    doSpecificMover(x, y, dir, 2)
end

function doSpecificMover(x,y,dir,amount)
    cells[y][x].updated = true
    local cx = x
    local cy = y
    if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
    if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
    for i = 1,amount,1 do
        if not PushCell(cx,cy,dir,true,0) then return end
        if dir == 0 then cx = cx + 1 elseif dir == 2 then cx = cx - 1 else cx = cx end
        if dir == 1 then cy = cy + 1 elseif dir == 3 then cy = cy - 1 else cy = cy end
        local fx, fy = cx, cy
        if dir == 0 then fx = fx + 1 elseif dir == 2 then fx = fx - 1 else fx = fx end
        if dir == 1 then fy = fy + 1 elseif dir == 3 then fy = fy - 1 else fy = fy end
        local pos = walkDivergedPath(cx, cy, fx, fy)
        cx = pos.x
        cy = pos.y
        dir = pos.dir
        if dir == 0 then cx = cx - 1 elseif dir == 2 then cx = cx + 1 else cx = cx end
        if dir == 1 then cy = cy - 1 elseif dir == 3 then cy = cy + 1 else cy = cy end
    end
end

function doSpecificPuller(x,y,dir,amount)
    local nx,ny = x,y
    for i = 0,(amount-1) do
        local success
        if i ~= (amount-1) then success = PullCell(nx,ny,dir,nil,nil,nil,false) else success = PullCell(nx,ny,dir,nil,nil,nil,true) end
        if not success then return end
        local bx, by = nx, ny
        if dir == 0 then nx = nx + 1 elseif dir == 2 then nx = nx - 1 else nx = nx end
        if dir == 1 then ny = ny + 1 elseif dir == 3 then ny = ny - 1 else ny = ny end
        local pos = walkDivergedPath(bx, by, nx, ny)
        nx = pos.x
        ny = pos.y
        dir = pos.dir
    end
end

function doSpecificAdvancer(x,y,dir,amount)
    cells[y][x].updated = true
    local cx = x
    local cy = y
    if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
    if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
    for i = 1,amount,1 do
        if not PushCell(cx,cy,dir,true,0) then return end
        if dir == 0 then cx = cx + 1 elseif dir == 2 then cx = cx - 1 else cx = cx end
        if dir == 1 then cy = cy + 1 elseif dir == 3 then cy = cy - 1 else cy = cy end
        if i ~= amount then PullCell(cx,cy,dir,true,1,true,false,true) elseif i == amount then PullCell(cx,cy,dir,true,1,true,true,true) end
        local fx, fy = cx, cy
        if dir == 0 then fx = fx + 1 elseif dir == 2 then fx = fx - 1 else fx = fx end
        if dir == 1 then fy = fy + 1 elseif dir == 3 then fy = fy - 1 else fy = fy end
        local pos = walkDivergedPath(cx, cy, fx, fy)
        cx = pos.x
        cy = pos.y
        dir = pos.dir
        if dir == 0 then cx = cx - 1 elseif dir == 2 then cx = cx + 1 else cx = cx end
        if dir == 1 then cy = cy - 1 elseif dir == 3 then cy = cy + 1 else cy = cy end
    end
end

function doFastPuller(x,y,dir)
    doSpecificPuller(x, y, dir, 2)
end

function doFastAdvancer(x,y,dir)
    doSpecificAdvancer(x, y, dir, 2)
end