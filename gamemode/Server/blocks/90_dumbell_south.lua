/*---------------------------------------------------------
Server/blocks/90_dumbell_south.lua
---------------------------------------------------------*/
local block = {}
block.ID = 90

// Block settings:
block.name = "Dumbell South"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// Is ai:
block.ai = true

// ai type:
block.ai_type = "Dumbell"

// ai dir:
block.dir = 3

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("monster")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
