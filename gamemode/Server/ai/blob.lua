/*---------------------------------------------------------
Server/ai/blob.lua

 - A blob
---------------------------------------------------------*/
local ai = {}

// Key Info:
ai.name = "Blob"

/*
Direction notes:

1 = North
2 = West
3 = South
4 = East
*/

// Frames:
ai.frame = {}
ai.frame[1] = 92
ai.frame[2] = 92
ai.frame[3] = 92
ai.frame[4] = 92

// 3D Frames:
ai.frame3d = {}
ai.frame3d[1] = 92
ai.frame3d[2] = 92
ai.frame3d[3] = 92
ai.frame3d[4] = 92

// Work out the next move, return the square to jump to:
// Note: Collision detection needs to be handled below!
function ai.NextMove(x, y, dir, sort)
	local n = {}
	
	// Facing North:
	n[1] = {0, -1, 1}	// North
	n[2] = {-1, 0, 2}	// West
	n[3] = {0, 1, 3}	// South
	n[4] = {1, 0, 4}	// East
	
	while #n > 0 do
		// Pick a random direction:
		v = table.remove(n, math.random(1, #n))
		
		// Try and move there:
		if check_solid_dir(x, v[1], y, v[2], sort) then
			return x + v[1], y + v[2], v[3]
		end
	end
	
	// We can't move anywhere
	return x, y, dir
end

// Registers it:
RegisterAI(ai)
