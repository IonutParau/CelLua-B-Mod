function andgate(x,y,dir)
    local average
	local value
	local direction = (dir-2)%4
	local cx = x
	local elec
	local elec2
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec = cells[cy][cx].elec
        end
        if not elec then cells[cy][cx].elec = 0 elec = 0 end

		cx = x
		cy = y
		direction = (dir)
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec2 = cells[cy][cx].elec
        end
        if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end

		average = (elec+elec2)/2
		value = math.floor(average)

		if elec and elec2 then
			if elec > 0 and elec2 > 0 then
				cx = x
				cy = y
				direction = (dir-1)%4
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = value
					SpreadElec(cy,cx)
				elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
					cells[cy][cx].ctype = redeleconID
					SetChunk(cx,cy,redeleconID)
					cells[cy][cx].elec = value
					SpreadRedElec(cy,cx)
				end
			end
		end
end

function orgate(x,y,dir)
    local average
	local value
	local direction = (dir-2)%4
	local cx = x
	local elec
	local elec2
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec = cells[cy][cx].elec
        end
        if not elec then cells[cy][cx].elec = 0 elec = 0 end

		cx = x
		cy = y
		direction = (dir)
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec2 = cells[cy][cx].elec
        end
        if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end

        if elec2 > 0 and elec > 0 then
            average = (elec+elec2)/2
            value = math.floor(average)
        elseif elec > 0 and elec2 == 0 then
            value = elec
        elseif elec == 0 and elec2 > 0 then
            value = elec2
        end

		if elec and elec2 then
			if elec > 0 or elec2 > 0 then
				cx = x
				cy = y
				direction = (dir-1)%4
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = value
					SpreadElec(cy,cx)
				elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
					cells[cy][cx].ctype = redeleconID
					SetChunk(cx,cy,redeleconID)
					cells[cy][cx].elec = value
					SpreadRedElec(cy,cx)
				end
			end
		end
end

function xorgate(x,y,dir)
	local value
	local direction = (dir-2)%4
	local cx = x
	local elec
	local elec2
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec = cells[cy][cx].elec
        end
        if not elec then cells[cy][cx].elec = 0 elec = 0 end

		cx = x
		cy = y
		direction = (dir)
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec2 = cells[cy][cx].elec
        end
        if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end

        if elec > 0 and elec2 == 0 then
            value = elec
        elseif elec == 0 and elec2 > 0 then
            value = elec2
        end

		if elec and elec2 then
			if (elec2 > 0 and elec == 0) or (elec > 0 and elec2 == 0) then
				cx = x
				cy = y
				direction = (dir-1)%4
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = value
					SpreadElec(cy,cx)
				elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
					cells[cy][cx].ctype = redeleconID
					SetChunk(cx,cy,redeleconID)
					cells[cy][cx].elec = value
					SpreadRedElec(cy,cx)
				end
			end
		end
end

function xnorgate(x,y,dir)
    local average
    local value
	local direction = (dir-2)%4
	local cx = x
	local elec
	local elec2
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec = cells[cy][cx].elec
        end
        if not elec then cells[cy][cx].elec = 0 elec = 0 end

		cx = x
		cy = y
		direction = (dir)
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec2 = cells[cy][cx].elec
        end
        if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end

        if elec > 0 and elec2 > 0 then
            average = (elec+elec2)/2
            value = math.floor(average)
        elseif elec == 0 and elec2 == 0 then
            value = 11
        end

		if elec and elec2 then
			if (elec2 > 0 and elec > 0) or (elec == 0 and elec2 == 0) then
				cx = x
				cy = y
				direction = (dir-1)%4
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = value
					SpreadElec(cy,cx)
				elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
					cells[cy][cx].ctype = redeleconID
					SetChunk(cx,cy,redeleconID)
					cells[cy][cx].elec = value
					SpreadRedElec(cy,cx)
				end
			end
		end
end

function norgate(x,y,dir)
    local average
    local value
	local direction = (dir-2)%4
	local cx = x
	local elec
	local elec2
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec = cells[cy][cx].elec
        end
        if not elec then cells[cy][cx].elec = 0 elec = 0 end

		cx = x
		cy = y
		direction = (dir)
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec2 = cells[cy][cx].elec
        end
        if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end

        value = 11

		if elec and elec2 then
			if elec2 == 0 and elec == 0 then
				cx = x
				cy = y
				direction = (dir-1)%4
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = value
					SpreadElec(cy,cx)
				elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
					cells[cy][cx].ctype = redeleconID
					SetChunk(cx,cy,redeleconID)
					cells[cy][cx].elec = value
					SpreadRedElec(cy,cx)
				end
			end
		end
end

function nandgate(x,y,dir)
    local average
    local value
	local direction = (dir-2)%4
	local cx = x
	local elec
	local elec2
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec = cells[cy][cx].elec
        end
        if not elec then cells[cy][cx].elec = 0 elec = 0 end

		cx = x
		cy = y
		direction = (dir)
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
        if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
            elec2 = cells[cy][cx].elec
        end
        if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end

        if elec2 == 0 and elec == 0 then
            value = 11
        elseif elec > 0 and elec2 == 0 then
            value = elec
        elseif elec == 0 and elec2 > 0 then
            value = elec2
        end

		if elec and elec2 then
			if not (elec > 0 and elec2 > 0) then
				cx = x
				cy = y
				direction = (dir-1)%4
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = value
					SpreadElec(cy,cx)
				elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
					cells[cy][cx].ctype = redeleconID
					SetChunk(cx,cy,redeleconID)
					cells[cy][cx].elec = value
					SpreadRedElec(cy,cx)
				end
			end
		end
end

function notgate(x,y,dir)
    local direction = (dir-3)%4
	local cx = x
	local elec
	local cy = y
		cx = x
		cy = y
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		elec = cells[cy][cx].elec
        if not elec then cells[cy][cx].elec = 0 elec = 0 end
		if elec == 0 then
			cx = x
			cy = y
			direction = (dir-1)%4
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID then
					cells[cy][cx].ctype = eleconID
					SetChunk(cx,cy,eleconID)
					cells[cy][cx].elec = 10
					SpreadElec(cy,cx)
			elseif cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
				cells[cy][cx].ctype = redeleconID
				SetChunk(cx,cy,redeleconID)
				cells[cy][cx].elec = 10
				SpreadRedElec(cy,cx)
			end
		end
end