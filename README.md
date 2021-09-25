# CelLua B-Mod
Its like CelLua except its my mod of it.

## Running
Install Love2d game engine here: https://love2d.org
and download one of the releases, and then run it!

## Features
CelLua B-Mod includes a double enemy that has to be hit twice and a triple generator that copies the block behind it to all 3 directions

## All Cells
### These are in subticking order (and include the regular game ones)
Randomizer Cell: Turns into a random cell at the start of the tick.
Mirror Cell: It switches the cell at its arrows around.
Generator Cell: Duplicates the cell behind it to its front.
Sideways Generator Cell: Duplicates the cell behind it to its side.
Tunnel Cell: Takes the cell behind it and puts it infront of it
Splitter Cell: Takes a cell at the back and turns it into 2 at its sides.
Triple Generator Cell: Duplicates the cell behind it into all 3 other directions.
Mold Cell: If duplicated it doesnt appear but still pushes.
Rotator Cell: Rotates cells next to it.
Gear Cell: Makes cells spin around it.
Redirector Cell: Makes cells touching it turn into the direction its facing.
Repulsor Cell: Pushes cells next to it away.
Black Hole Cell: Pulls nearby cells towards it.
Puller Cell: Moves forward and pulls things behind it along with it.
Slow Puller Cell: Puller Cell except it goes forward every other tick.
Mover Cell: Goes forward and pushes cells infront of it aswell.
Slow Mover Cell: Mover Cell except it goes forward every other tick.
Trash Hole Cell: Deletes a 3x3 area around it constantly.

####Not in subticking.
Time Stop Cell: Makes cells next to it stop doing stuff.
Enemy Cell: Can get hit by a single cell but after that it dissapears and the cell that hit it does too.
Double Enemy Cell: Enemy but can get hit twice.
Bomb Cell: Acts as an enemy but when it gets hits it explodes a 5x5 area around it.
Mini Bomb Cell: Bomb but it explodes a 3x3 area.
