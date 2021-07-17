local cells,delay,dtime,currentstate,currentrot,tex,zoom,offx,offy,placecells,interpolate,inmenu,tpu,updatekey,dodebug,itime,initial,isinitial,paused,placeables,newwidth,newheight,showinstructions
 = {},0.25,0,1,0,{},20,0,0,true,true,false,1,0,false,0,{},true,true,{},100,100,true
local width,height = 100,100
love.graphics.setDefaultFilter("nearest")
tex[-2],tex[-1],tex[0] = love.graphics.newImage("placeable.png"),love.graphics.newImage("wall.png"),love.graphics.newImage("bg.png")
tex[1],tex[2],tex[3] = love.graphics.newImage("mover.png"),love.graphics.newImage("generator.png"),love.graphics.newImage("push.png")
tex[4],tex[5],tex[6] = love.graphics.newImage("slide.png"),love.graphics.newImage("onedirectional.png"),love.graphics.newImage("twodirectional.png")
tex[7],tex[8],tex[9] = love.graphics.newImage("threedirectional.png"),love.graphics.newImage("rotator_cw.png"),love.graphics.newImage("rotator_ccw.png")
tex[10],tex[11],tex[12] = love.graphics.newImage("rotator_180.png"),love.graphics.newImage("trash.png"),love.graphics.newImage("enemy.png")
tex[13],tex[14],tex[15] = love.graphics.newImage("puller.png"),love.graphics.newImage("mirror.png"),love.graphics.newImage("diverger.png")
tex[16],tex[17],tex[18] = love.graphics.newImage("redirector.png"),love.graphics.newImage("gear_cw.png"),love.graphics.newImage("gear_ccw.png")
tex[19],tex[20],tex[21] = love.graphics.newImage("mold.png"),love.graphics.newImage("repulse.png"),love.graphics.newImage("weight.png")
tex[22],tex[23] = love.graphics.newImage("triplegenerator.png"),love.graphics.newImage("doubleenemy.png")
local bgsprites
local destroysound = love.audio.newSource("destroy.wav", "static")
local beep = love.audio.newSource("beep.wav", "static")

local function lerp(a,b,m,notgraphics)
	if notgraphics or (interpolate and delay > 0) then	
		return a+(b-a)*m
	else return b end
end

local function round(a) --lazy moment
	return math.floor(a+0.5)
end

local cheatsheet = {}
for i=0,9 do cheatsheet[tostring(i)] = i end
for i=0,25 do cheatsheet[string.char(string.byte("a")+i)] = i+10 end
for i=0,25 do cheatsheet[string.char(string.byte("A")+i)] = i+36 end
cheatsheet["!"] = 62
cheatsheet["$"] = 63
cheatsheet["%"] = 64
cheatsheet["&"] = 65
cheatsheet["+"] = 66
cheatsheet["-"] = 67
cheatsheet["."] = 68
cheatsheet["="] = 69
cheatsheet["?"] = 70
cheatsheet["^"] = 71
cheatsheet["{"] = 72
cheatsheet["}"] = 73

local function unbase74(origvalue)
	local result = 0
	local iter = 0
	local chars = string.len(origvalue)
	for i=chars,1,-1 do
		iter = iter + 1
		local mult = 74^(iter-1)
		result = result + cheatsheet[string.sub(origvalue,i,i)] * mult
	end
	return result
end

V3Cells = {}
V3Cells["0"] = {2,0,false} V3Cells["i"] = {2,1,false} V3Cells["A"] = {2,2,false} V3Cells["S"] = {2,3,false}
V3Cells["1"] = {2,0,true} V3Cells["j"] = {2,1,true} V3Cells["B"] = {2,2,true} V3Cells["T"] = {2,3,true} 
V3Cells["2"] = {8,0,false} V3Cells["k"] = {8,1,false} V3Cells["C"] = {8,2,false} V3Cells["U"] = {8,3,false}
V3Cells["3"] = {8,0,true} V3Cells["l"] = {8,1,true} V3Cells["D"] = {8,2,true} V3Cells["V"] = {8,3,true} 
V3Cells["4"] = {9,0,false} V3Cells["m"] = {9,1,false} V3Cells["E"] = {9,2,false} V3Cells["W"] = {9,3,false}
V3Cells["5"] = {9,0,true} V3Cells["n"] = {9,1,true} V3Cells["F"] = {9,2,true} V3Cells["X"] = {9,3,true} 
V3Cells["6"] = {1,0,false} V3Cells["o"] = {1,1,false} V3Cells["G"] = {1,2,false} V3Cells["Y"] = {1,3,false}
V3Cells["7"] = {1,0,true} V3Cells["p"] = {1,1,true} V3Cells["H"] = {1,2,true} V3Cells["Z"] = {1,3,true} 
V3Cells["8"] = {4,0,false} V3Cells["q"] = {4,1,false} V3Cells["I"] = {4,2,false} V3Cells["!"] = {4,3,false}
V3Cells["9"] = {4,0,true} V3Cells["r"] = {4,1,true} V3Cells["J"] = {4,2,true} V3Cells["$"] = {4,3,true} 
V3Cells["a"] = {3,0,false} V3Cells["s"] = {3,1,false} V3Cells["K"] = {3,2,false} V3Cells["%"] = {3,3,false}
V3Cells["b"] = {3,0,true} V3Cells["t"] = {3,1,true} V3Cells["L"] = {3,2,true} V3Cells["&"] = {3,3,true} 
V3Cells["c"] = {-1,0,false} V3Cells["u"] = {-1,1,false} V3Cells["M"] = {-1,2,false} V3Cells["+"] = {-1,3,false}
V3Cells["d"] = {-1,0,true} V3Cells["v"] = {-1,1,true} V3Cells["N"] = {-1,2,true} V3Cells["-"] = {-1,3,true} 
V3Cells["e"] = {12,0,false} V3Cells["w"] = {12,1,false} V3Cells["O"] = {12,2,false} V3Cells["."] = {12,3,false}
V3Cells["f"] = {12,0,true} V3Cells["x"] = {12,1,true} V3Cells["P"] = {12,2,true} V3Cells["="] = {12,3,true} 
V3Cells["g"] = {11,0,false} V3Cells["y"] = {11,1,false} V3Cells["Q"] = {11,2,false} V3Cells["?"] = {11,3,false}
V3Cells["h"] = {11,0,true} V3Cells["z"] = {11,1,true} V3Cells["R"] = {11,2,true} V3Cells["^"] = {11,3,true} 
V3Cells["{"] = {0,0,false} V3Cells["}"] = {0,0,true}

