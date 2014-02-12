/*---------------------------------------------------------
Server/blocks/25_door_yellow.lua
---------------------------------------------------------*/
local block = {}
block.ID = 25

// Block settings:
block.name = "Yellow Door"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("key_door")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Set the key type:
	ent.KeyNum = 4
	
	// Spawn it:
	ent:Spawn()
	
	// Color it yellow:
	ent:SetColor(Color(255, 255, 0, 255))
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
