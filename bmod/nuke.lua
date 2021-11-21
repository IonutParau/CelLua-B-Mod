nuke1ID = 0
nuke2ID = 0
nuke3ID = 0
nuke4ID = 0

function AddNukes()
    nuke1ID = addCell("BM nuke1","bmod/nuke.png",{})
    nuke2ID = addCell("BM nuke2","bmod/nuke2.png",{})
    nuke3ID = addCell("BM nuke3","bmod/nuke3.png",{})
    nuke4ID = addCell("BM nuke4","bmod/nuke4.png",{})
end

local function DoNuke(x,y,id,power)
    local rcon,lcon,ucon,dcon = true,true,true,true
    for i = 1,power do
        if rcon then
            if not PushCell(x,y,0,false,1,id,0,true,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(0)},false,false) then rcon = false end
        end
        if lcon then
            if not PushCell(x,y,2,false,1,id,0,true,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(0)},false,false) then lcon = false end
        end
        if ucon then
            if not PushCell(x,y,3,false,1,id,0,true,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(0)},false,false) then lcon = false end
        end
        if dcon  then
            if not PushCell(x,y,1,false,1,id,0,true,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(0)},false,false) then dcon = false end
        end
        if not dcon and not ucon and not lcon and not rcon then
            return
        end
    end
end

function UpdateNukes(id,x,y,rot)
    if id == nuke1ID then
        DoNuke(x,y,id,1)
    elseif id == nuke2ID then
        DoNuke(x,y,id,2)
    elseif id == nuke3ID then
        DoNuke(x,y,id,5)
    elseif id == nuke4ID then
        DoNuke(x,y,id,10)
    end
end