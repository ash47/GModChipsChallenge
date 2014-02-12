/*---------------------------------------------------------
Server/blocks/18_force_north.lua
---------------------------------------------------------*/
local block = {}
block.ID = 18

// Block settings:
block.name = "Force North"

// Force AIs:
block.ai_land = function(ai, dir)
	_ai[ai][5] = 1
end

//AddWorldModel("template_18", block.ID, "model")

function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("forcer")
	
	// Set the color (for texture):
	ent:SetColor(Color(255, 1, 255, 255))
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	ent.Dir = Vector(0,1,0)
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
