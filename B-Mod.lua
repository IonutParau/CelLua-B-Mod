require("bmod/gates")
require("bmod/electricstuffs")
require("bmod/leds")
require("bmod/fastcells")
require("bmod/diag")
local halfdelay = false
local delay4 = 0
local birdstate = 0
local bluescreen = love.graphics.newImage("bmod/bluscren.png")
local bluescreenenabled = false
local bluescreendelay = 0
local isghostinitial = true
local ghostcells = {}
local ghostinitial = {}
local ver = "2.0.0"

local function clonetable(table)
	local newtable = {}
	for k,v in pairs(table) do
		newtable[k] = v
	end
	return newtable
end
local name = "B-Mod"

local function deepclonetable(table)
	local newtable = {}
	for k,v in pairs(table) do
		if type(v) == "table" then v = deepclonetable(v) end
		newtable[k] = v
	end
	return newtable
end

for y=0,height-1 do
	ghostinitial[y] = {}
	ghostcells[y] = {}
	for x=0,width-1 do 
		ghostinitial[y][x] = {}
		ghostcells[y][x] = {}
		if y == 0 or x == 0 or y == height-1 or x == width-1 then
			ghostinitial[y][x] = {
				ctype = -1,
				rot = 0
			}
		else
			ghostinitial[y][x].ctype = 0
			ghostinitial[y][x].rot = 0
		end
		ghostcells[y][x].ctype = ghostinitial[y][x].ctype
		ghostcells[y][x].rot = ghostinitial[y][x].rot
		ghostcells[y][x].lastvars = {x,y,ghostcells[y][x].rot}
		ghostcells[y][x].testvar = ""
	end
end

triplegenID,triplesplitterID,splitterID,tunnelID,trashholeID,slowmoverID,slowpullerID,slowadvancerID,doublegenID,elecoffID,eleconID,redelecoffID,redeleconID,batteryID,repeaterID = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
andID,orID,xorID,xnorID,norID,nandID,notID = 0,0,0,0,0,0,0
crosswireID,elecgenID,elecmoverID,elecrotcwID,elecrotccwID = 0,0,0,0,0
bombID,minibombID = 0,0
mayomoveID,mayobottleID = 0,0
redID,greenID,blueID,magentID,yellID,cyaID = 0,0,0,0,0,0
redoffID,greenoffID,blueoffID,magentoffID,yelloffID,cyaoffID = 0,0,0,0,0,0
diamoverID = 0
slowermoverID = 0
slowerpullerID = 0
sloweradvancerID = 0
deadbirdID = 0
bluescreenID = 0
randomizerID = 0
slowmayobottleID, slowmayomoveID = 0,0
pushmakerID = 0

local ver2 = "2.0.0"
local name2 = "B-Mod"
local function init()
	if not checkVersion("B-Mod",ver2) then error("stop being dumbass") end
	if not (name == name2) then error("stop being dumbass") end
    triplegenID = addCell("BM 3gen","bmod/triplegenerator.png",function() return true end)
    bombID = addCell("BM bom","bmod/bomb.png",function() return true end,"enemy")
    minibombID = addCell("BM minibom","bmod/minibomb.png",function() return true end,"enemy")
    triplesplitterID = addCell("BM 3split","bmod/triplesplitter.png",function() return true end)
    splitterID = addCell("BM split","bmod/splitter.png",function() return true end)
    tunnelID = addCell("BM tunnel","bmod/tunnel.png",function() return true end)
    trashholeID = addCell("BM trashhole","bmod/trashhole.png",function() return true end)
	slowmoverID = addCell("BM slowpush","bmod/slowmover.png",function() return true end,"mover")
    slowpullerID = addCell("BM slowpull","bmod/slowpuller.png",function() return true end,"mover")
	slowadvancerID = addCell("BM slowpullsh","bmod/slowadvancer.png",function() return true end,"mover")
	doublegenID = addCell("BM 2gen","bmod/doublegenerator.png",function() return true end)
	elecoffID = addCell("BM elecoff","bmod/elecoff.png",function() return true end)
	eleconID = addCell("BM elecon","bmod/elecon.png",function() return true end,"normal",true)
	redelecoffID = addCell("BM redelecoff","bmod/redelecoff.png",function() return true end)
	redeleconID = addCell("BM redelecon","bmod/redelecon.png",function() return true end,"normal",true)
	batteryID = addCell("BM battery","bmod/battery.png",function() return true end)
	repeaterID = addCell("BM rep","bmod/repeater.png",function() return true end)
	andID = addCell("BM and","bmod/andgate.png",function() return true end)
	orID = addCell("BM or","bmod/orgate.png",function() return true end)
	xorID = addCell("BM xor","bmod/xorgate.png",function() return true end)
	xnorID = addCell("BM xnor","bmod/xnorgate.png",function() return true end)
	norID = addCell("BM nor","bmod/norgate.png",function() return true end)
	nandID = addCell("BM nand","bmod/nandgate.png",function() return true end)
	notID = addCell("BM not","bmod/notgate.png",function() return true end)
	crosswireID = addCell("BM wirecross","bmod/crosswire.png",function() return true end)
	elecgenID = addCell("BM elecgen","bmod/elecgen.png",function() return true end)
	elecmoveID = addCell("BM elecmove","bmod/elecmover.png",function() return true end,"mover")
	elecrotcwID = addCell("BM elecrot","bmod/elecrotcw.png",function() return true end)
	elecrotccwID = addCell("BM elecrotccw","bmod/elecrotccw.png",function() return true end)
	mayobottleID = addCell("BM mayobottle","bmod/mayobottle.png",function() return true end)
	mayomoveID = addCell("BM mayomove","bmod/mayomover.png",function() return true end,"mover")
	slowmayobottleID = addCell("BM slowmayobottle","bmod/slowmayobottle.png",function() return true end)
	slowmayomoveID = addCell("BM slowmayomove","bmod/slowmayomover.png",function() return true end,"mover")
	doleds()
	if not checkVersion("B-Mod",ver2) then error("stop being dumbass") end
	if not (name == name2) then error("stop being dumbass") end
	birdID = addCell("BM bird","bmod/bird.png",function() return true end)
	adddiamover()
	addfastcells()
	adddiamovers()
	slowermoverID = addCell("BM slowermove","bmod/slowermover.png",function() return true end,"mover")
	slowerpullerID = addCell("BM slowerpull","bmod/slowerpuller.png",function() return true end,"mover")
	sloweradvancerID = addCell("BM slowerpullsh","bmod/sloweradvancer.png",function() return true end,"mover")
	deadbirdID = addCell("BM deadbird","bmod/deadbird.png",function() return true end,"normal",true)
	bluescreenID = addCell("BM bluescreen","bmod/bluescreenofdoom.png",function() return true end)
	randomizerID = addCell("BM randomizer","bmod/randomizer.png",function() return true end)
	ghostmoverID = addCell("BM ghostmover","bmod/ghostmover.png",function() return true end,"mover")
	ghostcellID = addCell("BM ghostcell","bmod/ghostcell.png",function() return true end)
	pushmakerID = addCell("BM pushmaker","bmod/pushmaker.png",function() return true end)
