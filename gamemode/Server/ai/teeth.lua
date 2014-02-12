/*---------------------------------------------------------
Server/ai/teeth.lua

 - The dreaded TEETH
---------------------------------------------------------*/
local ai = {}

// Key Info:
ai.name = "Teeth"

/*
Direction notes:

1 = North
2 = West
3 = South
4 = East
*/

// Frames:
ai.frame = {}
ai.frame[1] = 84
ai.frame[2] = 85
ai.frame[3] = 86
ai.frame[4] = 87
ai.frame[-1] = 84
ai.frame[-2] = 85
ai.frame[-3] = 86
ai.frame[-4] = 87

// 3D Frames:
ai.frame3d = {}
ai.frame3d[1] = 86
ai.frame3d[2] = 86
ai.frame3d[3] = 86
ai.frame3d[4] = 86
ai.frame3d[-1] = 86
ai.frame3d[-2] = 86
ai.frame3d[-3] = 86
ai.frame3d[-4] = 86

// Work out the next move, return the square to jump to:
// Note: Collision detection needs to be handled below!
function ai.NextMove(x, y, dir, sort)
	// Check if it's an odd move:
	if(dir < 0) then
		return x, y, -dir
	end
	
	// Teeth don't move if no one is on:
	if #player.GetAll() == 0 then
		return x, y, -dir
	end
	
	// The distance to the closest player:
	local mindist = 9999
	
	// The cloest player:
	local ply = nil
	
	// find the NEAREST PLAYER:
	for k,v in pairs(player.GetAll()) do
		if v:IsValid() and v:Alive() then
			local pos = v:GetPos()
			
			// The player's position:
			local xto = math.floor(pos[1]/128)
			local yto = (math.floor(pos[2]/128) * -1) - 1
			
			// Workout how far to that player:
			local dist = math.sqrt((x - xto)*(x - xto) + (y - yto)*(y - yto))
			
			// Check if it is less than our last guy:
			if dist < mindist then
				// Store it:
				mindist = dist
				ply = v
			end
		end
	end
	
	// Check if we found a player:
	if ply then
		local pos = ply:GetPos()
		
		// The player's position:
		local xto = math.floor(pos[1]/128)
		local yto = (math.floor(pos[2]/128) * -1) - 1
		
		// Workout the difference in our positions:
		local xdif = math.abs(xto - x)
		local ydif = math.abs(yto - y)
		
		// Decide which way to try and move first:
		if ydif >= xdif then
			// Y first:
			if yto > y then
				// Try and move south:
				if check_solid_dir(x, 0, y, 1, sort) then
					return x, y + 1, -3
				end
			else
				// Try and move north:
				if check_solid_dir(x, 0, y, -1, sort) then
					return x, y - 1, -1
				end
			end
			
			if xto ~= x then
				// Try and move side ways:
				if xto > x then
					// Try and move East:
					if check_solid_dir(x, 1, y, 0, sort) then
						return x + 1, y, -4
					end
				else
					// Try and move West:
					if check_solid_dir(x, -1, y, 0, sort) then
						return x - 1, y, -2
					end
				end
			end
		else
			// X first:
			if xto > x then
				// Try and move East:
				if check_solid_dir(x, 1, y, 0, sort) then
					return x + 1, y, -4
				end
			else
				// Try and move West:
				if check_solid_dir(x, -1, y, 0, sort) then
					return x - 1, y, -2
				end
			end
			
			if yto ~= y then
				// Try and move up / down:
				if yto > y then
					// Try and move south:
					if check_solid_dir(x, 0, y, 1, sort) then
						return x, y + 1, -3
					end
				else
					// Try and move north:
					if check_solid_dir(x, 0, y, -1, sort) then
						return x, y - 1, -1
					end
				end
			end
		end
		
		if ydif >= xdif then
			if yto > y then
				dir = 3
			else
				dir = 1
			end
		else
			if xto > x then
				dir = 4
			else
				dir = 2
			end
		end
	end
	
	// We can't move anywhere
	return x, y, -dir
end

// Registers it:
RegisterAI(ai)
