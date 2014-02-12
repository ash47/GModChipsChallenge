/*---------------------------------------------------------
Server/blocks/4_fire.lua
---------------------------------------------------------*/
local block = {}
block.ID = 33

// Block settings:
block.name = "Thief"

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("thief")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