end

function DoMayoGenerator(x,y,dir,gendir,istwist,dontupdate)
	if not checkVersion("B-Mod",ver2) then error("stop being dumbass") end
	if not (name == name2) then error("stop being dumbass") end
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
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
	addedrot = addedrot + (gendir-dir)
	PushCell(x,y,gendir,false,1,mayomoveID,gendir,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],gendir},cells[cy][cx].protected,false)
end

function DoSlowMayoGenerator(x,y,dir,gendir,istwist,dontupdate)
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
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
	addedrot = addedrot + (gendir-dir)
	PushCell(x,y,gendir,false,1,slowmayomoveID,gendir,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],gendir},cells[cy][cx].protected,false)
end

function DoPushMaker(x,y,dir,gendir,istwist,dontupdate)
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
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
	addedrot = addedrot + (gendir-dir)
	PushCell(x,y,gendir,false,1,3,gendir,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],gendir},cells[cy][cx].protected,false)
end

function SpreadRedElec(y,x)
	local elec = cells[y][x].elec
	if not elec then cells[y][x].elec = 0 elec = 0 end
	if elec >= 1 then
		if cells[y][x-1].ctype == redelecoffID then
			if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
			cells[y][x-1].ctype = redeleconID
			SetChunk(x-1,y,redeleconID)
			cells[y][x-1].elec = (elec-1)
			SpreadRedElec(y,x-1)
		elseif cells[y][x-1].ctype == redeleconID then
			if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
			if cells[y][x-1].elec < elec then
				cells[y][x-1].elec = (elec-1)
				SpreadRedElec(y,x-1)
			end
		end
		if cells[y][x+1].ctype == redelecoffID then
			if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
			cells[y][x+1].ctype = redeleconID
			SetChunk(x+1,y,redeleconID)
			cells[y][x+1].elec = (elec-1)
			SpreadRedElec(y,x+1)
		elseif cells[y][x+1].ctype == redeleconID then
			if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
			if cells[y][x+1].elec < elec then
				cells[y][x+1].elec = (elec-1)
				SpreadRedElec(y,x+1)
			end
		end
		if cells[y-1][x].ctype == redelecoffID then
			if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
			cells[y-1][x].ctype = redeleconID
			SetChunk(x,y-1,redeleconID)
			cells[y-1][x].elec = (elec-1)
			SpreadRedElec(y-1,x)
		elseif cells[y-1][x].ctype == redeleconID then
			if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
			if cells[y-1][x].elec < elec then
				cells[y-1][x].elec = (elec-1)
				SpreadRedElec(y-1,x)
			end
		end
		if cells[y+1][x].ctype == redelecoffID then
			if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
			cells[y+1][x].ctype = redeleconID
			SetChunk(x,y+1,redeleconID)
			cells[y+1][x].elec = (elec-1)
			SpreadRedElec(y+1,x)
		elseif cells[y+1][x].ctype == redeleconID then
			if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
			if cells[y+1][x].elec < elec then
				cells[y+1][x].elec = (elec-1)
				SpreadRedElec(y+1,x)
			end
		end
	end
end