local function DecodeV3(code)
	local currentspot = 0
	local currentcharacter = 3 --start right after V3;
	local storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter)
		end
	end
	width = unbase74(storedstring)+2
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	height = unbase74(storedstring)+2
	for y=0,height-1 do
		initial[y] = {}
		placeables[y] = {}
		cells[y] = {}
		for x=0,width-1 do
			initial[y][x] = {}
			cells[y][x] = {}
			initial[y][x].ctype = 0
			initial[y][x].rot = 0
			placeables[y][x] = false
		end
	end
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ")" then							--basic repeat
			local howmany = unbase74(string.sub(code,currentcharacter+1,currentcharacter+1))
			local howmuch = unbase74(string.sub(code,currentcharacter+2,currentcharacter+2))
			local curcell = 0
			local startspot = currentspot
			for i=1,howmuch do
				if curcell == 0 then
					curcell = howmany
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].ctype = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].ctype
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].rot = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].rot
				placeables[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1] = placeables[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1]
			end
			currentcharacter = currentcharacter + 2
		elseif string.sub(code,currentcharacter,currentcharacter) == "(" then						--advanced repeat
			local howmany = ""
			local howmuch = ""
			local simplemuch = false
			while true do
				currentcharacter = currentcharacter + 1
				if string.sub(code,currentcharacter,currentcharacter) == "(" then
					break
				elseif string.sub(code,currentcharacter,currentcharacter) == ")" then
					simplemuch = true
					break
				else
					howmany = howmany..string.sub(code,currentcharacter,currentcharacter)
				end
			end
			howmany = unbase74(howmany)
			if simplemuch then
				currentcharacter = currentcharacter + 1
				howmuch = unbase74(string.sub(code,currentcharacter,currentcharacter))
			else
				while true do
					currentcharacter = currentcharacter + 1
					if string.sub(code,currentcharacter,currentcharacter) == ")" then
						break
					else
						howmuch = howmuch..string.sub(code,currentcharacter,currentcharacter)
					end
				end
				howmuch = unbase74(howmuch)
			end
			local curcell = 0
			local startspot = currentspot
			for i=1,howmuch do
				if curcell == 0 then
					curcell = howmany
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].ctype = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].ctype
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].rot = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].rot
				placeables[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1] = placeables[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else																						--one cell
			currentspot = currentspot + 1
			local cell = V3Cells[string.sub(code,currentcharacter,currentcharacter)]
			initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].ctype = cell[1]
			initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].rot = cell[2]
			placeables[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1] = cell[3]
		end
	end
	bgsprites = love.graphics.newSpriteBatch(tex[0])
	for y=0,height-1 do
		for x=0,width-1 do
		if y == 0 or x == 0 or y == height-1 or x == width-1 then
				initial[y][x].ctype = -1
			end
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
	paused = true
	isinitial = true
end

local function UpdateMirrors()
	for y=1,height-2 do
		for x=2,width-2 do
			if cells[y][x].ctype == 14 and (cells[y][x].rot == 0 or cells[y][x].rot == 2) then
				if cells[y][x-1].ctype ~= 11 and cells[y][x-1].ctype ~= -1 and cells[y][x-1].ctype ~= 14 and cells[y][x+1].ctype ~= 11 and cells[y][x+1].ctype ~= -1 and cells[y][x+1].ctype ~= 14 then
					local oldcell = cells[y][x-1].ctype
					local oldrot = cells[y][x-1].rot
					local oldvars = {cells[y][x-1].lastvars[1],cells[y][x-1].lastvars[2],cells[y][x-1].lastvars[3]}
					cells[y][x-1].ctype = cells[y][x+1].ctype
					cells[y][x-1].rot = cells[y][x+1].rot
					cells[y][x-1].lastvars = {cells[y][x+1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
					cells[y][x+1].ctype = oldcell
					cells[y][x+1].rot = oldrot
					cells[y][x+1].lastvars = oldvars
				end
			end
		end
	end
	for x=1,width-2 do
		for y=1,height-2 do
			if cells[y][x].ctype == 14 and (cells[y][x].rot == 1 or cells[y][x].rot == 3) then
				if cells[y-1][x].ctype ~= 11 and cells[y-1][x].ctype ~= -1 and cells[y-1][x].ctype ~= 14 and cells[y+1][x].ctype ~= 11 and cells[y+1][x].ctype ~= -1 and cells[y+1][x].ctype ~= 14 then
					local oldcell = cells[y-1][x].ctype
					local oldrot = cells[y-1][x].rot
					local oldvars = {cells[y-1][x].lastvars[1],cells[y-1][x].lastvars[2],cells[y-1][x].lastvars[3]}
					cells[y-1][x].ctype = cells[y+1][x].ctype
					cells[y-1][x].rot = cells[y+1][x].rot
					cells[y-1][x].lastvars = {cells[y+1][x].lastvars[1],cells[y+1][x].lastvars[2],cells[y+1][x].lastvars[3]}
					cells[y+1][x].ctype = oldcell
					cells[y+1][x].rot = oldrot
					cells[y+1][x].lastvars = oldvars
				end
			end
		end
	end
end

local function DoGenerator(x,y,dir)
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
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
		if cells[cy][cx].ctype == 15 then
			local olddir = direction
			if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
				direction = 1
				addedrot = addedrot - (direction - olddir)
			elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
				direction = 0
				addedrot = addedrot - (direction - olddir)
			elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
				direction = 3
				addedrot = addedrot - (direction - olddir)
			elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
				direction = 2
				addedrot = addedrot - (direction - olddir)
			else
				break
			end
		else
			break
		end
	end 
	cells[cy][cx].testvar = "gen'd"
	local storedtype = cells[cy][cx].ctype
	local storedrot = (cells[cy][cx].rot+addedrot)%4
	local gennedrot = storedrot
	if storedtype ~= 0 then
		local lasttype = cells[cy][cx].ctype
		local lastrot = (cells[cy][cx].rot+addedrot)%4
		direction = dir
		cx = x
		cy = y
		addedrot = 0
		local totalforce = 1
		local pushingdiverger = false
		cells[cy][cx].updated = true
		repeat							--check for forces or blockages before doing movement
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			local checkedtype = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedtype) or cells[cy][cx].ctype
			local checkedrot = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedrot) or cells[cy][cx].rot
			if checkedtype == 1 then
				if not pushingdiverger then
					if checkedrot == direction then
						totalforce = totalforce + 1
					elseif checkedrot == (direction+2)%4 then
						totalforce = totalforce - 1
					end
				end
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
			or checkedtype == 5 and direction ~= checkedrot
			or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
			or checkedtype == 7 and direction == (checkedrot+2)%4 then
				totalforce = 0
			elseif checkedtype == 15 then
				local lastdir = direction
				if direction == 0 and checkedrot == 1 or direction == 2 and checkedrot == 0 then
					direction = 1
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 1 and checkedrot == 3 or direction == 3 and checkedrot == 0 then
					direction = 0
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 2 and checkedrot == 3 or direction == 0 and checkedrot == 2 then
					direction = 3
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 3 and checkedrot == 1 or direction == 1 and checkedrot == 2 then
					direction = 2
					addedrot = addedrot + (direction-lastdir)
				else
					pushingdiverger = true
					cells[cy][cx].projectedtype = lasttype
					cells[cy][cx].projectedrot = (lastrot+addedrot)%4
					lasttype = checkedtype
					lastrot = checkedrot
					addedrot = 0
				end
			elseif checkedtype == 20 or checkedtype == 21 then
				totalforce = totalforce - 1 
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			else
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			end
			cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
			if cells[cy][cx].crosses >= 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop
				totalforce = 0
			end
			cells[cy][cx].updatekey = updatekey
		until totalforce <= 0 or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
		--movement time
		cells[cy][cx].testvar = "end"
		if totalforce > 0 then
			local direction = dir
			local cx = x
			local cy = y
			local storedupdated = false
			local storedvars = {cx,cy,gennedrot}
			if storedtype == 19 then
				storedupdated = true
			else
				storedupdated = false
			end
			local addedrot = 0
			local reps = 0
			repeat
				reps = reps + 1
				if reps > 100000 then cells[cy][cx].ctype = 11 break end
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == 11 then
					love.audio.play(destroysound)
					break
				elseif cells[cy][cx].ctype == 12 then
					cells[cy][cx].ctype = 0
					love.audio.play(destroysound)
					break
				elseif cells[cy][cx].ctype == 23 then
					cells[cy][cx].ctype = 12
					love.audio.play(destroysound)
					break
				elseif cells[cy][cx].ctype == 15 then
					local olddir = direction
					if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
						direction = 1
						addedrot = addedrot + (direction - olddir)
					elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
						direction = 0
						addedrot = addedrot + (direction - olddir)
					elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
						direction = 3
						addedrot = addedrot + (direction - olddir)
					elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
						direction = 2
						addedrot = addedrot + (direction - olddir)
					else
						local oldtype = cells[cy][cx].ctype 
						local oldrot = cells[cy][cx].rot
						local oldupdated = cells[cy][cx].updated
						local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
						cells[cy][cx].ctype = storedtype
						cells[cy][cx].rot =  (storedrot + addedrot)%4
						cells[cy][cx].updated = storedupdated
						cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedupdated = oldupdated
						storedvars = oldvars
						addedrot = 0
					end
				else
					local oldtype = cells[cy][cx].ctype 
					local oldrot = cells[cy][cx].rot
					local oldupdated = cells[cy][cx].updated
					local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					cells[cy][cx].ctype = storedtype
					cells[cy][cx].rot =  (storedrot + addedrot)%4
					cells[cy][cx].updated = storedupdated
					cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedupdated = oldupdated
					storedvars = oldvars
					addedrot = 0
				end
			until storedtype == 0
		end
	end
