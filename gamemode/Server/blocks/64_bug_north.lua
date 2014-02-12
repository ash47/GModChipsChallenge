/*---------------------------------------------------------
Server/blocks/64_bug_north.lua
---------------------------------------------------------*/
local block = {}
block.ID = 64

// Block settings:
block.name = "Bug North"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// Is ai:
block.ai = true

// ai type:
block.ai_type = "bug"

// ai dir:
block.dir = 1

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
