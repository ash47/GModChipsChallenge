/*---------------------------------------------------------
Server/ai/glider.lua

 - A glider
---------------------------------------------------------*/
local ai = {}

// Key Info:
ai.name = "Glider"

// Fire Solid:
ai.proof_water = true

/*
Direction notes:

1 = North
2 = West
3 = South
4 = East
*/

// Frames:
ai.frame = {}
ai.frame[1] = 80
ai.frame[2] = 81
ai.frame[3] = 82
ai.frame[4] = 83

// 3D Frames:
ai.frame3d = {}
ai.frame3d[1] = -80
ai.frame3d[2] = -81
ai.frame3d[3] = -82
ai.frame3d[4] = -83

local n = {}

// When the bug is facing north:
n[1] = {}
n[2] = {}
n[3] = {}
n[4] = {}

// The order we are gonna try and move in:

// Facing North:
n[1][1] = {0, -1, 1}	// North
n[1][2] = {-1, 0, 2}	// West
n[1][3] = {1, 0, 4}		// East
n[1][4] = {0, 1, 3}		// South

// Facing West:
n[2][1] = {-1, 0, 2}	// West
n[2][2] = {0, 1, 3}		// South
n[2][3] = {0, -1, 1}	// North
n[2][4] = {1, 0, 4}		// East

// Facing South:
n[3][1] = {0, 1, 3}		// South
n[3][2] = {1, 0, 4}		// East
n[3][3] = {-1, 0, 2}	// West
n[3][4] = {0, -1, 1}	// North

// Facing East:
n[4][1] = {1, 0, 4}		// East
n[4][2] = {0, -1, 1}	// North
n[4][3] = {0, 1, 3}		// South
n[4][4] = {-1, 0, 2}	// West

// Work out the next move, return the square to jump to:
// Note: Collision detection needs to be handled below!
function ai.NextMove(x, y, dir, sort)
	for k,v in pairs(n[dir]) do
		if check_solid_dir(x, v[1], y, v[2], sort) then
			return x + v[1], y + v[2], v[3]
		end
	end
	
	// We can't move anywhere
	return x, y, dir
end

// Registers it:
RegisterAI(ai)
