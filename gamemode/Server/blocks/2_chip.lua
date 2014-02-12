/*---------------------------------------------------------
Server/blocks/2_chip.lua
---------------------------------------------------------*/
local block = {}
block.ID = 2

// Block settings:
block.name = "Chip"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("collect_chip")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