function SpreadElec(y,x)
	local elec = cells[y][x].elec
	if not elec then cells[y][x].elec = 0 elec = 0 end
	if elec >= 1 then
		if cells[y][x-1].ctype == elecoffID then
			if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
			cells[y][x-1].ctype = eleconID
			SetChunk(x-1,y,eleconID)
			cells[y][x-1].elec = (elec-1)
			SpreadElec(y,x-1)
		elseif cells[y][x-1].ctype == eleconID then
			if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
			if cells[y][x-1].elec < elec then
				cells[y][x-1].elec = (elec-1)
				SpreadElec(y,x-1)
			end
		end
		if cells[y][x+1].ctype == elecoffID then
			if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
			cells[y][x+1].ctype = eleconID
			SetChunk(x+1,y,eleconID)
			cells[y][x+1].elec = (elec-1)
			SpreadElec(y,x+1)
		elseif cells[y][x+1].ctype == eleconID then
			if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
			if cells[y][x+1].elec < elec then
				cells[y][x+1].elec = (elec-1)
				SpreadElec(y,x+1)
			end
		end
		if cells[y-1][x].ctype == elecoffID then
			if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
			cells[y-1][x].ctype = eleconID
			SetChunk(x,y-1,eleconID)
			cells[y-1][x].elec = (elec-1)
			SpreadElec(y-1,x)
		elseif cells[y-1][x].ctype == eleconID then
			if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
			if cells[y-1][x].elec < elec then
				cells[y-1][x].elec = (elec-1)
				SpreadElec(y-1,x)
			end
		end
		if cells[y+1][x].ctype == elecoffID then
			if not cells[y+1][x].ctype then cells[y+1][x].ctype = 0 end
			cells[y+1][x].ctype = eleconID
			SetChunk(x,y+1,eleconID)
			cells[y+1][x].elec = (elec-1)
			SpreadElec(y+1,x)
		elseif cells[y+1][x].ctype == eleconID then
			if not cells[y+1][x].ctype then cells[y+1][x].ctype = 0 end
			if cells[y+1][x].elec < elec then
				cells[y+1][x].elec = (elec-1)
				SpreadElec(y+1,x)
			end
		end
	end
end

local function onCellDraw(id,x,y)
	love.graphics.setColor(1,1,1,0.5)
	if ghostcells[y][x].ctype ~= 0 and ghostcells[y][x].ctype ~= -1 then love.graphics.draw(tex[ghostcells[y][x].ctype],math.floor(lerp(ghostcells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(ghostcells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),ghostcells[y][x].rot*math.pi/2,zoom/texsize[ghostcells[y][x].ctype].w,zoom/texsize[ghostcells[y][x].ctype].h,texsize[ghostcells[y][x].ctype].w2,texsize[ghostcells[y][x].ctype].h2) end
	love.graphics.setColor(1,1,1,1)
end

local function customdraw()
	--[[
	love.graphics.setColor(1,1,1,0.5)
	for y=0,height-1 do
		for x=0,width-1 do
			local newpos = calculateScreenPosition(x,y)
			if ghostcells[y][x].ctype ~= 0 and ghostcells[y][x].ctype ~= -1 then love.graphics.draw(tex[ghostcells[y][x].ctype],math.floor(lerp(ghostcells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(ghostcells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),ghostcells[y][x].rot*math.pi/2,zoom/texsize[ghostcells[y][x].ctype].w,zoom/texsize[ghostcells[y][x].ctype].h,texsize[ghostcells[y][x].ctype].w2,texsize[ghostcells[y][x].ctype].h2) end
		end
	end
	]]
	--[[
		volume = 0
		love.audio.setVolume(volume)
	]]
	love.graphics.setColor(1,1,1,1)
	if inmenu then
		love.graphics.print("B-Mod V2.0.0 Beta\nby lieve_blendi",550*winxm,90*winym,0,winxm,winym)
	end
	if bluescreenenabled == true then
		love.graphics.draw(bluescreen,0,0,0,(bluescreen:getWidth()/800)*winxm,(bluescreen:getHeight()/600)*winym)
		love.audio.setVolume(0)
		if bluescreendelay <= 0 then
			bluescreenenabled = false
			love.audio.setVolume(volume)
		else
			bluescreendelay = bluescreendelay - love.timer.getDelta()
		end
	end
end

local function DoRepeater(x,y)
	local dir = cells[y][x].rot
	local cx,cy
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if cells[cy] and cells[cy][cx] then
		if not cells[cy][cx].elec then cells[cy][cx].elec = 0 end
		if cells[cy][cx].elec > 0 then
			local ccx,ccy
			if dir == 0 then ccx = x + 1 elseif dir == 2 then ccx = x - 1 else ccx = x end
			if dir == 1 then ccy = y + 1 elseif dir == 3 then ccy = y - 1 else ccy = y end
			if cells[ccy] and cells[ccy][ccx] then
				if (cells[ccy][ccx].ctype == eleconID) or (cells[ccy][ccx].ctype == elecoffID) or (cells[ccy][ccx].ctype == redeleconID) or (cells[ccy][ccx].ctype == redelecoffID) then
					cells[ccy][ccx].elec = 11
					if cells[ccy][ccx].ctype == elecoffID then cells[ccy][ccx].ctype = eleconID SetChunk(ccx,ccy,eleconID) SpreadElec(ccx,ccy) end
					if cells[ccy][ccx].ctype == redelecoffID then cells[ccy][ccx].ctype = redeleconID SetChunk(ccx,ccy,redeleconID) SpreadRedElec(ccx,ccy) end
				end
			end
		end
	end
end

local function DoTripleGenerate(gendir,istwist,addedrot,x,y,cx,cy)
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 then
		if istwist then
			local gentype,genrot = cells[cy][cx].ctype,cells[cy][cx].rot+addedrot
			if cells[y][x].rot%2 == 0 then
				if gentype == 8 then gentype = 9 
				elseif gentype == 9 then gentype = 8 
				elseif gentype == 17 then gentype = 18
				elseif gentype == 18 then gentype = 17 
				elseif gentype == 25 then gentype = 26 genrot = (-genrot)%4
				elseif gentype == 26 then gentype = 25 genrot = (-genrot)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) and genrot%2 == 0 then genrot = (genrot + 1)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) then genrot = (genrot - 1)%4
				elseif (gentype == 15 or gentype == 56) and genrot%2 == 0 then genrot = (genrot - 1)%4
				elseif (gentype == 15 or gentype == 56) then genrot = (genrot + 1)%4
				else genrot = (-genrot)%4 end
			else
				if gentype == 8 then gentype = 9 
				elseif gentype == 9 then gentype = 8 
				elseif gentype == 17 then gentype = 18
				elseif gentype == 18 then gentype = 17 
				elseif gentype == 25 then gentype = 26 genrot = (-genrot + 2)%4
				elseif gentype == 26 then gentype = 25 genrot = (-genrot + 2)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) and genrot%2 == 0 then genrot = (genrot - 1)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) then genrot = (genrot + 1)%4
				elseif (gentype == 15 or gentype == 56) and genrot%2 == 0 then genrot = (genrot + 1)%4
				elseif (gentype == 15 or gentype == 56) then genrot = (genrot - 1)%4
				else genrot = (-genrot + 2)%4 end
			end
			PushCell(x,y,gendir,false,1,gentype,genrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],genrot},cells[cy][cx].protected,false)
		else
			PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
		end
	end
