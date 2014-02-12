/*---------------------------------------------------------
Server/ai/tank.lua

 - A tank
---------------------------------------------------------*/
local ai = {}

// Key Info:
ai.name = "Tank"

/*
Direction notes:

1 = North
2 = West
3 = South
4 = East
*/

// Frames:
ai.frame = {}
ai.frame[1] = 76
ai.frame[2] = 77
ai.frame[3] = 78
ai.frame[4] = 79

// 3D Frames:
ai.frame3d = {}
ai.frame3d[1] = -76
ai.frame3d[2] = -77
ai.frame3d[3] = -78
ai.frame3d[4] = -79

local n = {}

// The order we are gonna try and move in:

n[1] = {0, -1, 1}	// North
n[2] = {-1, 0, 2}	// West
n[3] = {0, 1, 3}	// South
n[4] = {1, 0, 4}	// East

local d = {}
d[1] = 3
d[2] = 4
d[3] = 1
d[4] = 2

// Work out the next move, return the square to jump to:
// Note: Collision detection needs to be handled below!
function ai.NextMove(x, y, dir, sort)
	// Grab the dir:
	local newdir = dir
	
	// Turn around:
	if _tank_change then
		newdir = d[dir]
	end
	
	// Only move if we are facing the same way:
	if newdir == dir then
		// Grab the next pos:
		v = n[dir]
		
		// Check if we can move:
		if check_solid_dir(x, v[1], y, v[2], sort) then
			return x + v[1], y + v[2], newdir
		end
	end
	
	// We can't move anywhere
	return x, y, newdir
end

// Registers it:
RegisterAI(ai)
