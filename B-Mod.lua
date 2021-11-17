-- Cells by Blendi Goose#0414
require("bmod.gates")
require("bmod.electricstuffs")
require("bmod.leds")
require("bmod.fastcells")
require("bmod.diag")
require("bmod.AI")
require("bmod.nuke")

-- Cells by GuyWithAMonitor#1595
require("bmod.unstoppabledrill")
require("bmod.life")
require("bmod.laser")
require("bmod.plant.plant")
require("bmod.brain.script")
require("bmod.big bang.script")
require("bmod.hybrider.hybrider")
require("bmod.fireball.fireballs")

-- Cells by K_______#0086
require("bmod.kai")
require("bmod.kaiwarrior")
require("bmod.kaiexplorer")
require("bmod.kaiengineer")
-- Rest of code

function RunModThing(thing, ...)
	for _, mod in pairs(modcache) do
		if type(mod[thing]) == "function" then
			mod[thing](...)
		end
	end
end

function InGrid(x,y)
    if x >= 0 and x <= width-1 then
        if y >= 0 and y <= height-1 then
            return true
        end
    end
    return false
end

local halfdelay = false

local delay4 = 0
local birdstate,slowbirdstate = 0,0
local bluescreen = love.graphics.newImage("bmod/bluscren.png")
local bluescreenenabled = false
local bluescreendelay = 0
local isghostinitial = true
local ghostcells = {}
local ghostinitial = {}
local ver = "2.0.0"
local name = "B-Mod"

local bmod_bindings = {
	updates = {}
} -- Added for improvements in code quality

local bmod_conditions = {
	updates = {}
} -- Added for improvements to bindings.

-- Low-level basic binding system

BMod = {}

function BMod.bind(category, id, func)
	if not bmod_bindings[category] then bmod_bindings[category] = {} end
	bmod_bindings[category][id] = func
end

function BMod.multiBind(category, bindings)
	for id, func in pairs(bindings) do
		BMod.bind(category, id, func) -- E
	end
end

function BMod.runBinding(category, id, ...)
	if not bmod_bindings[category] then bmod_bindings[category] = {} end
	if type(bmod_bindings[category][id]) ~= "function" then return end
	if not bmod_conditions[category] then bmod_conditions[category] = {} end
	if (bmod_conditions[category][id] ~= nil and bmod_conditions[category][id](...) == true) or (bmod_conditions[category][id] == nil) then
		bmod_bindings[category][id](...)
	end
end

function BMod.setConditional(category, id, conditionalCallback)
	if not bmod_conditions[category] then bmod_conditions[category] = {} end
	bmod_conditions[category][id] = conditionalCallback
end

-- Higher-level binding system in case Blendi doesn't understand the low-level one (to be honest, it is a bit confusing)

function BMod.bindUpdate(id, func)
	BMod.bind("updates", id, func)
end

function BMod.multiBindUpdate(bindings)
	BMod.multiBind("updates", bindings)
end

function BMod.updateCell(id, ...)
	BMod.runBinding("updates", id, ...)
end

function BMod.setConditionalUpdate(id, callback)
	BMod.setConditional("updates", id, callback)
end

-- Helpers

function doSlowState()
	return (halfdelay == true)
end

function doSlowerState()
	return (delay4 == 0)
end

-- Rest of code

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
electunnelID = 0
deadbirdID = 0
bluescreenID = 0
randomizerID = 0

slowbirdID = 0
deadslowbirdID = 0
unstoppabledrillID = 0

slowmayobottleID, slowmayomoveID = 0,0
pushmakerID = 0

spawnerID = 0
rotateSpawnerID = 0

local ver2 = "2.0.0"
local name2 = "B-Mod"

local function doSlowBird(x,y,dir)
	local state = slowbirdstate
	if not halfdelay then return end
	if dir == 0 then
		if state == 0 then
			if not DoForceMover(x,y,dir) then
				cells[y][x].ctype = deadslowbirdID
			end
		elseif state == 1 then
			DoForceMover(x,y,(dir-1)%4)
		elseif state == 2 then
			if not DoForceMover(x,y,dir) then
				cells[y][x].ctype = deadslowbirdID
			end
		elseif state == 3 then
			DoForceMover(x,y,(dir+1)%4)
		end
	elseif dir == 2 then
		if state == 0 then
			if not DoForceMover(x,y,dir) then
				cells[y][x].ctype = deadslowbirdID
			end
		elseif state == 1 then
			DoForceMover(x,y,(dir+1)%4)
		elseif state == 2 then
			DoForceMover(x,y,dir)
		elseif state == 3 then
			if not DoForceMover(x,y,(dir-1)%4) then
				cells[y][x].ctype = deadslowbirdID
			end
		end
	else
		if not DoForceMover(x,y,dir) then
			cells[y][x].ctype = deadslowbirdID
		end
	end
	SetChunk(x,y,deadslowbirdID)
end