end

local function DoTripleGenerator(x,y,dir,gendir,istwist,dontupdate,type)
	local gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
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
	addedrot = addedrot + (gendir-dir)
	cells[cy][cx].testvar = "gen'd"
	if type == 3 then
		DoTripleGenerate((gendir-1)%4,istwist,addedrot,x,y,cx,cy)
		DoTripleGenerate(gendir,istwist,addedrot,x,y,cx,cy)
		DoTripleGenerate((gendir+1)%4,istwist,addedrot,x,y,cx,cy)
	elseif type == 2 then
		DoTripleGenerate((gendir-1)%4,istwist,addedrot,x,y,cx,cy)
		DoTripleGenerate((gendir+1)%4,istwist,addedrot,x,y,cx,cy)
	end
end

local function trashhole(x,y)
    local delete
    for cy = (y-1), (y+1),1 do
        for cx = (x-1), (x+1),1 do
            if cy > 0 then
                if cx > 0 then
                    if cy < (height) then
                        if cx < (width) then
                            if (cells[cy][cx].ctype ~= -1) and cells[cy][cx].ctype ~= 40 and cells[cy][cx].ctype ~= -1  and cells[cy][cx].ctype ~= 11  and cells[cy][cx].ctype ~= 50 then
                                if cells[cy][cx].ctype ~= 0 then
                                    if cells[cy][cx].ctype ~= trashholeID then
                                        cells[cy][cx].ctype = 0
                                        delete = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if delete then
        playSound("destroy.wav")
    end
end

