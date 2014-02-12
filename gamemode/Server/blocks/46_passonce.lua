/*---------------------------------------------------------
Server/blocks/46_passonce.lua
---------------------------------------------------------*/
local block = {}
block.ID = 46

// Block settings:
block.name = "Pass Once"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("pass_once")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