end



local function DoTriple(x,y,dir)
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
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
		if cells[cy][cx].ctype == 15 then
			local olddir = direction
			if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
				direction = 1
				addedrot = addedrot - (direction - olddir)
			elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
				direction = 0
				addedrot = addedrot - (direction - olddir)
			elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
				direction = 3
				addedrot = addedrot - (direction - olddir)
			elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
				direction = 2
				addedrot = addedrot - (direction - olddir)
			else
				break
			end
		else
			break
		end
	end 
	cells[cy][cx].testvar = "gen'd"
	local storedtype = cells[cy][cx].ctype
	local storedrot = (cells[cy][cx].rot+addedrot)%4
	local gennedrot = storedrot
	DoTripleGen(cx,cy,addedrot,storedrot,gennedrot,dir,-1,x,y,storedtype)
	DoTripleGen(cx,cy,addedrot,storedrot,gennedrot,dir,0,x,y,storedtype)
	DoTripleGen(cx,cy,addedrot,storedrot,gennedrot,dir,1,x,y,storedtype)
end




function DoTripleGen(cx,cy,addedrot,storedrot,gennedrot,dir,side,x,y,storedtype)
	if storedtype ~= 0 then
		local lasttype = cells[cy][cx].ctype
		local lastrot = (cells[cy][cx].rot+addedrot)%4
		local direction
		if side == -1 then
			direction = (dir - 1)
			if direction == -1 then
				direction = 3
			end
		elseif side == 1 then
			direction = (dir + 1)
			if direction == 4 then
				direction = 0
			end
		else
			direction = dir
		end
		cx = x
		cy = y
		addedrot = 0
		local totalforce = 1
		local pushingdiverger = false
		cells[cy][cx].updated = true
		repeat							--check for forces or blockages before doing movement
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			local checkedtype = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedtype) or cells[cy][cx].ctype
			local checkedrot = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedrot) or cells[cy][cx].rot
			if checkedtype == 1 then
				if not pushingdiverger then
					if checkedrot == direction then
						totalforce = totalforce + 1
					elseif checkedrot == (direction+2)%4 then
						totalforce = totalforce - 1
					end
				end
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
			or checkedtype == 5 and direction ~= checkedrot
			or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
			or checkedtype == 7 and direction == (checkedrot+2)%4 then
				totalforce = 0
			elseif checkedtype == 15 then
				local lastdir = direction
				if direction == 0 and checkedrot == 1 or direction == 2 and checkedrot == 0 then
					direction = 1
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 1 and checkedrot == 3 or direction == 3 and checkedrot == 0 then
					direction = 0
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 2 and checkedrot == 3 or direction == 0 and checkedrot == 2 then
					direction = 3
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 3 and checkedrot == 1 or direction == 1 and checkedrot == 2 then
					direction = 2
					addedrot = addedrot + (direction-lastdir)
				else
					pushingdiverger = true
					cells[cy][cx].projectedtype = lasttype
					cells[cy][cx].projectedrot = (lastrot+addedrot)%4
					lasttype = checkedtype
					lastrot = checkedrot
					addedrot = 0
				end
			elseif checkedtype == 20 or checkedtype == 21 then
				totalforce = totalforce - 1 
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			else
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			end
			cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
			if cells[cy][cx].crosses >= 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop
				totalforce = 0
			end
			cells[cy][cx].updatekey = updatekey
		until totalforce <= 0 or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
		--movement time
		cells[cy][cx].testvar = "end"
		if totalforce > 0 then
			local direction = dir
			if side == -1 then
				direction = (dir - 1)
				if direction == -1 then
					direction = 3
				end
			elseif side == 1 then
				direction = (dir + 1)
				if direction == 4 then
					direction = 0
				end
			else
				direction = dir
			end
			local cx = x
			local cy = y
			local storedupdated = false
			local storedvars = {cx,cy,gennedrot}
			if storedtype == 19 then
				storedupdated = true
			else
				storedupdated = false
			end
			local addedrot = 0
			local reps = 0
			repeat
				reps = reps + 1
				if reps > 100000 then cells[cy][cx].ctype = 11 break end
				if direction == 0 then
					cx = cx + 1	
				elseif direction == 2 then
					cx = cx - 1
				elseif direction == 3 then
					cy = cy - 1
				elseif direction == 1 then
					cy = cy + 1
				end
				if cells[cy][cx].ctype == 11 then
					love.audio.play(destroysound)
					break
				elseif cells[cy][cx].ctype == 12 then
					cells[cy][cx].ctype = 0
					love.audio.play(destroysound)
					break
				elseif cells[cy][cx].ctype == 23 then
					cells[cy][cx].ctype = 12
					love.audio.play(destroysound)
					break
				elseif cells[cy][cx].ctype == 15 then
					local olddir = direction
					if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
						direction = 1
						addedrot = addedrot + (direction - olddir)
					elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
						direction = 0
						addedrot = addedrot + (direction - olddir)
					elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
						direction = 3
						addedrot = addedrot + (direction - olddir)
					elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
						direction = 2
						addedrot = addedrot + (direction - olddir)
					else
						local oldtype = cells[cy][cx].ctype 
						local oldrot = cells[cy][cx].rot
						local oldupdated = cells[cy][cx].updated
						local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
						cells[cy][cx].ctype = storedtype
						cells[cy][cx].rot =  (storedrot + addedrot)%4
						cells[cy][cx].updated = storedupdated
						cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedupdated = oldupdated
						storedvars = oldvars
						addedrot = 0
					end
				else
					local oldtype = cells[cy][cx].ctype 
					local oldrot = cells[cy][cx].rot
					local oldupdated = cells[cy][cx].updated
					local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					cells[cy][cx].ctype = storedtype
					cells[cy][cx].rot =  (storedrot + addedrot)%4
					cells[cy][cx].updated = storedupdated
					cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedupdated = oldupdated
					storedvars = oldvars
					addedrot = 0
				end
			until storedtype == 0
		end
	end
end