local function DoSplitter(x,y,dir,gendir,istwist,type,dontupdate)
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
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
	addedrot = addedrot + (gendir-dir)
	cells[cy][cx].testvar = "gen'd"
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and cells[cy][cx].ctype ~= -1  and cells[cy][cx].ctype ~= 11  and cells[cy][cx].ctype ~= 50 and (cells[cy][cx].ctype <= #cellsForIDManagement or canPushCell(cx,cy,x,y,"deleting generator")) then
		if type == 2 then
			if PushCell(x,y,(gendir-1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false) then
				PushCell(x,y,(gendir+1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
				cells[cy][cx].ctype = 0
			elseif PushCell(x,y,(gendir+1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false) then
				cells[cy][cx].ctype = 0
			end
		elseif type == 1 then
			if PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false) then
				cells[cy][cx].ctype = 0
			end
		elseif type == 3 then
			if PushCell(x,y,(gendir-1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false) then
				PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
				PushCell(x,y,(gendir+1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
				cells[cy][cx].ctype = 0
			elseif PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false) then
				PushCell(x,y,(gendir+1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
				cells[cy][cx].ctype = 0
			elseif PushCell(x,y,(gendir+1)%4,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false) then
				cells[cy][cx].ctype = 0
			end
		end
	end
end

local function UpdateElec(x,y)
	if not cells[y][x].elec then cells[y][x].elec = 0 end
	if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
	if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
	if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
	if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
			if halfdelay == true then
				if cells[y][x].elec > 0 then
					cells[y][x].elec = cells[y][x].elec - 1
				end
			end
			if cells[y][x].ctype == eleconID or cells[y][x].ctype == elecoffID then
				cells[y][x].testvar = cells[y][x].elec
				if cells[y][x].elec <= 0 then
					cells[y][x].ctype = elecoffID
					SetChunk(x,y,elecoffID)
					cells[y][x].elec = 0
				end
				local elec = cells[y][x].elec
				if elec >= 1 then
					if cells[y][x-1].ctype == elecoffID then
						cells[y][x-1].ctype = eleconID
						SetChunk(x-1,y,eleconID)
						cells[y][x-1].elec = (elec-1)
						SpreadElec(y,x-1)
					elseif cells[y][x-1].ctype == eleconID then
						if cells[y][x-1].elec < elec then
							cells[y][x-1].elec = (elec-1)
							SpreadElec(y,x-1)
						end
					end
					if cells[y][x+1].ctype == elecoffID then
						cells[y][x+1].ctype = eleconID
						SetChunk(x,y,eleconID)
						cells[y][x+1].elec = (elec-1)
						SpreadElec(y,x+1)
					elseif cells[y][x+1].ctype == eleconID then
						if cells[y][x+1].elec < elec then
							cells[y][x+1].elec = (elec-1)
							SpreadElec(y,x+1)
						end
					end
					if cells[y-1][x].ctype == elecoffID then
						cells[y-1][x].ctype = eleconID
						SetChunk(x,y-1,eleconID)
						cells[y-1][x].elec = (elec-1)
						SpreadElec(y-1,x)
					elseif cells[y-1][x].ctype == eleconID then
						if cells[y-1][x].elec < elec then
							cells[y-1][x].elec = (elec-1)
							SpreadElec(y-1,x)
						end
					end
					if cells[y+1][x].ctype == elecoffID then
						cells[y+1][x].ctype = eleconID
						SetChunk(x,y+1,eleconID)
						cells[y+1][x].elec = (elec-1)
						SpreadElec(y+1,x)
					elseif cells[y+1][x].ctype == eleconID then
						if cells[y+1][x].elec < elec then
							cells[y+1][x].elec = (elec-1)
							SpreadElec(y+1,x)
						end
					end
		end
	end
end

local function UpdateRedElec(x,y)
	if not cells[y][x].elec then cells[y][x].elec = 0 end
	if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
	if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
	if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
	if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
			if halfdelay == true then
				if cells[y][x].elec > 0 then
					cells[y][x].elec = cells[y][x].elec - 1
				end
			end
			if cells[y][x].ctype == redeleconID or cells[y][x].ctype == redelecoffID then
				cells[y][x].testvar = cells[y][x].elec
				if cells[y][x].elec <= 0 then
					cells[y][x].ctype = redelecoffID
					SetChunk(x,y,redelecoffID)
					cells[y][x].elec = 0
				end
				local elec = cells[y][x].elec
				if elec >= 1 then
					if cells[y][x-1].ctype == redelecoffID then
						cells[y][x-1].ctype = redeleconID
						SetChunk(x-1,y,redeleconID)
						cells[y][x-1].elec = (elec-1)
						SpreadRedElec(y,x-1)
					elseif cells[y][x-1].ctype == redeleconID then
						if cells[y][x-1].elec < elec then
							cells[y][x-1].elec = (elec-1)
							SpreadRedElec(y,x-1)
						end
					end
					if cells[y][x+1].ctype == redelecoffID then
						cells[y][x+1].ctype = redeleconID
						SetChunk(x+1,y,redeleconID)
						cells[y][x+1].elec = (elec-1)
						SpreadRedElec(y,x+1)
					elseif cells[y][x+1].ctype == redeleconID then
						if cells[y][x+1].elec < elec then
							cells[y][x+1].elec = (elec-1)
							SpreadRedElec(y,x+1)
						end
					end
					if cells[y-1][x].ctype == redelecoffID then
						cells[y-1][x].ctype = redeleconID
						SetChunk(x,y-1,redeleconID)
						cells[y-1][x].elec = (elec-1)
						SpreadRedElec(y-1,x)
					elseif cells[y-1][x].ctype == redeleconID then
						if cells[y-1][x].elec < elec then
							cells[y-1][x].elec = (elec-1)
							SpreadRedElec(y-1,x)
						end
					end
					if cells[y+1][x].ctype == redelecoffID then
						cells[y+1][x].ctype = redeleconID
						SetChunk(x,y+1,redeleconID)
						cells[y+1][x].elec = (elec-1)
						SpreadRedElec(y+1,x)
					elseif cells[y+1][x].ctype == redeleconID then
						if cells[y+1][x].elec < elec then
							cells[y+1][x].elec = (elec-1)
							SpreadRedElec(y+1,x)
						end
					end
				end
			end
end

local function crosswire(x,y)
	local elec
	local elec2
	local cx = x
	local cy = y
	cx = cx + 1
	elec = cells[cy][cx].elec
	if not elec then cells[cy][cx].elec = 0 elec = 0 end
	cx = x
	cx = cx - 1
	elec2 = cells[cy][cx].elec
	if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end
	if elec > elec2 then
		if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
			cells[cy][cx].elec = (elec-1)
			if cells[cy][cx].ctype == redelecoffID or cells[cy][cx].ctype == redeleconID then
				cells[cy][cx].ctype = redeleconID
				SetChunk(cx,cy,redeleconID)
				SpreadRedElec(cy,cx)
			else
				cells[cy][cx].ctype = eleconID
				SetChunk(cx,cy,eleconID)
				SpreadElec(cy,cx)
			end
		end
	elseif elec2 > elec then
		if cells[cy][cx+2].ctype == eleconID or cells[cy][cx+2].ctype == elecoffID or cells[cy][cx+2].ctype == redeleconID or cells[cy][cx+2].ctype == redelecoffID then
			cells[cy][cx+2].elec = (elec2-1)
			if cells[cy][cx+2].ctype == redeleconID or cells[cy][cx+2].ctype == redelecoffID then
				cells[cy][cx+2].ctype = redeleconID
				SetChunk(cx+2,cy,redeleconID)
				SpreadRedElec(cy,cx+2)
			else
				cells[cy][cx+2].ctype = eleconID
				SetChunk(cx+2,cy,eleconID)
				SpreadElec(cy,cx+2)
			end
		end
	end

	cx = x
	cy = y
	cy = cy + 1
	elec = cells[cy][cx].elec
	if not elec then cells[cy][cx].elec = 0 elec = 0 end
	cy = y
	cy = cy - 1
	elec2 = cells[cy][cx].elec
	if not elec2 then cells[cy][cx].elec = 0 elec2 = 0 end
	if elec > elec2 then
		if cells[cy][cx].ctype == eleconID or cells[cy][cx].ctype == elecoffID or cells[cy][cx].ctype == redeleconID or cells[cy][cx].ctype == redelecoffID then
			cells[cy][cx].elec = (elec-1)
			if cells[cy][cx].ctype == redelecoffID or cells[cy][cx].ctype == redeleconID then
				cells[cy][cx].ctype = redeleconID
				SetChunk(cx,cy,redeleconID)
				SpreadRedElec(cy,cx)
			else
				cells[cy][cx].ctype = eleconID
				SetChunk(cx,cy,eleconID)
				SpreadElec(cy,cx)
			end
		end
	elseif elec2 > elec then
		if cells[cy+2][cx].ctype == eleconID or cells[cy+2][cx].ctype == elecoffID or cells[cy+2][cx].ctype == redeleconID or cells[cy+2][cx].ctype == redelecoffID then
			cells[cy+2][cx].elec = (elec2-1)
			if cells[cy+2][cx].ctype == redeleconID or cells[cy+2][cx].ctype == redelecoffID then
				cells[cy+2][cx].ctype = redeleconID
				SetChunk(cx,cy+2,redeleconID)
				SpreadRedElec(cy+2,cx)
			else
				cells[cy+2][cx].ctype = eleconID
				SetChunk(cx,cy+2,eleconID)
				SpreadElec(cy+2,cx)
			end
		end
	end
end

local function UpdateBatteries(x,y)
	if not cells[y][x+1].elec then cells[y][x+1].elec = 0 end
	if not cells[y][x-1].elec then cells[y][x-1].elec = 0 end
	if not cells[y+1][x].elec then cells[y+1][x].elec = 0 end
	if not cells[y-1][x].elec then cells[y-1][x].elec = 0 end
				cells[y][x].updated = true
				if cells[y][x-1].ctype == elecoffID or cells[y][x-1].ctype == eleconID then
					cells[y][x-1].ctype = eleconID
					SetChunk(x-1,y,eleconID)
					cells[y][x-1].elec = 11
					SpreadElec(y,x-1)
				end
				if cells[y][x+1].ctype == elecoffID or cells[y][x+1].ctype == eleconID then
					cells[y][x+1].ctype = eleconID
					SetChunk(x+1,y,eleconID)
					cells[y][x+1].elec = 11
					SpreadElec(y,x+1)
				end
				if cells[y-1][x].ctype == elecoffID or cells[y-1][x].ctype == eleconID then
					cells[y-1][x].ctype = eleconID
					SetChunk(x,y-1,eleconID)
					cells[y-1][x].elec = 11
					SpreadElec(y-1,x)
				end
				if cells[y+1][x].ctype == elecoffID or cells[y+1][x].ctype == eleconID then
					cells[y+1][x].ctype = eleconID
					SetChunk(x,y+1,eleconID)
					cells[y+1][x].elec = 11
					SpreadElec(y+1,x)
				end

				--red
				if cells[y][x-1].ctype == redelecoffID or cells[y][x-1].ctype == redeleconID then
					cells[y][x-1].ctype = redeleconID
					SetChunk(x-1,y,redeleconID)
					cells[y][x-1].elec = 11
					SpreadRedElec(y,x-1)
				end
				if cells[y][x+1].ctype == redelecoffID or cells[y][x+1].ctype == redeleconID then
					cells[y][x+1].ctype = redeleconID
					SetChunk(x+1,y,redeleconID)
					cells[y][x+1].elec = 11
					SpreadRedElec(y,x+1)
				end
				if cells[y-1][x].ctype == redelecoffID or cells[y-1][x].ctype == redeleconID then
					cells[y-1][x].ctype = redeleconID
					SetChunk(x,y-1,redeleconID)
					cells[y-1][x].elec = 11
					SpreadRedElec(y-1,x)
				end
				if cells[y+1][x].ctype == redelecoffID or cells[y+1][x].ctype == redeleconID then
					cells[y+1][x].ctype = redeleconID
					SetChunk(x,y+1,redeleconID)
					cells[y+1][x].elec = 11
					SpreadRedElec(y+1,x)
				end
end

local function tick()
	halfdelay = not halfdelay
	birdstate = (birdstate+1)%4
	delay4 = (delay4+1)%4
	for y=0,height-1 do
		for x=0,width-1 do
			ghostcells[y][x].updated = false
			ghostcells[y][x].lastvars = {x,y,ghostcells[y][x].rot}
		end
	end
	local cellbackup = clonetable(cells)
	cells = clonetable(ghostcells)
	for y=0,height-1 do
		for x=0,width-1 do
			if cells[y][x].ctype == ghostmoverID and cells[y][x].updated == false then
				cells[y][x].updated = true
				local dir = cells[y][x].rot
				cells[y][x].updated = true
				local cx
				local cy
				if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
				if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
				PushCell(cx,cy,dir,true,0)	--it'll come across itself as it moves and get 1 totalforce
			end
		end
	end
	ghostcells = clonetable(cells)
	cells = clonetable(cellbackup)
end

function DoForceMover(x,y,dir)
	cells[y][x].updated = true
	local cx
	local cy
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if PushCell(cx,cy,dir,true,1) then	--for stuff that doesnt work like a normal mover
		return true
	else
		return false
	end
end

local function doBird(x,y,dir,state)
	if dir == 0 then
		if state == 0 then
			if not DoForceMover(x,y,dir) then
				cells[y][x].ctype = deadbirdID
			end
		elseif state == 1 then
			DoForceMover(x,y,(dir-1)%4)
		elseif state == 2 then
			if not DoForceMover(x,y,dir) then
				cells[y][x].ctype = deadbirdID
			end
		elseif state == 3 then
			DoForceMover(x,y,(dir+1)%4)
		end
	elseif dir == 2 then
		if state == 0 then
			if not DoForceMover(x,y,dir) then
				cells[y][x].ctype = deadbirdID
			end
		elseif state == 1 then
			DoForceMover(x,y,(dir+1)%4)
		elseif state == 2 then
			DoForceMover(x,y,dir)
		elseif state == 3 then
			if not DoForceMover(x,y,(dir-1)%4) then
				cells[y][x].ctype = deadbirdID
			end
		end
	else
		if not DoForceMover(x,y,dir) then
			cells[y][x].ctype = deadbirdID
		end
	end
	SetChunk(x,y,deadbirdID)
end

local function DoRandomizer(x,y,dir)
	local type = listorder[math.random(1,#listorder)]
	while type == -2 or type == 0 do
		type = listorder[math.random(1,#listorder)]
	end
	cells[y][x].ctype = type
	SetChunk(x,y,type)
end

local function update(id,x,y,dir)
    if id == triplegenID then
        DoTripleGenerator(x,y,dir,dir,false,false,3)
    elseif id == triplesplitterID then
        DoSplitter(x,y,dir,dir,cells[y][x].ctype == 39,3,cells[y][x].ctype == 22)
    elseif id == splitterID then
        DoSplitter(x,y,dir,dir,cells[y][x].ctype == 39,2,cells[y][x].ctype == 22)
    elseif id == tunnelID then
        DoSplitter(x,y,dir,dir,cells[y][x].ctype == 39,1,cells[y][x].ctype == 22)
    elseif id == trashholeID then
		trashhole(x,y)
	elseif id == slowadvancerID then
		if halfdelay then
			local cx
			local cy
			if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
			if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
			if PushCell(cx,cy,dir,true,0) and cells[y][x].ctype == 0 then	--this is why i made pushcell return whether movement was a success or not
				PullCell(x,y,dir,true,1,true,true,true)
			end
		end
	elseif id == slowmoverID then
		if halfdelay then
			local cx
			local cy
			if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
			if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
			PushCell(cx,cy,dir,true,0)	--it'll come across itself as it moves and get 1 totalforce
		end
	elseif id == slowpullerID then
		if halfdelay then
			cells[y][x].updated = true
			PullCell(x,y,dir)
		end
	elseif id == doublegenID then
		DoTripleGenerator(x,y,dir,dir,false,false,2)
	elseif (id == elecoffID) or (id == eleconID) then
		UpdateElec(x,y)
		--cells[y][x].testvar = tostring(elecoffID)..tostring(eleconID)
	elseif (id == redelecoffID) or (id == redeleconID) then
		UpdateRedElec(x,y)
		--cells[y][x].testvar = tostring(redelecoffID)..tostring(redeleconID)
    elseif id == batteryID then
		UpdateBatteries(x,y)
	elseif id == repeaterID then
		DoRepeater(x,y)
	elseif id == andID then
		andgate(x,y,dir)
	elseif id == orID then
		orgate(x,y,dir)
	elseif id == xorID then
		xorgate(x,y,dir)
	elseif id == xnorID then
		xnorgate(x,y,dir)
	elseif id == norID then
		norgate(x,y,dir)
	elseif id == nandID then
		nandgate(x,y,dir)
	elseif id == notID then
		notgate(x,y,dir)
	elseif id == crosswireID then
		crosswire(x,y)
	elseif id == elecgenID then
		elecgen(x,y,dir)
	elseif id == elecmoveID then
		elecmover(x,y,dir)
	elseif id == elecrotccwID then
		elecrot("ccw",x,y,dir)
	elseif id == elecrotcwID then
		elecrot("cw",x,y,dir)
	elseif id == mayobottleID then
		if halfdelay then
            DoMayoGenerator(x,y,dir,dir,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
        end
	elseif id == mayomoveID then
		DoMover(x,y,dir)
	elseif id == slowmayobottleID then
		if halfdelay then
            DoSlowMayoGenerator(x,y,dir,dir,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
        end
	elseif id == slowmayomoveID then
		if halfdelay then
			DoMover(x,y,dir)
		end
	elseif id == redID or id == redoffID then
		DoLed("red",x,y)
	elseif id == greenID or id == greenoffID then
		DoLed("green",x,y)
	elseif id == blueID or id == blueoffID then
		DoLed("blue",x,y)
	elseif id == magentID or id == magentoffID then
		DoLed("magenta",x,y)
	elseif id == yellID or id == yelloffID then
		DoLed("yellow",x,y)
	elseif id == cyaID or id == cyaoffID then
		DoLed("cyan",x,y)
	elseif id == birdID then
		doBird(x,y,dir,birdstate)
	elseif id == diamoverID then
		DoForceDiaMover(x,y,dir)
	elseif id == fastmoverID then
		doFastMover(x,y,dir)
	elseif id == fastpullerID then
		doFastPuller(x,y,dir)
	elseif id == fastadvancerID then
		doFastAdvancer(x,y,dir)
	elseif id == slowdiamoverID then
		if halfdelay then
			DoForceDiaMover(x,y,dir)
		end
	elseif id == fastdiamoverID then
		DoForceFastDiaMover(x,y,dir)
	elseif id == slowermoverID then
		if delay4 == 0 then
			DoMover(x,y,dir)
		end
	elseif id == slowerpullerID then
		if delay4 == 0 then
			PullCell(x,y,dir)
		end
	elseif id == sloweradvancerID then
		if delay4 == 0 then
			DoAdvancer(x,y,dir)
		end
	elseif id == fastermoverID then
		doSpecificMover(x,y,dir,4)
	elseif id == fasterpullerID then
		doSpecificPuller(x,y,dir,4)
	--elseif id == fasteradvancerID then
	--	doSpecificAdvancer(x,y,dir,4)
	elseif id == deadbirdID then
		DoForceMover(x,y,1)
	elseif id == bluescreenID then
		cells[y][x].ctype = 0
		bluescreenenabled = true
		bluescreendelay = 1
	elseif id == randomizerID then
		DoRandomizer(x,y,dir)
	elseif id == slowerdiamoverID then
		if delay4 == 0 then
			DoForceDiaMover(x,y,dir)
		end
	elseif id == pushmakerID then
		DoPushMaker(x,y,dir)
	end
	--cells[y][x].testvar = tostring(halfdelay)
	--cells[y][x].testvar = tostring(cells[y][x].ctype)
end

local function onEnemyDies(id,x,y)
	if id == bombID then
		playSound("destroy.wav")
        enemyparticles:setPosition(x*20,y*20)
        enemyparticles:emit(50)
		for cy = (y-2), (y+2),1 do
			for cx = (x-2), (x+2),1 do
				if cy > 0 then
					if cx > 0 then
						if cy < (height) then
							if cx < (width) then
								if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and cells[cy][cx].ctype ~= -1  and cells[cy][cx].ctype ~= 11  and cells[cy][cx].ctype ~= 50 then
									if cells[cy][cx].ctype ~= 0 then
										cells[cy][cx].ctype = 0
									end
								end
							end
						end
					end
				end
			end
		end
	elseif id == minibombID then
		playSound("destroy.wav")
        enemyparticles:setPosition(x*20,y*20)
        enemyparticles:emit(50)
        for cy = (y-1), (y+1),1 do
			for cx = (x-1), (x+1),1 do
				if cy > 0 then
					if cx > 0 then
						if cy < (height) then
							if cx < (width) then
								if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and cells[cy][cx].ctype ~= -1  and cells[cy][cx].ctype ~= 11  and cells[cy][cx].ctype ~= 50 then
									if cells[cy][cx].ctype ~= 0 then
										cells[cy][cx].ctype = 0
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local function onUnpause()
	isghostinitial = false
end

local function onReset()
	for y=0,height-1 do
		if not ghostcells[y] then ghostcells[y] = {} end
		for x=0,width-1 do
			if not ghostcells[y][x] then ghostcells[y][x] = {} end
			ghostcells[y][x].ctype = ghostinitial[y][x].ctype
			ghostcells[y][x].rot = ghostinitial[y][x].rot
			ghostcells[y][x].lastvars = ghostinitial[y][x].lastvars
		end
	end
	isghostinitial = true
end

local function onClear()
	for y=0,height-1 do
		ghostinitial[y] = {}
		ghostcells[y] = {}
		for x=0,width-1 do 
			ghostinitial[y][x] = {}
			ghostcells[y][x] = {}
			if y == 0 or x == 0 or y == height-1 or x == width-1 then
				ghostinitial[y][x] = {
					ctype = -1,
					rot = 0
				}
			else
				ghostinitial[y][x].ctype = 0
				ghostinitial[y][x].rot = 0
			end
			ghostcells[y][x].ctype = ghostinitial[y][x].ctype
			ghostcells[y][x].rot = ghostinitial[y][x].rot
			ghostcells[y][x].lastvars = {x,y,ghostcells[y][x].rot}
			ghostcells[y][x].testvar = ""
		end
	end
	isghostinitial = true
end

local function onSetInitial()
	for y=0,height-1 do
		for x=0,width-1 do
			ghostinitial[y][x].ctype = ghostcells[y][x].ctype 
			ghostinitial[y][x].rot = ghostcells[y][x].rot
			ghostinitial[y][x].lastvars = ghostcells[y][x].lastvars
		end
	end
	isghostinitial = true
end

local function onPlace(id,x,y,rot,original,originalinit)
	cells[y][x].elec = 0
	if id == randomizerID then
		DoRandomizer(x,y,rot)
	end
	if id == ghostmoverID then
		ghostcells[y][x].ctype = ghostmoverID
		ghostcells[y][x].rot = rot
		ghostcells[y][x].lastvars = {x,y,rot}
		cells[y][x] = original
		if isghostinitial then
			ghostinitial[y][x].ctype = ghostmoverID
			ghostinitial[y][x].rot = rot
			ghostinitial[y][x].lastvars = {x,y,rot}
		end
		initial[y][x] = originalinit
	end
	if id == ghostcellID then
		ghostcells[y][x].ctype = ghostcellID
		ghostcells[y][x].rot = rot
		ghostcells[y][x].lastvars = {x,y,rot}
		cells[y][x] = original
		if isghostinitial then
			ghostinitial[y][x].ctype = ghostcellID
			ghostinitial[y][x].rot = rot
			ghostinitial[y][x].lastvars = {x,y,rot}
		end
		initial[y][x] = originalinit
	end
	if id == 0 then
		ghostcells[y][x].ctype = 0
	end
end

return {
    update = update,
    init = init,
    customdraw = customdraw,
	tick = tick,
	onPlace = onPlace,
	onEnemyDies = onEnemyDies,
	onSetInitial = onSetInitial,
	onUnpause = onUnpause,
	onReset = onReset,
	onClear = onClear,
	onCellDraw = onCellDraw,
	dependencies = {"B-Mod"},
	version = ver
}