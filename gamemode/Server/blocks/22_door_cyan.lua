/*---------------------------------------------------------
Server/blocks/22_door_cyan.lua
---------------------------------------------------------*/
local block = {}
block.ID = 22

// Block settings:
block.name = "Blue Door"

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
	ent.KeyNum = 1
	
	// Spawn it:
	ent:Spawn()
	
	// Color it blue:
	ent:SetColor(Color(0, 255, 255, 255))
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
