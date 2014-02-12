/*---------------------------------------------------------
Server/blocks/12_ice.lua
---------------------------------------------------------*/
local block = {}
block.ID = 12

// Block settings:
block.name = "Ice"

// Allow ai to slide on ice:
block.ai_land = function(ai, dir, _x, _y)
	// Ensure dir is positive:
	dir = math.abs(dir)
	
	local iced = {}
	iced[1] = {0, -1, 3}	// North
	iced[2] = {-1, 0, 4}	// West
	iced[3] = {0, 1, 1}		// South
	iced[4] = {1, 0, 2}		// East
	
	// Check direction:
	local to_check = iced[dir]
	
	// Check if we can move there:
	if check_solid_dir(_x, to_check[1], _y, to_check[2], _ai[ai][1]) then
		// Enable auto movement:
		_ai[ai][4] = dir
		_ai[ai][5] = dir
	else
		// Update dir:
		local dir2 = to_check[3]
		
		// Check opposite dir:
		to_check = iced[to_check[3]]
		if check_solid_dir(_x, to_check[1], _y, to_check[2], _ai[ai][1]) then
			// Enable auto movement:
			_ai[ai][4] = dir2
			_ai[ai][5] = dir2
		else
			_ai[ai][4] = dir
			_ai[ai][5] = dir
		end
	end
end

function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("ice")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
