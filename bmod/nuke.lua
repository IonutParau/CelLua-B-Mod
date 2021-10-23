local nuke1ID
local nuke2ID
local nuke3ID
local nuke4ID

function AddNukes()
    nuke1ID = addCell("N nuke1","nuke/nuke.png",{})
    nuke2ID = addCell("N nuke2","nuke/nuke2.png",{})
    nuke3ID = addCell("N nuke3","nuke/nuke3.png",{})
    nuke4ID = addCell("N nuke4","nuke/nuke4.png",{})
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