function doleds()
    redID = addCell("BM redledon","bmod/ledredon.png",{})
    greenID = addCell("BM greenledon","bmod/ledgreenon.png",{})
    blueID = addCell("BM blueledon","bmod/ledblueon.png",{})
    magentID = addCell("BM magentaledon","bmod/ledmagentaon.png",{})
    yellID = addCell("BM yellowledon","bmod/ledyellowon.png",{})
    cyaID = addCell("BM cyanledon","bmod/ledcyanon.png",{})
    redoffID = addCell("BM redledoff","bmod/ledoff.png",{invisible = true})
    greenoffID = addCell("BM greenledoff","bmod/ledoff.png",{invisible = true})
    blueoffID = addCell("BM blueledoff","bmod/ledoff.png",{invisible = true})
    magentoffID = addCell("BM magentaledoff","bmod/ledoff.png",{invisible = true})
    yelloffID = addCell("BM yellowledoff","bmod/ledoff.png",{invisible = true})
    cyaoffID = addCell("BM cyanledoff","bmod/ledoff.png",{invisible = true})
end

function DoLed(type,x,y)
    if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
    if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
    if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
    if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
    local elec = cells[y][x+1].elec
    local elec2 = cells[y][x-1].elec
    local elec3 = cells[y+1][x].elec
    local elec4 = cells[y-1][x].elec
    if elec > 0 or elec2 > 0 or elec3 > 0 or elec4 > 0 then
        if type == "red" then
            cells[y][x].ctype = redID
            SetChunk(x,y,redID)
        elseif type == "green" then
            cells[y][x].ctype = greenID
            SetChunk(x,y,greenID)
        elseif type == "blue" then
            cells[y][x].ctype = blueID
            SetChunk(x,y,blueID)
        elseif type == "magenta" then
            cells[y][x].ctype = magentID
            SetChunk(x,y,magentID)
        elseif type == "yellow" then
            cells[y][x].ctype = yellID
            SetChunk(x,y,yellID)
        elseif type == "cyan" then
            cells[y][x].ctype = cyaID
            SetChunk(x,y,cyaID)
        end
    else
        if type == "red" then
            cells[y][x].ctype = redoffID
            SetChunk(x,y,redoffID)
        elseif type == "green" then
            cells[y][x].ctype = greenoffID
            SetChunk(x,y,greenoffID)
        elseif type == "blue" then
            cells[y][x].ctype = blueoffID
            SetChunk(x,y,blueoffID)
        elseif type == "magenta" then
            cells[y][x].ctype = magentoffID
            SetChunk(x,y,magentoffID)
        elseif type == "yellow" then
            cells[y][x].ctype = yelloffID
            SetChunk(x,y,yelloffID)
        elseif type == "cyan" then
            cells[y][x].ctype = cyaoffID
            SetChunk(x,y,cyaoffID)
        end
    end
end