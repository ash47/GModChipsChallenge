/*---------------------------------------------------------
Server/blocks/5_wall_invisible.lua
---------------------------------------------------------*/
local block = {}
block.ID = 5

// Block settings:
block.name = "Invisible Wall"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("wall_invis")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	//ent:SetColor(Color(255, 255, 255, 0))
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
