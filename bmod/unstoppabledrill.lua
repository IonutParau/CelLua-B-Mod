-- Code from UndefinedMonitor#1595.

function DoUnstoppableDrill(x, y, dir)
    local fx, fy = x, y

    if dir == 0 then fx = x + 1 elseif dir == 2 then fx = x - 1 end
    if dir == 1 then fy = y + 1 elseif dir == 3 then fy = y - 1 end

    if fx == 0 or fy == 0 or fx == width-1 or fy == height-1 then return end -- No crash for u

    local front = CopyTable(cells[fy][fx])
    cells[fy][fx] = CopyTable(cells[y][x])
    cells[y][x] = front

    SetChunk(x, y, cells[y][x].ctype)
    SetChunk(fx, fy, cells[fy][fx].ctype)
end