local function UpdateTriples()
	for y=height-2,1,-1 do
		for x=width-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 22 and cells[y][x].rot == 0 then
				DoTriple(x,y,0)
				updatekey = updatekey + 1
			end
		end
	end
	for y=1,height-2 do
		for x=1,width-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 22 and cells[y][x].rot == 2 then
				DoTriple(x,y,2)
				updatekey = updatekey + 1
			end
		end
	end
	for y=1,height-2 do
		for x=1,width-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 22 and cells[y][x].rot == 3 then
				DoTriple(x,y,3)
				updatekey = updatekey + 1
			end
		end
	end
	for y=height-2,1,-1 do
		for x=width-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 22 and cells[y][x].rot == 1 then
				DoTriple(x,y,1)
				updatekey = updatekey + 1
			end
		end
	end
end



local function UpdateGenerators()
	for y=height-2,1,-1 do
		for x=width-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 2 and cells[y][x].rot == 0 then
				DoGenerator(x,y,0)
				updatekey = updatekey + 1
			end
		end
	end
	for y=1,height-2 do
		for x=1,width-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 2 and cells[y][x].rot == 2 then
				DoGenerator(x,y,2)
				updatekey = updatekey + 1
			end
		end
	end
	for y=1,height-2 do
		for x=1,width-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 2 and cells[y][x].rot == 3 then
				DoGenerator(x,y,3)
				updatekey = updatekey + 1
			end
		end
	end
	for y=height-2,1,-1 do
		for x=width-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 2 and cells[y][x].rot == 1 then
				DoGenerator(x,y,1)
				updatekey = updatekey + 1
			end
		end
	end
end

local function UpdateMold()
	for y=1,height-2 do
		for x=1,width-2 do
			if cells[y][x].ctype == 19 and cells[y][x].updated then
				cells[y][x].ctype = 0
			end
		end
	end
end

local function UpdateRotators()
	for y=1,height-2 do
		for x=1,width-2 do
			if cells[y][x].ctype == 8 then
				cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
				cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
				cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
				cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
			elseif cells[y][x].ctype == 9 then
				cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
				cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
				cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
				cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
			elseif cells[y][x].ctype == 10 then
				cells[y][x-1].rot = (cells[y][x-1].rot - 2)%4
				cells[y][x+1].rot = (cells[y][x+1].rot - 2)%4
				cells[y-1][x].rot = (cells[y-1][x].rot - 2)%4
				cells[y+1][x].rot = (cells[y+1][x].rot - 2)%4
			end
		end
	end
end

