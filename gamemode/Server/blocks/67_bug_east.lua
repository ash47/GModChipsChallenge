/*---------------------------------------------------------
Server/blocks/1_wall.lua
---------------------------------------------------------*/
local block = {}
block.ID = 67

// Block settings:
block.name = "Wall"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// Is ai:
block.ai = true

// ai type:
block.ai_type = "bug"

// ai dir:
block.dir = 4

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
