/*---------------------------------------------------------
Server/blocks/10_dirt_block.lua
---------------------------------------------------------*/
local block = {}
block.ID = 10

// Block settings:
block.name = "Dirt Block"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("dirt_block")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