local function UpdateGears()
	for y=1,height-2 do
		for x=1,width-2 do
			if cells[y][x].ctype == 17 then
				local jammed = false
				for i=0,8 do
					if i ~= 4 then
						cx = i%3-1
						cy = math.floor(i/3)-1
						if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 then
							jammed = true
						end
					end
				end
				if not jammed then
					local storedtype = 0
					local storedrot = 0
					local storedvars = {cells[y][x+1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
					local oldtype = cells[y][x-1].ctype 
					local oldrot = cells[y][x-1].rot
					local oldvars = {cells[y][x-1].lastvars[1],cells[y][x-1].lastvars[2],cells[y][x-1].lastvars[3]}
					cells[y][x-1].ctype = storedtype
					cells[y][x-1].rot = (storedrot+1)%4
					cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					for i=-1,1 do
						oldtype = cells[y-1][x+i].ctype 
						oldrot = cells[y-1][x+i].rot
						oldvars = {cells[y-1][x+i].lastvars[1],cells[y-1][x+i].lastvars[2],cells[y-1][x+i].lastvars[3]}
						cells[y-1][x+i].ctype = storedtype
						cells[y-1][x+i].rot = (storedrot+(i+1)%2)%4
						cells[y-1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					end
					oldtype = cells[y][x+1].ctype 
					oldrot = cells[y][x+1].rot
					oldvars = {cells[y][x-1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
					cells[y][x+1].ctype = storedtype
					cells[y][x+1].rot = (storedrot+1)%4
					cells[y][x+1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					for i=1,-1,-1 do
						oldtype = cells[y+1][x+i].ctype 
						oldrot = cells[y+1][x+i].rot
						oldvars = {cells[y+1][x+i].lastvars[1],cells[y+1][x+i].lastvars[2],cells[y+1][x+i].lastvars[3]}
						cells[y+1][x+i].ctype = storedtype
						cells[y+1][x+i].rot = (storedrot+(i+1)%2)%4
						cells[y+1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					end
					cells[y][x-1].ctype = storedtype
					cells[y][x-1].rot = (storedrot+1)%4
					cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
				end
			end
		end
	end
	for y=1,height-2 do
		for x=width-2,1,-1 do
			if cells[y][x].ctype == 18 then
				local jammed = false
				for i=0,8 do
					if i ~= 4 then
						cx = i%3-1
						cy = math.floor(i/3)-1
						if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 then
							jammed = true
						end
					end
				end
				if not jammed then
					local storedtype = 0
					local storedrot = 0
					local storedvars = {cells[y][x+1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
					local oldtype = cells[y][x-1].ctype 
					local oldrot = cells[y][x-1].rot
					local oldvars = {cells[y][x-1].lastvars[1],cells[y][x-1].lastvars[2],cells[y][x-1].lastvars[3]}
					cells[y][x-1].ctype = storedtype
					cells[y][x-1].rot = (storedrot-1)%4
					cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					for i=-1,1 do
						oldtype = cells[y+1][x+i].ctype 
						oldrot = cells[y+1][x+i].rot
						oldvars = {cells[y+1][x+i].lastvars[1],cells[y+1][x+i].lastvars[2],cells[y+1][x+i].lastvars[3]}
						cells[y+1][x+i].ctype = storedtype
						cells[y+1][x+i].rot = (storedrot-(i+1)%2)%4
						cells[y+1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					end
					oldtype = cells[y][x+1].ctype 
					oldrot = cells[y][x+1].rot
					oldvars = {cells[y][x-1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
					cells[y][x+1].ctype = storedtype
					cells[y][x+1].rot = (storedrot-1)%4
					cells[y][x+1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					for i=1,-1,-1 do
						oldtype = cells[y-1][x+i].ctype 
						oldrot = cells[y-1][x+i].rot
						oldvars = {cells[y-1][x+i].lastvars[1],cells[y-1][x+i].lastvars[2],cells[y-1][x+i].lastvars[3]}
						cells[y-1][x+i].ctype = storedtype
						cells[y-1][x+i].rot = (storedrot-(i+1)%2)%4
						cells[y-1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
					end
					cells[y][x-1].ctype = storedtype
					cells[y][x-1].rot = (storedrot-1)%4
					cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
				end
			end
		end
	end
end

local function UpdateRedirectors()
	for y=1,height-2 do
		for x=1,width-2 do
			if cells[y][x].ctype == 16 then
				if cells[y][x-1].ctype ~= 16 then cells[y][x-1].rot = cells[y][x].rot end
				if cells[y][x+1].ctype ~= 16 then cells[y][x+1].rot = cells[y][x].rot end
				if cells[y-1][x].ctype ~= 16 then cells[y-1][x].rot = cells[y][x].rot end
				if cells[y+1][x].ctype ~= 16 then cells[y+1][x].rot = cells[y][x].rot end
			end
		end
	end
end

local function DoRepulser(x,y,dir)
	local direction = dir
	local cx = x
	local cy = y
	local totalforce = 1
	local storedtype = 0
	local storedrot = 0
	local addedrot = 0
	local pushingdiverger = false
	local lasttype = 0
	local lastrot = 0
	cells[cy][cx].updated = true
	repeat							--check for forces or blockages before doing movement
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		local checkedtype = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedtype) or cells[cy][cx].ctype
		local checkedrot = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedrot) or cells[cy][cx].rot
		if checkedtype == 1 or checkedtype == 13 then
			if not pushingdiverger then
				if checkedrot == direction then
					totalforce = totalforce + 1
				elseif checkedrot == (direction+2)%4 then
					totalforce = totalforce - 1
				end
				if checkedrot%2 == direction%2 then
					cells[cy][cx].updated = true
				end
			end
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
		or checkedtype == 5 and direction ~= checkedrot
		or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
		or checkedtype == 7 and direction == (checkedrot+2)%4 or checkedtype == 20 then
			totalforce = 0
		elseif checkedtype == 15 then
			local lastdir = direction
			if direction == 0 and checkedrot == 1 or direction == 2 and checkedrot == 0 then
				direction = 1
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 1 and checkedrot == 3 or direction == 3 and checkedrot == 0 then
				direction = 0
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 2 and checkedrot == 3 or direction == 0 and checkedrot == 2 then
				direction = 3
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 3 and checkedrot == 1 or direction == 1 and checkedrot == 2 then
				direction = 2
				addedrot = addedrot + (direction-lastdir)
			else
				pushingdiverger = true
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			end
		elseif checkedtype == 21 then
			totalforce = totalforce - 1
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		else
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		end
		cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
		if cells[cy][cx].crosses == 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop, and a bad one at that; the chain will stop in case of this emergency.
			totalforce = 0
		end
		cells[cy][cx].updatekey = updatekey
	until totalforce <= 0 or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
	--movement time
	cells[cy][cx].testvar = "end"
	if totalforce > 0 then
		local direction = dir
		local cx = x
		local cy = y
		local storedtype = 0
		local storedrot = 0
		local storedupdated = false
		local storedvars = {cx,cy,dir}
		local addedrot = 0
		repeat
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 11 then
				love.audio.play(destroysound)
				break
			elseif cells[cy][cx].ctype == 12 then
				cells[cy][cx].ctype = 0
				love.audio.play(destroysound)
				break
			elseif cells[cy][cx].ctype == 23 then
				cells[cy][cx].ctype = 12
				love.audio.play(destroysound)
				break
			elseif cells[cy][cx].ctype == 15 then
				local olddir = direction
				if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
					direction = 1
					addedrot = addedrot + (direction - olddir)
				elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
					direction = 0
					addedrot = addedrot + (direction - olddir)
				elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
					direction = 3
					addedrot = addedrot + (direction - olddir)
				elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
					direction = 2
					addedrot = addedrot + (direction - olddir)
				else
					local oldtype = cells[cy][cx].ctype 
					local oldrot = cells[cy][cx].rot
					local oldupdated = cells[cy][cx].updated
					local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					cells[cy][cx].ctype = storedtype
					cells[cy][cx].rot =  (storedrot + addedrot)%4
					cells[cy][cx].updated = storedupdated
					cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedupdated = oldupdated
					storedvars = oldvars
					addedrot = 0
				end
			else
				local oldtype = cells[cy][cx].ctype 
				local oldrot = cells[cy][cx].rot
				local oldupdated = cells[cy][cx].updated
				local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
				cells[cy][cx].ctype = storedtype
				cells[cy][cx].rot =  (storedrot + addedrot)%4
				cells[cy][cx].updated = storedupdated
				cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
				storedtype = oldtype
				storedrot = oldrot
				storedupdated = oldupdated
				storedvars = oldvars
				addedrot = 0
			end
		until storedtype == 0
	end
end

local function UpdateRepulsers()
	for y=1,height-2 do
		for x=1,width-2 do
			if cells[y][x].ctype == 20 then
				DoRepulser(x,y,0)
				updatekey = updatekey + 1
				DoRepulser(x,y,2)
				updatekey = updatekey + 1
				DoRepulser(x,y,3)
				updatekey = updatekey + 1
				DoRepulser(x,y,1)
				updatekey = updatekey + 1
			end
		end
	end
end

local function DoPuller(x,y,dir)
	local direction = dir
	local cx = x
	local cy = y
	local blocked = false
	while true do
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].ctype == 0 or cells[cy][cx].ctype == 11 or cells[cy][cx].ctype == 12 or cells[cy][cx].ctype == 23 then
			break
		elseif cells[cy][cx].ctype == 15 then
			if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
				direction = 1
			elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
				direction = 0
			elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
				direction = 3
			elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
				direction = 2
			else
				blocked = true
				break
			end
		else
			blocked = true
			break
		end
	end
	cells[cy][cx].testvar = "front"
	if not blocked then
		local frontcx = cx
		local frontcy = cy
		local frontdir = direction
		local totalforce = 0
		local storedtype = 0
		local storedrot = 0
		local addedrot = 0
		local lasttype = 0
		local lastrot = 0
		cells[cy][cx].updated = true
		local lastcx = frontcx
		local lastcy = frontcy
		repeat							--check for forces or blockages before doing movement
			if direction == 0 then
				cx = cx - 1	
			elseif direction == 2 then
				cx = cx + 1
			elseif direction == 3 then
				cy = cy + 1
			elseif direction == 1 then
				cy = cy - 1
			end
			local checkedtype = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedtype) or cells[cy][cx].ctype
			local checkedrot = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedrot) or cells[cy][cx].rot
			if checkedtype == 1 or checkedtype == 13 then
				if checkedrot == direction then
					totalforce = totalforce + 1
				elseif checkedrot == (direction+2)%4 then
					totalforce = totalforce - 1
				end
				if checkedrot%2 == direction%2 then
					cells[cy][cx].updated = true
				end
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
			or checkedtype == 5 and direction ~= checkedrot
			or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
			or checkedtype == 7 and direction == (checkedrot+2)%4 then
				totalforce = 0
			elseif checkedtype == 15 then
				local lastdir = direction
				if direction == 0 and checkedrot == 3 or direction == 2 and checkedrot == 2 then
					direction = 1
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 1 and checkedrot == 1 or direction == 3 and checkedrot == 2 then
					direction = 0
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 2 and checkedrot == 1 or direction == 0 and checkedrot == 0 then
					direction = 3
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 3 and checkedrot == 3 or direction == 1 and checkedrot == 0 then
					direction = 2
					addedrot = addedrot + (direction-lastdir)
				else
					break												--look, to be honest i've had enough of dealing with weird diverger bs and its pretty much never useful to pull anything PAST a diverger
				end
			elseif checkedtype == 20 or checkedtype == 21 then
				totalforce = totalforce - 1
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			else
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			end
			cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
			if cells[cy][cx].crosses == 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop, and a bad one at that; the chain will stop in case of this emergency.
				totalforce = 0
			end
			cells[cy][cx].updatekey = updatekey
		until (totalforce <= 0 and checkedtype ~= 15) or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
		--movement time
		cells[cy][cx].testvar = "end"
		if totalforce > 0 then
			updatekey = updatekey + 1	--i swear it's needed
			local cx = frontcx
			local cy = frontcy
			local direction = frontdir
			local addedrot = 0
			local lastcx = frontcx
			local lastcy = frontcy
			repeat
				if direction == 0 then
					cx = cx - 1	
				elseif direction == 2 then
					cx = cx + 1
				elseif direction == 3 then
					cy = cy + 1
				elseif direction == 1 then
					cy = cy - 1
				end
				if cells[lastcy][lastcx].ctype == 11 then
					love.audio.play(destroysound)
					lastcx = cx
					lastcy = cy
				elseif cells[lastcy][lastcx].ctype == 12 then
					love.audio.play(destroysound)
					cells[lastcy][lastcx].ctype = 0
					lastcx = cx
					lastcy = cy
				elseif cells[lastcy][lastcx].ctype == 23 then
					love.audio.play(destroysound)
					cells[lastcy][lastcx].ctype = 12
					lastcx = cx
					lastcy = cy
				elseif cells[cy][cx].ctype == 11 or cells[cy][cx].ctype == 12 then
					cells[lastcy][lastcx].ctype = 0
					break
				elseif cells[cy][cx].ctype == 23  then
					cells[lastcy][lastcx].ctype = 12
					break
				elseif cells[cy][cx].ctype == 15 then
					local olddir = direction
					if direction == 0 and cells[cy][cx].rot == 3 or direction == 2 and cells[cy][cx].rot == 2 then
						direction = 1
						addedrot = addedrot + (direction-olddir)
					elseif direction == 1 and cells[cy][cx].rot == 1 or direction == 3 and cells[cy][cx].rot == 2 then
						direction = 0
						addedrot = addedrot + (direction-olddir)
					elseif direction == 2 and cells[cy][cx].rot == 1 or direction == 0 and cells[cy][cx].rot == 0 then
						direction = 3
						addedrot = addedrot + (direction-olddir)
					elseif direction == 3 and cells[cy][cx].rot == 3 or direction == 1 and cells[cy][cx].rot == 0 then
						direction = 2
						addedrot = addedrot + (direction-olddir)
					else
						cells[lastcy][lastcx].ctype = cells[cy][cx].ctype 
						cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)
						cells[lastcy][lastcx].updated = cells[cy][cx].updated
						cells[lastcy][lastcx].lastvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
						cells[cy][cx].ctype = 0
						break
					end
				elseif (cells[cy][cx].updatekey == updatekey and cells[cy][cx].pulled) or false then	--while it would make sense to let it pull stuff that's already been pulled, i cant allow it because of weird infinite loops that would otherwise function how you'd expect
					cells[lastcy][lastcx].ctype = 0
					cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)
					cells[lastcy][lastcx].updated = cells[cy][cx].updated
					cells[lastcy][lastcx].lastvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					break
				else
					cells[lastcy][lastcx].ctype = cells[cy][cx].ctype 
					cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)
					cells[lastcy][lastcx].updated = cells[cy][cx].updated
					cells[lastcy][lastcx].lastvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					addedrot = 0
					lastcx = cx
					lastcy = cy
				end
				cells[lastcy][lastcx].pulled = true
				cells[lastcy][lastcx].updatekey = updatekey
			until cells[cy][cx].ctype == 0
			cells[cy][cx].testvar = "moveend"
		end
	end
end

local function UpdatePullers()
	for x=width-2,1,-1 do
		for y=height-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 0 then
				DoPuller(x,y,0)
				updatekey = updatekey + 1
			end
		end
	end
	for x=1,width-2 do
		for y=1,height-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 2 then
				DoPuller(x,y,2)
				updatekey = updatekey + 1
			end
		end
	end
	for y=1,height-2 do
		for x=1,width-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 3 then
				DoPuller(x,y,3)
				updatekey = updatekey + 1
			end
		end
	end
	for y=height-2,1,-1 do
		for x=width-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 1 then
				DoPuller(x,y,1)
				updatekey = updatekey + 1
			end
		end
	end
end

local function DoMover(x,y,dir)
	local direction = dir
	local cx = x
	local cy = y
	local totalforce = 1
	local addedrot = 0
	local pushingdiverger = false
	local lasttype = 1
	local lastrot = dir
	cells[cy][cx].updated = true
	repeat							--check for forces or blockages before doing movement
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		local checkedtype = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedtype) or cells[cy][cx].ctype
		local checkedrot = (cells[cy][cx].updatekey == updatekey and cells[cy][cx].projectedrot) or cells[cy][cx].rot
		if checkedtype == 1 then
			if not pushingdiverger then
				if checkedrot == direction then
					totalforce = totalforce + 1
				elseif checkedrot == (direction+2)%4 then
					totalforce = totalforce - 1
				end
				if checkedrot%2 == direction%2 then
					cells[cy][cx].updated = true
				end
			end
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
		or checkedtype == 5 and direction ~= checkedrot
		or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
		or checkedtype == 7 and direction == (checkedrot+2)%4 then
			totalforce = 0
		elseif checkedtype == 15 then
			local lastdir = direction
			if direction == 0 and checkedrot == 1 or direction == 2 and checkedrot == 0 then
				direction = 1
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 1 and checkedrot == 3 or direction == 3 and checkedrot == 0 then
				direction = 0
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 2 and checkedrot == 3 or direction == 0 and checkedrot == 2 then
				direction = 3
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 3 and checkedrot == 1 or direction == 1 and checkedrot == 2 then
				direction = 2
				addedrot = addedrot + (direction-lastdir)
			else
				pushingdiverger = true
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			end
		elseif checkedtype == 20 or checkedtype == 21 then
			totalforce = totalforce - 1
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		else
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		end
		cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
		if cells[cy][cx].crosses >= 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop, and a bad one at that; the chain will stop in case of this emergency.
			totalforce = 0
		end
		if cy == y and cx == x and direction == dir then	--let infinite loops that dont push against themselves work
			break
		end
		cells[cy][cx].updatekey = updatekey
	until totalforce <= 0 or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
	--movement time
	cells[cy][cx].testvar = "end"
	if totalforce > 0 then
		local direction = dir
		if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
		if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
		local storedtype = 0
		local storedrot = 0
		local storedupdated = false
		local storedvars = {cx,cy,dir}
		local addedrot = 0
		local reps = 0
		repeat
			reps = reps + 1 --ignore the first time that cx=x and cy=y
			if reps == 999999 then cells[cy][cx].testvar = "HEY STUPID, INFINITE LOOP THAT YOU DIDNT DETECT WITH UR DUMB DUMB CODE THIS MESSAGE IS REALLY LONG SO YOU CAN EASILY SEE IT FROM AFAR" break end
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 11 then
				love.audio.play(destroysound)
				break
			elseif cells[cy][cx].ctype == 12 then
				love.audio.play(destroysound)
				cells[cy][cx].ctype = 0
				break
			elseif cells[cy][cx].ctype == 23 then
				love.audio.play(destroysound)
				cells[cy][cx].ctype = 12
				break
			elseif cells[cy][cx].ctype == 15 then
				local olddir = direction
				if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
					direction = 1
					addedrot = addedrot + (direction - olddir)
				elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
					direction = 0
					addedrot = addedrot + (direction - olddir)
				elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
					direction = 3
					addedrot = addedrot + (direction - olddir)
				elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
					direction = 2
					addedrot = addedrot + (direction - olddir)
				else
					local oldtype = cells[cy][cx].ctype 
					local oldrot = cells[cy][cx].rot
					local oldupdated = cells[cy][cx].updated
					local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					cells[cy][cx].ctype = storedtype
					cells[cy][cx].rot =  (storedrot + addedrot)%4
					cells[cy][cx].updated = storedupdated
					cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedupdated = oldupdated
					storedvars = oldvars
					addedrot = 0
				end
			else
				local oldtype = cells[cy][cx].ctype 
				local oldrot = cells[cy][cx].rot
				local oldupdated = cells[cy][cx].updated
				local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
				cells[cy][cx].ctype = storedtype
				cells[cy][cx].rot =  (storedrot + addedrot)%4
				cells[cy][cx].updated = storedupdated
				cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
				storedtype = oldtype
				storedrot = oldrot
				storedupdated = oldupdated
				storedvars = oldvars
				addedrot = 0
			end
		until storedtype == 0 or cx == x and cy == y and direction == dir and reps > 1
	end
end

local function UpdateMovers()
	for x=1,width-2 do
		for y=1,height-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 0 then
				DoMover(x,y,0)
				updatekey = updatekey + 1
			end
		end
	end
	for x=width-2,1,-1 do
		for y=height-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 2 then
				DoMover(x,y,2)
				updatekey = updatekey + 1
			end
		end
	end
	for y=height-2,1,-1 do
		for x=width-2,1,-1 do
			if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 3 then
				DoMover(x,y,3)
				updatekey = updatekey + 1
			end
		end
	end
	for y=1,height-2 do
		for x=1,width-2 do
			if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 1 then
				DoMover(x,y,1)
				updatekey = updatekey + 1
			end
		end
	end
	--things will already be reset in next tick by love.update()
end

local function DoTick()
	for y=0,height-1 do
		for x=0,width-1 do
			cells[y][x].updated = false
			cells[y][x].testvar = ""
		end
	end
	UpdateMirrors()
	UpdateGenerators()
	UpdateTriples()
	UpdateMold()
	UpdateRotators()
	UpdateGears()
	UpdateRedirectors()
	UpdateRepulsers()
	UpdatePullers()
	UpdateMovers()
end

function love.load()
	love.window.setTitle("CelLua Machine B-Mod")
	love.window.setIcon(love.image.newImageData("icon.png"))
	bgsprites = love.graphics.newSpriteBatch(tex[0])
	for y=0,height-1 do
		initial[y] = {}
		cells[y] = {}
		placeables[y] = {}
		for x=0,width-1 do 
			initial[y][x] = {}
			cells[y][x] = {}
			placeables[y][x] = {}
			if y == 0 or x == 0 or y == height-1 or x == width-1 then
				initial[y][x].ctype = -1
			else
				initial[y][x].ctype = 0
			end
			initial[y][x].rot = 0
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			placeables[y][x] = false
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
end

function love.update(dt)
	delta = dt
	if inmenu then
		if love.mouse.isDown(1) then
			local x,y = love.mouse.getX(),love.mouse.getY()
			if x >= 145 and x <= 655 then	--give some extra area on the left and right so you can set it to the highest and lowest value more easily
				x = math.min(math.max(x,150),650)	--then cap it so nothing breaks
				if y >= 200 and y <= 210 then
					delay = (x-150)/500
				elseif y >= 250 and y <= 260 then
					tpu = round((x-150)/(500/9))+1
				elseif y >= 300 and y <= 310 then
					newwidth = round((x-150)/(500/499))+1
				elseif y >= 350 and y <= 360 then
					newheight = round((x-150)/(500/499))+1
				end
			end
		end
		itime = math.min(itime + dt,delay)
	else
		if not paused then
			dtime = dtime + dt
			if updatekey > 10000000000 then updatekey = 0 end --juuuust in case
			if dtime > delay then
				for y=0,height-1 do
					for x=0,width-1 do
						cells[y][x].lastvars = {x,y,cells[y][x].rot}
					end
				end
				for i=1,tpu do
					DoTick()
				end
				dtime = 0
				itime = 0
			end
		end
		itime = math.min(itime + dt,delay)
		if love.keyboard.isDown("lctrl") then
			if love.keyboard.isDown("w") then offy = offy - 16 end
			if love.keyboard.isDown("s") then offy = offy + 16 end
			if love.keyboard.isDown("a") then offx = offx - 16 end
			if love.keyboard.isDown("d") then offx = offx + 16 end
		else
			if love.keyboard.isDown("w") then offy = offy - 8 end
			if love.keyboard.isDown("s") then offy = offy + 8 end
			if love.keyboard.isDown("a") then offx = offx - 8 end
			if love.keyboard.isDown("d") then offx = offx + 8 end
		end
		if love.mouse.isDown(1) and placecells then
			local x = math.floor((love.mouse.getX()+offx)/zoom)
			local y = math.floor((love.mouse.getY()+offy)/zoom)
			if x > 0 and y > 0 and x < width-1 and y < height-1 then
				if currentstate == -2 then
					placeables[y][x] = true
				else
					cells[y][x].ctype = currentstate
					cells[y][x].rot = currentrot
					cells[y][x].lastvars = {x,y,currentrot}
					if isinitial then
						initial[y][x].ctype = currentstate
						initial[y][x].rot = currentrot
						initial[y][x].lastvars = {x,y,currentrot}
					end
				end
			end
		end
		if love.mouse.isDown(2) and placecells then
			local x = math.floor((love.mouse.getX()+offx)/zoom)
			local y = math.floor((love.mouse.getY()+offy)/zoom)
			if x > 0 and y > 0 and x < width-1 and y < height-1 then
				if currentstate == -2 then
					placeables[y][x] = false
				else
					cells[y][x].ctype = 0
					cells[y][x].rot = 0
					if isinitial then
						initial[y][x].ctype = 0
						initial[y][x].rot = 0
					end
				end
			end
		end
	end
end

function love.draw()
	love.graphics.setColor(1/8,1/8,1/8)
	love.graphics.rectangle("fill",-10,-10,999,999)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(bgsprites,math.floor(zoom-offx+zoom/2),math.floor(zoom-offy+zoom/2),0,zoom/20,zoom/20,10,10)
	for y=math.max(math.floor(offy/zoom),0),math.min(math.floor((offy+600)/zoom),height-1) do
		for x=math.max(math.floor(offx/zoom),0),width-1 do
			if placeables[y][x] then 
				love.graphics.draw(tex[-2],math.floor(x*zoom-offx+zoom/2),math.floor(y*zoom-offy+zoom/2),0,zoom/20,zoom/20,10,10)
			end
		end
	end
	for y=math.max(math.floor(offy/zoom),0),math.min(math.floor((offy+600)/zoom),height-1) do
		for x=math.max(math.floor(offx/zoom),0),width-1 do
			if cells[y][x].ctype ~= 0 then 
				love.graphics.draw(tex[cells[y][x].ctype],math.floor(lerp(cells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(cells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),lerp(cells[y][x].lastvars[3],cells[y][x].lastvars[3]+((cells[y][x].rot-cells[y][x].lastvars[3]+2)%4-2),itime/delay)*math.pi/2,zoom/20,zoom/20,10,10)
			end
			if dodebug then love.graphics.print(tostring(cells[y][x].testvar),x*zoom-offx+zoom/2,y*zoom-offy+zoom/2) end
		end
	end
	for i=0,15 do
		if currentstate == i-2 then love.graphics.setColor(1,1,1,0.5) else love.graphics.setColor(1,1,1,0.25) end
		love.graphics.draw(tex[i-2],25+(775-25)*i/15,575,currentrot*math.pi/2,2,2,10,10)
	end
	for i=14,23 do
		if currentstate == i then love.graphics.setColor(1,1,1,0.5) else love.graphics.setColor(1,1,1,0.25) end
		love.graphics.draw(tex[i],25+(775-25)*(i-14)/15,525,currentrot*math.pi/2,2,2,10,10)
	end
	if paused then
		love.graphics.setColor(0.5,0.5,0.5,0.75)
		love.graphics.rectangle("fill",5,5,10,40)
		love.graphics.rectangle("fill",23,5,10,40)
		if isinitial then
			love.graphics.setColor(1,1,1,0.75)
			love.graphics.print("INITIAL",5,50,0,2,2)
		end
	end
	local x = love.mouse.getX()
	local y = love.mouse.getY()
	if inmenu then
		love.graphics.setColor(0.5,0.5,0.5,0.5)
		love.graphics.rectangle("fill",100,75,600,450)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("this is the menu",300,120,0,2,2)
		love.graphics.print("CelLua Machine v0.1.0",330,90,0,1,1)
		love.graphics.print("by KyYay",365,105,0,1,1)
		love.graphics.print("Update delay: "..string.sub(delay,1,4).."s",150,175,0,1,1)
		love.graphics.print("Ticks per update: "..tpu,150,225,0,1,1)
		love.graphics.print("Width (upon clearing): "..newwidth,150,275,0,1,1)
		love.graphics.print("Height (upon clearing): "..newheight,150,325,0,1,1)
		love.graphics.print("Debug (Can cause lag!)",275,378,0,1,1)
		love.graphics.print("Fancy Graphix",475,378,0,1,1)
		love.graphics.setColor(1/4,1/4,1/4,1)
		love.graphics.rectangle("fill",150,200,500,10)
		love.graphics.rectangle("fill",150,250,500,10)
		love.graphics.rectangle("fill",150,300,500,10)
		love.graphics.rectangle("fill",150,350,500,10)
		love.graphics.rectangle("fill",250,375,20,20)
		love.graphics.rectangle("fill",450,375,20,20)
		love.graphics.setColor(1/2,1/2,1/2,1)
		love.graphics.rectangle("fill",lerp(149,649,(delay)/1,true),200,2,10)
		love.graphics.rectangle("fill",lerp(149,649,(tpu-1)/9,true),250,2,10)
		love.graphics.rectangle("fill",lerp(149,649,(newwidth-1)/499,true),300,2,10)
		love.graphics.rectangle("fill",lerp(149,649,(newheight-1)/499,true),350,2,10)
		if dodebug then love.graphics.polygon("fill",{255,378 ,252,380 ,265,393 ,268,390}) end
		if dodebug then love.graphics.polygon("fill",{265,378 ,268,380 ,255,393 ,252,390}) end
		if interpolate then love.graphics.polygon("fill",{455,378 ,452,380 ,465,393 ,468,390}) end
		if interpolate then love.graphics.polygon("fill",{465,378 ,468,380 ,455,393 ,452,390}) end
		--if dodebug then love.graphics.polygon("fill",{267,385 ,264,382 ,258,394 ,255,391}) end
		if x > 170 and y > 420 and x < 230 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Close menu\n     (Esc)",165,480,0,1,1) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[1],200,450,0,3,3,10,10)
		if x > 270 and y > 420 and x < 330 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Restart level\n   (Ctrl+R)",265,480,0,1,1) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[10],300,450,0,3,3,10,10)
		if x > 370 and y > 420 and x < 430 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Clear level",369,480,0,1,1) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[11],400,450,0,3,3,10,10)
		if x > 470 and y > 420 and x < 530 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Save level\n (Ctrl+S also it doesnt work yet)",470,480,0,1,1) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[2],500,450,math.pi*1.5,3,3,10,10)
		if x > 570 and y > 420 and x < 630 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Load level\n (V3 only)",570,480,0,1,1)  else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[16],600,450,math.pi*0.5,3,3,10,10)
	end
	if showinstructions or inmenu then
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("WASD = Move\n(Ctrl to speed up)\n\nQ/E = Rotate\n\nEsc = Menu\n\nZ/C = Change cell type\nor just click the hud\n\nSpace = Pause\n\nF = Advance one tick\n\nUp/down or mousewheel =\nZoom in/out",10,360,0,1,1)
	end
	love.graphics.setColor(1,1,1,0.5)
	love.graphics.print("FPS: ".. 1/delta,10,10)
end

function love.mousepressed(x,y,b)
	if y > 420 and y < 480 then
		if inmenu and x > 170 and x < 230 then
			inmenu = false
			placecells = false
		elseif inmenu and x > 270 and x < 330 then
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].ctype = initial[y][x].ctype
					cells[y][x].rot = initial[y][x].rot
					cells[y][x].lastvars = {x,y,cells[y][x].rot}
					cells[y][x].testvar = ""
				end
			end
			inmenu = false
			placecells = false
			paused = true
			isinitial = true
			love.audio.play(beep)
		elseif inmenu and x > 370 and x < 430 then
			width = newwidth+2
			height = newheight+2
			love.load()
			inmenu = false
			placecells = false
			paused = true
			isinitial = true
			love.audio.play(beep)
		elseif inmenu and x > 570 and x < 630 then
			if string.sub(love.system.getClipboardText(),1,2) == "V3" then
				DecodeV3(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
			else
				love.audio.play(destroysound)
			end
		end
	elseif y > 555 and y < 595 then
		for i=0,15 do
			if x > 5+(775-25)*i/15 and x < 45+(775-25)*i/15 then
				currentstate = i-2
				placecells = false
			end
		end
	elseif y > 505 and y < 545 then
		for i=14,23 do
			if x > 5+(775-25)*(i-14)/15 and x < 45+(775-25)*(i-14)/15 then
				currentstate = i
				placecells = false
			end
		end
	elseif inmenu and y >= 375 and y <= 395 then
		if x >= 250 and x <= 270 then
			dodebug = not dodebug
			love.audio.play(beep)
		elseif x >= 450 and x <= 470 then
			interpolate = not interpolate
			love.audio.play(beep)
		end
	end
end

function love.mousereleased()
	placecells = true
end

function love.keypressed(key)
	if key == "q" then
		currentrot = (currentrot - 1)%4
	elseif key == "e" then
		currentrot = (currentrot + 1)%4
	elseif key == "z" then
		currentstate = math.max(currentstate-1,-1)
	elseif key == "c" then
		currentstate = math.min(currentstate+1,23)
	elseif key == "up" then
		if zoom < 160 then
			zoom = zoom*2
			offx = offx*2 + 400
			offy = offy*2 + 300
		end
	elseif key == "down" then
		if zoom > 5 then
			offx = (offx-400)*0.5
			offy = (offy-300)*0.5
			zoom = zoom*0.5
		end
	elseif key == "space" then
		paused = not paused
		isinitial = false
	elseif key == "f" then
		for y=0,height-1 do
			for x=0,width-1 do
				cells[y][x].lastvars = {x,y,cells[y][x].rot}
			end
		end
		DoTick()
		dtime = 0
		itime = 0
		isinitial = false
	elseif key == "escape" then
		inmenu = not inmenu
		showinstructions = false
	elseif key == "r" then
		if love.keyboard.isDown("lctrl") then
			paused = true
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].ctype = initial[y][x].ctype
					cells[y][x].rot = initial[y][x].rot
					cells[y][x].lastvars = {x,y,cells[y][x].rot}
					cells[y][x].testvar = ""
				end
			end
			isinitial = true
		end
	end
end

function love.wheelmoved(x,y)
	if y > 0 then
		for i=1,y do
			if zoom < 160 then
				zoom = zoom*2
				offx = offx*2 + 400
				offy = offy*2 + 300
			end
		end
	elseif y < 0 then
		for i=-1,y,-1 do
			if zoom > 4 then
				offx = (offx-400)*0.5
				offy = (offy-300)*0.5
				zoom = zoom*0.5
			end
		end
	end
end