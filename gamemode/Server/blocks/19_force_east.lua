/*---------------------------------------------------------
Server/blocks/19_force_east.lua
---------------------------------------------------------*/
local block = {}
block.ID = 19

// Block settings:
block.name = "Force East"

// Force AIs:
block.ai_land = function(ai, dir)
	_ai[ai][5] = 4
end

//AddWorldModel("template_19", block.ID, "model")

function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("forcer")
	
	// Set the color (for texture):
	ent:SetColor(Color(255, 4, 255, 255))
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	ent.Dir = Vector(1,0,0)
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