local function doFire(x,y)
	if IsHidrated(x, y) then cells[y][x].ctype = 0 return end
	local offs = {
		{x=1,y=0},
		{x=-1,y=0},
		{x=0,y=1},
		{x=0,y=-1},
	}
	for _,off in pairs(offs) do
		local ox,oy = x+off.x, y+off.y
		if cells[oy][ox].ctype ~= 0 and cells[oy][ox].ctype ~= strongestfireID and cells[oy][ox].ctype ~= 40 and cells[oy][ox].ctype ~= fireID and cells[oy][ox].ctype ~= strongfireID and cells[oy][ox].ctype ~= strongerfireID and cells[oy][ox].ctype ~= -1  and cells[oy][ox].ctype ~= 11  and cells[oy][ox].ctype ~= 50 and (cells[oy][ox].ctype <= #cellsForIDManagement or canPushCell(ox,oy,x,y,"Fire")) then
			cells[oy][ox].ctype = fireID
			cells[oy][ox].updated = true
			SetChunk(ox,oy,fireID)
		end
	end
	cells[y][x] = {
		ctype = 0,
		rot = 0,
		lastvars = cells[y][x].lastvars
	}
end

local function doStrongFire(x,y)
	if IsHidrated(x, y) then cells[y][x].ctype = 0 return end
	local offs = {
		{x=1,y=0},
		{x=-1,y=0},
		{x=0,y=1},
		{x=0,y=-1},

		{x=1,y=1},
		{x=1,y=-1},
		{x=-1,y=1},
		{x=-1,y=-1},
	}
	for _,off in pairs(offs) do
		local ox,oy = x+off.x, y+off.y
		if cells[oy][ox].ctype ~= 0 and cells[oy][ox].ctype ~= strongestfireID and cells[oy][ox].ctype ~= 40 and cells[oy][ox].ctype ~= fireID and cells[oy][ox].ctype ~= strongfireID and cells[oy][ox].ctype ~= strongerfireID and cells[oy][ox].ctype ~= -1  and cells[oy][ox].ctype ~= 11  and cells[oy][ox].ctype ~= 50 and (cells[oy][ox].ctype <= #cellsForIDManagement or canPushCell(ox,oy,x,y,"Fire")) then
			cells[oy][ox].ctype = strongfireID
			cells[oy][ox].updated = true
			SetChunk(ox,oy,strongfireID)
		end
	end
	cells[y][x] = {
		ctype = 0,
		rot = 0,
		lastvars = cells[y][x].lastvars
	}
end

local function doStrongerFire(x,y)
	if IsHidrated(x, y) then cells[y][x].ctype = 0 return end
	for offx = -2,2,1 do
		for offy = -2,2,1 do
			local ox,oy = x+offx, y+offy
			if InGrid(ox,oy) then
				if cells[oy][ox].ctype ~= 0 and cells[oy][ox].ctype ~= strongestfireID and cells[oy][ox].ctype ~= 40 and cells[oy][ox].ctype ~= fireID and cells[oy][ox].ctype ~= strongfireID and cells[oy][ox].ctype ~= strongerfireID and cells[oy][ox].ctype ~= -1  and cells[oy][ox].ctype ~= 11  and cells[oy][ox].ctype ~= 50 and (cells[oy][ox].ctype <= #cellsForIDManagement or canPushCell(ox,oy,x,y,"Fire")) then
					cells[oy][ox].ctype = strongerfireID
					cells[oy][ox].updated = true
					SetChunk(ox,oy,strongerfireID)
				end
			end
		end
	end
	cells[y][x] = {
		ctype = 0,
		rot = 0,
		lastvars = cells[y][x].lastvars
	}
end

local function doStrongestFire(x,y)
	if IsHidrated(x, y) then cells[y][x].ctype = 0 return end
	for offx = -4,4,1 do
		for offy = -4,4,1 do
			local ox,oy = x+offx, y+offy
			if InGrid(ox,oy) then
				if cells[oy][ox].ctype ~= 0 and cells[oy][ox].ctype ~= strongestfireID and cells[oy][ox].ctype ~= 40 and cells[oy][ox].ctype ~= fireID and cells[oy][ox].ctype ~= strongfireID and cells[oy][ox].ctype ~= strongerfireID and cells[oy][ox].ctype ~= -1  and cells[oy][ox].ctype ~= 11  and cells[oy][ox].ctype ~= 50 and (cells[oy][ox].ctype <= #cellsForIDManagement or canPushCell(ox,oy,x,y,"Fire")) then
					cells[oy][ox].ctype = strongestfireID
					cells[oy][ox].updated = true
					SetChunk(ox,oy,strongestfireID)
				end
			end
		end
	end
	cells[y][x] = {
		ctype = 0,
		rot = 0,
		lastvars = cells[y][x].lastvars
	}
end


local function init()
	--if not checkVersion("B-Mod",ver2) then error("stop being dumbass") end
	if not (name == name2) then error("stop being dumbass") end
  	triplegenID = addCell("BM 3gen","bmod/triplegenerator.png",{})
    bombID = addCell("BM bom","bmod/bomb.png",{type = "enemy"})
    minibombID = addCell("BM minibom","bmod/minibomb.png",{type = "enemy"})
    triplesplitterID = addCell("BM 3split","bmod/triplesplitter.png",{})
    splitterID = addCell("BM split","bmod/splitter.png",{})
    tunnelID = addCell("BM tunnel","bmod/tunnel.png",{})
    trashholeID = addCell("BM trashhole","bmod/trashhole.png",{})
	slowmoverID = addCell("BM slowpush","bmod/slowmover.png",{type = "mover"})
    slowpullerID = addCell("BM slowpull","bmod/slowpuller.png",{type = "mover"})
	slowadvancerID = addCell("BM slowpullsh","bmod/slowadvancer.png",{type = "mover"})
	doublegenID = addCell("BM 2gen","bmod/doublegenerator.png",{})
	elecoffID = addCell("BM elecoff","bmod/elecoff.png",{})
	eleconID = addCell("BM elecon","bmod/elecon.png",{invisible = true})
	redelecoffID = addCell("BM redelecoff","bmod/redelecoff.png",{})
	redeleconID = addCell("BM redelecon","bmod/redelecon.png",{invisible = true})
	batteryID = addCell("BM battery","bmod/battery.png",{})
	repeaterID = addCell("BM rep","bmod/repeater.png",{})
	andID = addCell("BM and","bmod/andgate.png",{})
	orID = addCell("BM or","bmod/orgate.png",{})
	xorID = addCell("BM xor","bmod/xorgate.png",{})
	xnorID = addCell("BM xnor","bmod/xnorgate.png",{})
	norID = addCell("BM nor","bmod/norgate.png",{})
	nandID = addCell("BM nand","bmod/nandgate.png",{})
	notID = addCell("BM not","bmod/notgate.png",{})
	crosswireID = addCell("BM wirecross","bmod/crosswire.png",{})
	elecgenID = addCell("BM elecgen","bmod/elecgen.png",{})
	elecmoveID = addCell("BM elecmove","bmod/elecmover.png",{type = "mover"})
	elecrotcwID = addCell("BM elecrot","bmod/elecrotcw.png",{})
	elecrotccwID = addCell("BM elecrotccw","bmod/elecrotccw.png",{})
	electunnelID = addCell("BM electunnel","bmod/electunnel.png",{})
	mayobottleID = addCell("BM mayobottle","bmod/mayobottle.png",{})
	mayomoveID = addCell("BM mayomove","bmod/mayomover.png",{type = "mover"})
	slowmayobottleID = addCell("BM slowmayobottle","bmod/slowmayobottle.png",{})
	slowmayomoveID = addCell("BM slowmayomove","bmod/slowmayomover.png",{type = "mover"})
	doleds()
	--if not checkVersion("B-Mod",ver2) then error("stop being dumbass") end
	if not (name == name2) then error("stop being dumbass") end
	birdID = addCell("BM bird","bmod/bird.png",{})
	slowbirdID = addCell("BM slow-bird","bmod/slowbird.png",{})
	BMod.bindUpdate(slowbirdID, doSlowBird)
	deadslowbirdID = addCell("BM deadslowbird","bmod/deadslowbird.png",{invisible = true})
	unstoppabledrillID = addCell("BM unstoppable-drill","bmod/unstoppabledriller.png",{push = function() return false end})
	BMod.bindUpdate(unstoppabledrillID, DoUnstoppableDrill)
	adddiamover()
	addfastcells()
	adddiamovers()
	slowermoverID = addCell("BM slowermove","bmod/slowermover.png",{type = "mover"})
	slowerpullerID = addCell("BM slowerpull","bmod/slowerpuller.png",{type = "mover"})
	sloweradvancerID = addCell("BM slowerpullsh","bmod/sloweradvancer.png",{type = "mover"})
	deadbirdID = addCell("BM deadbird","bmod/deadbird.png",{invisible = true})
	bluescreenID = addCell("BM bluescreen","bmod/bluescreenofdoom.png",{})
	randomizerID = addCell("BM randomizer","bmod/randomizer.png",{})
	ghostmoverID = addCell("BM ghostmover","bmod/ghostmover.png",{type = "mover"})
	ghostcellID = addCell("BM ghostcell","bmod/ghostcell.png",{})
	pushmakerID = addCell("BM pushmaker","bmod/pushmaker.png",{})

	fireID = addCell("BM fire", "bmod/fire.png")
	strongfireID = addCell("BM strongfire", "bmod/strongfire.png")
	strongerfireID = addCell("BM strongerfire", "bmod/strongerfire.png")
	strongestfireID = addCell("BM strongestfire", "bmod/strongestfire.png")

	AddFireBalls()

	AddLasers()
	AddNukes()

	hybriderID = addCell("BM hybrider", "bmod/hybrider/hybrider.png", {updateindex = 1})

	AddPlant()
	AddLife()

	addAI()

	kaiID = addCell("BM kai","bmod/kai.png",{type = "mover"})

	kaiwarriorID = addCell("BM kaiwarrior","bmod/kaiwarrior.png",{type = "mover"})
	kaiengineerID = addCell("BM kaiengineer","bmod/kaiengineer.png",{type = "mover"})
	kaiexplorerID = addCell("BM kaiexplorer","bmod/kaiexplorer.png",{type = "mover"})

	AddHybrids()

	spawnerID = addCell("BM spawner", "bmod/spawner.png",{type = "trash"})
	rotateSpawnerID = addCell("BM rotate-spawner", "bmod/spawner_rotate.png",{type = "trash"})

	bigBangID = addCell("BM big-bang", "bmod/big bang/texture.png")

	if EdTweaks ~= nil then
		local Move = EdTweaks:GetCategory("Movement")
		Move:AddItem("BM fastmove", "Moves and pushes twice every tick.")
			:SetAlias("Fast Mover")
		Move:AddItem("BM fastermove", "Moves and pushes four times every tick.")
			:SetAlias("Faster Mover")
		Move:AddItem("BM slowpush", "Moves and pushes every two ticks.")
			:SetAlias("Slow Mover")
		Move:AddItem("BM slowermove", "Moves and pushes every four ticks.")
			:SetAlias("Slower Mover")
		Move:AddItem("BM velocity", "Moves and pushes a linearly increasing number of cells every tick.")
			:SetAlias("Velocity Mover")
		Move:AddItem("BM acceleration", "Moves and pushes an exponentially increasing number of cells every tick.")
			:SetAlias("Accelerator Mover")
		Move:AddItem("BM diamover", "Same as Mover, but also moves in a second direction every tick.")
			:SetAlias("Diagonal Mover")
		Move:AddItem("BM fastdiamover", "Moves and pushes cells diagonally twice per tick.")
			:SetAlias("Fast Diagonal Mover")
		Move:AddItem("BM slowdiamover", "Moves and pushes cells diagonally once per two ticks.")
			:SetAlias("Slow Diagonal Mover")
		Move:AddItem("BM slowerdiamover", "Moves and pushes cells diagonally once per four ticks.")
			:SetAlias("Slower Diagonal Mover")
		Move:AddItem("BM fastpull", "Pulls twice every tick.")
			:SetAlias("Fast Puller")
		Move:AddItem("BM fasterpull", "Moves and pulls four times every tick.")
			:SetAlias("Faster Puller")
		Move:AddItem("BM slowpull", "Moves and pulls every two ticks.")
			:SetAlias("Slow Puller")
		Move:AddItem("BM slowerpull", "Moves and pulls every four ticks.")
			:SetAlias("Slower Puller")
		Move:AddItem("BM fastadvance", "Pushes and pulls twice every tick.")
			:SetAlias("Fast Advancer")
		Move:AddItem("BM fasteradvance", "Pushes and pulls four times every tick.")
			:SetAlias("Faster Puller")
		Move:AddItem("BM slowpullsh", "Pushes and pulls once every two ticks")
			:SetAlias("Slow Advancer")
		Move:AddItem("BM slowerpullsh", "Pushes and pulls cells every four ticks.")
			:SetAlias("Slower Advancer")
		Move:AddItem("BM unstoppable-drill", "This cell acts as a drill, but its effect takes priority over most others.")
			:SetAlias("Unstoppable Drill")
		Move:AddItem("BM ghostmover", "Pushes through most cells, existing on its own layer.")
			:SetAlias("Ghost Mover")
		Move:AddItem("BM bird", "This cell moves in a serpentine fashion, covering a 2 cell wide area on its way to the destination. Dies on collision.")
			:SetAlias("Bird")
		Move:AddItem("BM slow-bird", "This cell moves in a serpentine fashion every other tick, covering a 2 cell wide area on its way to the destination. Dies on collision.")
			:SetAlias("Slow Bird")
		Move:AddItem("BM mayomove", "This cell is functionally similar to the push cell. It is generated from Mayonnaise Bottles.")
			:SetAlias("Pushy Mayo")
		Move:AddItem("BM slowmayomove", "This cell is functionally similar to the slow push cell. It is generated from Slow Mayonnaise Bottles.")
			:SetAlias("Slow-Moving Pushy Mayo")
		Move:AddItem("BM fireball", "This cell is a mover that when it hits something turns into fire")
			:SetAlias("Fireball")
		Move:AddItem("BM fireball-stronk", "This cell is a mover that when it hits something turns into strong fire")
			:SetAlias("Strong Fireball")
		Move:AddItem("BM fireball-stronker", "This cell is a mover that when it hits something turns into stronger fire")
			:SetAlias("Stronger Fireball")
		Move:AddItem("BM fireball-stronkest", "This cell is a mover that when it hits something turns into strongest fire")
			:SetAlias("Strongest Fireball")
		local Dstr = EdTweaks:GetCategory("Destructors")
		Dstr:AddItem("BM trashhole", "This cell continuously destroys any cells that are one cell away from this one.")
			:SetAlias("Trash Hole")
		Dstr:AddItem("BM bom", "This item blows up things up to 2 cells away.")
			:SetAlias("Bomb")
		Dstr:AddItem("BM minibom", "This item blows up things up to 1 cell away.")
			:SetAlias("Mini Bomb")
		Dstr:AddItem("BM fire", "Fire, spreads to cells next to it and dissapears 1 tick later")
			:SetAlias("Fire")
		Dstr:AddItem("BM strongfire", "Fire but also spreads diagonally")
			:SetAlias("Strong Fire")
		Dstr:AddItem("BM strongerfire", "Fire but spreads in a 5x5 area")
			:SetAlias("Stronger Fire")
		Dstr:AddItem("BM strongestfire", "Fire but spreads in a 9x9 area")
			:SetAlias("Strongest Fire")
		local Gntr = EdTweaks:GetCategory("Generators")
		Gntr:AddItem("BM 2gen", "Creates copies of the square face at the arrow faces. cell must be copyable.")
			:SetAlias("Double Generator")
		Gntr:AddItem("BM 3gen", "Creates copies of the square face at the arrow faces. cell must be copyable.")
			:SetAlias("Triple Generator")
		Gntr:AddItem("BM tunnel", "This cell destroys the cell in the X face and puts a copy on the arrow face.")
			:SetAlias("Tunnel")
		Gntr:AddItem("BM split", "This cell destroys the cell in the X face and puts two copies on the arrow faces.")
			:SetAlias("Splitter")
		Gntr:AddItem("BM 3split", "This cell destroys the cell in the X face and puts three copies on the arrow faces.")
			:SetAlias("Triple Splitter")
		Gntr:AddItem("BM pushmaker", "Creates Push cells on the front face every tick.")
			:SetAlias("Push Maker")
		Gntr:AddItem("BM weak-laser", "Creates 1 copy of itself each tick.")
			:SetAlias("Laser (Weak)")
		Gntr:AddItem("BM stronk-laser", "Creates 2 copies of itself each tick.")
			:SetAlias("Laser (Stronk)")
		Gntr:AddItem("BM stronker-laser", "Creates 4 copies of itself each tick.")
			:SetAlias("Laser (Stronker)")
		Gntr:AddItem("BM nuke1", "Creates a copy of itself in all directions each tick.")
			:SetAlias("Nuke (Weak)")
		Gntr:AddItem("BM nuke2", "Creates 2 copies of itself in all directions each tick.")
			:SetAlias("Nuke (Average)")
		Gntr:AddItem("BM nuke3", "Creates 5 copies of itself in all directions each tick.")
			:SetAlias("Nuke (Strong)")
		Gntr:AddItem("BM nuke4", "Creates 10 copies of itself in all directions each tick.")
			:SetAlias("Nuke (POWERRR)")
		Gntr:AddItem("BM mayobottle", "Creates moving Mayonnaise cells in front every other tick, 2 cells away from the output face.")
			:SetAlias("Mayonnaise Bottle")
		Gntr:AddItem("BM slowmayobottle", "Creates moving Slow Mayonnaise cells in front every other tick, 2 cells away from the output face.")
			:SetAlias("Slow Mayonnaise Bottle")
		Gntr:AddItem("BM spawner", "Place a cell on it or push one in and it will start spawning it.")
			:SetAlias("Spawner")
		Gntr:AddItem("BM rotate-spawner", "Place a cell on it or push one in and it will start spawning it but also spin.")
			:SetAlias("Rotation Spawner")
		local Uniq = EdTweaks:GetCategory("Unique")
		Uniq:AddItem("BM randomizer", "Changes into a random cell during the first tick or when placed.")
			:SetAlias("Randomizer")
		Uniq:AddItem("BM big-bang", "Creates a bunch of random cells around it.")
			:SetAlias("Big bang")
		Uniq:AddItem("BM ghostcell", "Exists on its own layer. Pushable by Ghost Movers.")
			:SetAlias("Ghost Cell")
		Uniq:AddItem("BM bluescreen", "ERROR")
			:SetAlias("Blue Screen of Death")
		local Elct = EdTweaks:AddCategory("Electricity", "Deals with electricity... in cells. Woah.", true, "bmod/elecon")
		Elct:AddItem("BM elecoff", "Unpowered Electricity Cell")
			:SetAlias("Unpowered Electric Cell")
		Elct:AddItem("BM redelecoff", "Unpowered Red Electricity Cell")
			:SetAlias("Unpowered Red Electric Cell")
		Elct:AddItem("BM battery", "Gives off infinite electricity to nearby electricity cells.")
			:SetAlias("Battery")
		Elct:AddItem("BM rep", "Takes low electricity and brings it back up.")
			:SetAlias("Electric Repeater")
		Elct:AddItem("BM elecgen", "Generator but only functions when theres an active electric signal next to it.")
			:SetAlias("Electric Generator")
		Elct:AddItem("BM elecmove", "Mover but only moves when theres an active electric signal next to it.")
			:SetAlias("Electric Mover")
		Elct:AddItem("BM elecrot", "Rotator but only works when theres an active electric signal next to it.")
			:SetAlias("Electric Rotator (Clockwise)")
		Elct:AddItem("BM elecrotccw", "Rotator but only works when theres an active electric signal next to it.")
			:SetAlias("Electric Rotator (Counter-Clockwise)")
		Elct:AddItem("BM electunnel", "Tunnel that instead of putting the cell on the other side it turns it to electricity.")
			:SetAlias("Electric Tunnel")
		Elct:AddItem("BM redledon", "A red led that turns on when theres an active electric signal next to it.")
			:SetAlias("Red LED")
		Elct:AddItem("BM greenledon", "A green led that turns on when theres an active electric signal next to it.")
			:SetAlias("Green LED")
		Elct:AddItem("BM blueledon", "A blue led that turns on when theres an active electric signal next to it.")
			:SetAlias("Blue LED")
		Elct:AddItem("BM magentaledon", "A magenta led that turns on when theres an active electric signal next to it.")
			:SetAlias("Magenta LED")
		Elct:AddItem("BM yellowledon", "A yellow led that turns on when theres an active electric signal next to it.")
			:SetAlias("Yellow LED")
		Elct:AddItem("BM cyanledon", "A cyan led that turns on when theres an active electric signal next to it.")
			:SetAlias("Cyan LED")
		Elct:AddItem("BM and", "AND gate for electricity.")
			:SetAlias("AND")
		Elct:AddItem("BM or", "OR gate for electricity.")
			:SetAlias("OR")
		Elct:AddItem("BM xnor", "XNOR gate for electricity.")
			:SetAlias("XNOR")
		Elct:AddItem("BM nor", "NOR gate for electricity.")
			:SetAlias("NOR")
		Elct:AddItem("BM nand", "NAND gate for electricity.")
			:SetAlias("NAND")
		Elct:AddItem("BM not", "NOT gate for electricity.")
			:SetAlias("NOT")
		Elct:AddItem("BM wirecross", "Connect electricity top to bottom and left to right.")
			:SetAlias("Cross Wire")
		local lifecat = EdTweaks:GetCategory("Life")
		lifecat:AddItem("BM AI", "AI robot that does smort stuff (Also kills killer Karls).")
			:SetAlias("AI Car")
		lifecat:AddItem("BM kai", "This cell comes from the deep dark corners of the universe, it may seem innocent at first (it isn't) but it isn't. It will eat anything from karls to slightly different karls and even water, it can even leech off of brains!")
			:SetAlias("Kai")
		lifecat:AddItem("BM kaiwarrior", "Has a chance to appear as a mutation to the kai, it is also more powerful.")
			:SetAlias("Kai Warrior")
		lifecat:AddItem("BM kaiexplorer", "Has a chance to appear as a mutation to the kai, can sustain itself with less food but is also less powerful.")
			:SetAlias("Kai Explorer")
		lifecat:AddItem("BM kaiengineer", "Has a chance to appear as a mutation to the kai, it can reprogram karls.")
			:SetAlias("Kai Engineer")
	end
	if Toolbar then
		local movecat = Toolbar:GetCategory("Movers")
		movecat:AddItem("Fast Mover","Moves and pushes twice every tick.","BM fastmove")
		movecat:AddItem("Faster Mover","Moves and pushes four times every tick.","BM fastermove")
		movecat:AddItem("Slow Mover","Moves and pushes every two ticks.","BM slowpush")
		movecat:AddItem("Slower Mover","Moves and pushes every four ticks.","BM slowermove")
		movecat:AddItem("Velocity Mover","Moves and pushes a linearly increasing number of cells every tick.","BM velocity")
		movecat:AddItem("Accelerator Mover","Moves and pushes an exponentially increasing number of cells every tick.","BM acceleration")
		movecat:AddItem("Diagonal Mover","Same as Mover, but also moves in a second direction every tick.","BM diamover")
		movecat:AddItem("Fast Diagonal Mover","Moves and pushes cells diagonally twice per tick.","BM fastdiamover")
		movecat:AddItem("Slow Diagonal Mover","Moves and pushes cells diagonally once per two ticks.","BM slowdiamover")
		movecat:AddItem("Slower Diagonal Mover","Moves and pushes cells diagonally once per four ticks.","BM slowerdiamover")
		movecat:AddItem("Fast Puller","Pulls twice every tick.","BM fastpull")
		movecat:AddItem("Faster Puller","Moves and pulls four times every tick.","BM fasterpull")
		movecat:AddItem("Slow Puller","Moves and pulls every two ticks.","BM slowpull")
		movecat:AddItem("Slower Puller","Moves and pulls every four ticks.","BM slowerpull")
		movecat:AddItem("Fast Advancer","Pushes and pulls twice every tick.","BM fastadvance")
		movecat:AddItem("Faster Puller","Pushes and pulls four times every tick.","BM fasteradvance")
		movecat:AddItem("Slow Advancer","Pushes and pulls once every two ticks","BM slowpullsh")
		movecat:AddItem("Slower Advancer","Pushes and pulls cells every four ticks.","BM slowerpullsh")
		movecat:AddItem("Unstoppable Drill","This cell acts as a drill, but its effect takes priority over most others.","BM unstoppable-drill")
		movecat:AddItem("Ghost Mover","Pushes through most cells, existing on its own layer.","BM ghostmover")
		movecat:AddItem("Bird","This cell moves in a serpentine fashion, covering a 2 cell wide area on its way to the destination. Dies on collision.","BM bird")
		movecat:AddItem("Slow Bird","This cell moves in a serpentine fashion every other tick, covering a 2 cell wide area on its way to the destination. Dies on collision.","BM slow-bird")
		movecat:AddItem("Pushy Mayo","This cell is functionally similar to the push cell. It is generated from Mayonnaise Bottles.","BM mayomove")
		movecat:AddItem("Slow-Moving Pushy Mayo","This cell is functionally similar to the slow push cell. It is generated from Slow Mayonnaise Bottles.","BM slowmayomove")
		local fballcat = movecat:AddCategory("Fireballs", "Types of fireballs.", "bmod/fireball/textures/normal.png")
		fballcat:AddItem("Fireball","This cell is a mover that when it hits something turns into fire","BM fireball")
		fballcat:AddItem("Strong Fireball","This cell is a mover that when it hits something turns into strong fire","BM fireball-stronk")
		fballcat:AddItem("Stronger Fireball","This cell is a mover that when it hits something turns into stronger fire","BM fireball-stronker")
		fballcat:AddItem("Strongest Fireball","This cell is a mover that when it hits something turns into strongest fire","BM fireball-stronkest")

		local descat = Toolbar:GetCategory("Destroyers")
		descat:AddItem("Trash Hole","This cell continuously destroys any cells that are one cell away from this one.","BM trashhole")
		descat:AddItem("Bomb","This cell blows up things up to 2 cells away.","BM bom")
		descat:AddItem("Mini Bomb","This item blows up things up to 1 cell away.","BM minibom")
		local fircat = descat:AddCategory("Fire Types", "Types of fire.", "bmod/fire.png")
		fircat:AddItem("Fire","Fire, spreads to cells next to it and dissapears 1 tick later","BM fire")
		fircat:AddItem("Strong Fire","Fire but also spreads diagonally","BM strongfire")
		fircat:AddItem("Stronger Fire","Fire but spreads in a 5x5 area","BM strongerfire")
		fircat:AddItem("Strongest Fire","Fire but spreads in a 9x9 area","BM strongestfire")

		local unicat = Toolbar:GetCategory("Unique cells")
		unicat:AddItem("Randomizer","Changes into a random cell during the first tick or when placed.","BM randomizer")
		unicat:AddItem("Big Bang","Creates a bunch of random cells around it.","BM big-bang")
		unicat:AddItem("Ghost Cell","Exists on its own layer. Pushable by Ghost Movers.","BM ghostcell")
		unicat:AddItem("Blue Screen of Death","ERROR","BM bluescreen")

		local gencat = Toolbar:GetCategory("Generators")
		gencat:AddItem("Double Generator","Creates copies of the square face at the arrow faces. cell must be copyable.","BM 2gen")
		gencat:AddItem("Triple Generator","Creates copies of the square face at the arrow faces. cell must be copyable.","BM 3gen")
		local tuncat = gencat:AddCategory("Tunnelers", "Cells that remove the cell behind it copy it elsewhere.", "bmod/tunnel.png")
		tuncat:AddItem("Tunnel","This cell destroys the cell in the X face and puts a copy on the arrow face.","BM tunnel")
		tuncat:AddItem("Splitter","This cell destroys the cell in the X face and puts two copies on the arrow faces.","BM split")
		tuncat:AddItem("Triple Splitter","This cell destroys the cell in the X face and puts three copies on the arrow faces.","BM 3split")
		gencat:AddItem("Push Maker","Creates Push cells on the front face every tick.","BM pushmaker")
		local lascat = gencat:AddCategory("Lasers", "Cells that copy themselves forward.", "bmod/laser.png")
		lascat:AddItem("Laser (Weak)","Creates 1 copy of itself each tick.","BM weak-laser")
		lascat:AddItem("Laser (Stronk)","Creates 2 copies of itself each tick.","BM stronk-laser")
		lascat:AddItem("Laser (Stronker)","Creates 4 copies of itself each tick.","BM stronker-laser")
		local nukcat = gencat:AddCategory("Nukes", "Cells that copy themselves in all directions.", "bmod/nuke.png")
		nukcat:AddItem("Nuke (Weak)","Creates a copy of itself in all directions each tick.","BM nuke1")
		nukcat:AddItem("Nuke (Average)","Creates 2 copies of itself in all directions each tick.","BM nuke2")
		nukcat:AddItem("Nuke (Strong)","Creates 5 copies of itself in all directions each tick.","BM nuke3")
		nukcat:AddItem("Nuke (POWERRR)","Creates 10 copies of itself in all directions each tick.","BM nuke4")
		gencat:AddItem("Mayonnaise Bottle","Creates moving Mayonnaise cells in front every other tick.","BM mayobottle")
		gencat:AddItem("Slow Mayonnaise Bottle","Creates moving Slow Mayonnaise cells in front every other tick, 2 cells away from the output face.","BM slowmayobottle")
		gencat:AddItem("Spawner","Place a cell on it or push one in and it will start spawning it.","BM spawner")
		gencat:AddItem("Rotation Spawner","Place a cell on it or push one in and it will start spawning it but also spin.","BM rotate-spawner")

		local elcat = Toolbar:AddCategory("Electricity","Deals with electricity... in cells. Woah.","bmod/elecon.png")
		elcat:AddItem("Unpowered Electric Cell","Unpowered Electric Cell","BM elecoff")
		elcat:AddItem("Unpowered Red Electric Cell","Unpowered Red Electric Cell","BM redelecoff")
		elcat:AddItem("Battery","Gives off infinite electricity to nearby electricity cells.","BM battery")
		elcat:AddItem("Electric Repeater","Takes low electricity and brings it back up.","BM rep")
		elcat:AddItem("Electric Generator","Generator but only functions when theres an active electric signal next to it.","BM elecgen")
		elcat:AddItem("Electric Mover","Mover but only moves when theres an active electric signal next to it.","BM elecmove")
		elcat:AddItem("Electric Rotator (Clockwise)","Rotator but only works when theres an active electric signal next to it.","BM elecrot")
		elcat:AddItem("Electric Rotator (Counter-Clockwise)","Rotator but only works when theres an active electric signal next to it.","BM elecrotccw")
		elcat:AddItem("Electric Tunnel","Tunnel that instead of putting the cell on the other side it turns it to electricity.","BM electunnel")
		local ledcat = elcat:AddCategory("LEDs", "Cells that can turn on with electricity", "bmod/ledyellowon.png")
		ledcat:AddItem("Red LED","A red led that turns on when theres an active electric signal next to it.","BM redledon")
		ledcat:AddItem("Green LED","A green led that turns on when theres an active electric signal next to it.","BM greenledon")
		ledcat:AddItem("Blue LED","A blue led that turns on when theres an active electric signal next to it.","BM blueledon")
		ledcat:AddItem("Magenta LED","A magenta led that turns on when theres an active electric signal next to it.","BM magentaledon")
		ledcat:AddItem("Yellow LED","A yellow led that turns on when theres an active electric signal next to it.","BM yellowledon")
		ledcat:AddItem("Cyan LED","A cyan led that turns on when theres an active electric signal next to it.","BM cyanledon")
		local gatcat = elcat:AddCategory("Electric Gates", "Logic Gates for Electricity", "bmod/andgate.png")
		gatcat:AddItem("AND", "AND gate for electricity.","BM and")
		gatcat:AddItem("OR", "OR gate for electricity.","BM or")
		gatcat:AddItem("XNOR", "XNOR gate for electricity.","BM xnor")
		gatcat:AddItem("NOR", "NOR gate for electricity.","BM nor")
		gatcat:AddItem("NAND", "NAND gate for electricity.","BM nand")
		gatcat:AddItem("NOT", "NOT gate for electricity.","BM not")
		elcat:AddItem("Cross Wire","Connect electricity top to bottom and left to right.","BM wirecross")
		local lifecat = Toolbar:GetCategory("Life")
		lifecat:AddItem("AI Car","AI robot that does smort stuff (Also kills killer Karls).","BM AI")
		lifecat:AddItem("Kai","This cell comes from the deep dark corners of the universe, it may seem innocent at first (it isn't) but it isn't. It will eat anything from karls to slightly different karls and even water, it can even leech off of brains!","BM kai")
		lifecat:AddItem("Kai Warrior","Has a chance to appear as a mutation to the kai, it is also more powerful.","BM kaiwarrior")
		lifecat:AddItem("Kai Explorer","Has a chance to appear as a mutation to the kai, can sustain itself with less food but is also less powerful.","BM kaiexplorer")
		lifecat:AddItem("Kai Engineer","Has a chance to appear as a mutation to the kai, it can reprogram karls.","BM kaiengineer")
	end
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
	if elec > 1 then
		if cells[y][x].ctype == redeleconID or cells[y][x].ctype == redelecoffID then cells[y][x].ctype = redeleconID end
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
	if elec > 1 then
		if cells[y][x].ctype == eleconID or cells[y][x].ctype == elecoffID then cells[y][x].ctype = eleconID end
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
	if not ghostcells[y] then ghostcells[y] = {} end
	if not ghostcells[y][x] then ghostcells[y][x] = {ctype = 0, rot = 0, lastvars = {x,y,0}} end
	if not ghostcells[y][x].rot then ghostcells[y][x].rot = 0 end
	if not ghostcells[y][x].ctype then ghostcells[y][x].ctype = 0 end
	if not ghostcells[y][x].lastvars then ghostcells[y][x].lastvars = {x,y,0} end
	if ghostcells[y][x].ctype ~= 0 and ghostcells[y][x].ctype ~= -1 then love.graphics.draw(tex[ghostcells[y][x].ctype],math.floor(lerp(ghostcells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(ghostcells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),ghostcells[y][x].rot*math.pi/2,zoom/texsize[ghostcells[y][x].ctype].w,zoom/texsize[ghostcells[y][x].ctype].h,texsize[ghostcells[y][x].ctype].w2,texsize[ghostcells[y][x].ctype].h2) end
	love.graphics.setColor(1,1,1,1)
	if (id == spawnerID or id == rotateSpawnerID) then
		local toSpawn = cells[y][x].spawner_current
		if not toSpawn then return end
		love.graphics.draw(tex[toSpawn],math.floor(lerp(cells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(cells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),((lerp(cells[y][x].lastvars[3],cells[y][x].lastvars[3]+((cells[y][x].rot-cells[y][x].lastvars[3]+2)%4-2),itime/delay)+(cells[y][x].spawner_dir_off))%4)*math.pi/2,zoom/texsize[toSpawn].w/4,zoom/texsize[toSpawn].h/4,texsize[toSpawn].w2,texsize[toSpawn].h2)
	end
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
		elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
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
		elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
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
				if elec >= 2 then
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
				if elec >= 2 then
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
	if halfdelay == true then
		slowbirdstate = (slowbirdstate+1)%4
	end
	delay4 = (delay4+1)%4
	for y=0,height-1 do
		if not ghostcells[y] then ghostcells[y] = {} end
		for x=0,width-1 do
			if not ghostcells[y][x] then 
			ghostcells[y][x] = {
				ctype = 0,
				rot = 0,
				lastvars = {x,y,0}
			} 
			end
			ghostcells[y][x].updated = false
			ghostcells[y][x].lastvars = {x,y,ghostcells[y][x].rot}
		end
	end
	local cellbackup = cells
	cells = ghostcells
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
	ghostcells = cells
	cells = cellbackup
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
	BMod.updateCell(id, x, y, dir) -- Binding system

	UpdateLasers(id, x, y, dir) -- Lasers by UndefinedMonitor
	
	UpdateNukes(id,x,y,dir)

	if id == bigBangID then
		DoBingBang(x, y)
	elseif id == brainID then
		DoBrain(x, y)
	elseif id == plantID then
		DoPlant(x, y)
	elseif id == waterID then
		Hidrate(x, y)
	elseif id == kaiID then
		DoKAI(x,y,dir)
	elseif id == kaiengineerID then
		DoKAIengineer(x,y,dir)
	elseif id == kaiexplorerID then
		DoKAIexplorer(x,y,dir)
	elseif id == kaiwarriorID then
		DoKAIwarrior(x,y,dir)
	elseif id == spawnerID or id == rotateSpawnerID then
		DoSpawner(x, y, dir)
	elseif id == karlpulsorID then
		DoKarlpulsor(x, y)
	elseif id == karlbonID then
		DoKarlbon(x, y)
	elseif id == healKarlID then
		DoHealKarl(x, y)
	elseif id == meanKarlID then
		DoMeanKarl(x, y)
	elseif id == fireID then
		doFire(x,y)
	elseif id == strongfireID then
		doStrongFire(x,y)
	elseif id == strongerfireID then
		doStrongerFire(x,y)
	elseif id == strongestfireID then
		doStrongestFire(x,y)
	elseif id == karlID then
		DoKarl(x, y)
	elseif id == elecoffID or id == eleconID then
		UpdateElec(x, y)	
	elseif id == redeleconID or id == redelecoffID then
		UpdateRedElec(x, y)
	elseif id == batteryID then
		UpdateBatteries(x, y)
	elseif id == repeaterID then
		DoRepeater(x, y)
	elseif id == andID then
		andgate(x, y, dir)
	elseif id == orID then
		orgate(x, y, dir)
	elseif id == xorID then
		xorgate(x, y, dir)
	elseif id == xnorID then
		xnorgate(x, y, dir)
	elseif id == norID then
		norgate(x, y, dir)
	elseif id == nandID then
		nandgate(x, y, dir)
	elseif id == notID then
		notgate(x, y, dir)
	elseif id == crosswireID then
		crosswire(x, y)
	elseif id == elecgenID then
		elecgen(x, y, dir)
	elseif elecmoveID == id then
		elecmover(x, y, dir)
	elseif id == triplegenID then
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
	elseif id == fasteradvancerID then
		doSpecificAdvancer(x,y,dir,4)
	elseif id == deadbirdID then
		DoForceMover(x,y,1)
	elseif id == deadslowbirdID and halfdelay == true then
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
	elseif id == BModAIID then
		DoAI(x,y,dir)
	elseif id == electunnelID then
		electunnel(x,y,dir)
	end
	--cells[y][x].testvar = tostring(halfdelay)
	--cells[y][x].testvar = tostring(cells[y][x].ctype)
end

local function onEnemyDies(id,x,y)
	if id == bombID then
		RunModThing("bmod_bomb_dies", id, x, y)
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
		RunModThing("post_bmod_bomb_dies", id, x, y)
	elseif id == minibombID then
		RunModThing("bmod_bomb_dies", id, x, y)
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
		RunModThing("post_bmod_bomb_dies", id, x, y)
	end
end

local function onUnpause()
	isghostinitial = false
end

local function onReset()
	for y=0,height-1 do
		if not ghostcells[y] then ghostcells[y] = {} end
		if not ghostinitial[y] then ghostinitial[y] = {} end
		for x=0,width-1 do
			if not ghostcells[y][x] then ghostcells[y][x] = {} end
			if not ghostinitial[y][x] then ghostinitial[y][x] = {ctype = 0, rot = 0, lastvars = {x,y,0}} end
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
	if (original.ctype == spawnerID or original.ctype == rotateSpawnerID) and id ~= 0 and (id ~= spawnerID and id ~= rotateSpawnerID) then
		cells[y][x] = original
		cells[y][x].spawner_current = id
		cells[y][x].spawner_dir_off = (currentrot - cells[y][x].rot) % 4
		if isinitial then
			initial[y][x] = originalinit
		end
	elseif id == brainID then
		GiveNeuralNetwork(x, y)
	elseif id == waterID then
		Hidrate(x, y)
	elseif id == plantID and (original.ctype ~= soilID) then
		cells[y][x] = original
		if isinitial then
			initial[y][x] = originalinit
		end
	elseif id == randomizerID then
		DoRandomizer(x,y,rot)
	elseif id == ghostmoverID then
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
	elseif id == ghostcellID then
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
	elseif id == 0 then
		ghostcells[y][x].ctype = 0
		if isghostinitial then
			ghostinitial[y][x].ctype = 0
			ghostinitial[y][x].rot = 0
			ghostinitial[y][x].lastvars = {x,y,0}
		end
		cells[y][x] = {
			ctype = 0,
			rot = 0,
			lastvars = cells[y][x].lastvars
		}
	end
end

function DoSpawner(x, y, dir)
	if not cells[y][x].spawner_current or cells[y][x].spawner_dir_off == nil then return end

	local useGhost = false
	if cells[y][x].spawner_current == ghostcellID or cells[y][x].spawner_current == ghostmoverID then
		useGhost = true
		return
	end

	local cellBackup
	if useGhost then
		cellBackup = cells
		cells = ghostcells
	end

	PushCell(x,y,dir,false,1,cells[y][x].spawner_current,(dir+cells[y][x].spawner_dir_off)%4,true,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(dir)},false,false)

	if cells[y][x].spawner_current == brainID then
		local ox, oy = x, y
		if dir == 0 then ox = x + 1 elseif dir == 2 then ox = x - 1 end
		if dir == 1 then oy = y + 1 elseif dir == 3 then oy = y - 1 end
		GiveNeuralNetwork(ox, oy)
	end

	if useGhost then
		ghostcells = cells
		cells = cellBackup
	end

	if cells[y][x].ctype == rotateSpawnerID then
		rotateCell(x, y, 1)
	end
end

function SetSpawner(x, y, food)
	cells[y][x].spawner_current = food.ctype
	local dir = cells[y][x].rot
	cells[y][x].spawner_dir_off = 0
end

function onTrashEats(id, x, y, food, foodx, foody)
	if id == spawnerID or id == rotateSpawnerID then
		SetSpawner(x, y, food)
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
	onTrashEats = onTrashEats, 
	dependencies = {"B-Mod",name,name2},
	version = ver
}
