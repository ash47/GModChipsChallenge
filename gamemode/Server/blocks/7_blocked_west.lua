/*---------------------------------------------------------
Server/blocks/7_blocked_west.lua
---------------------------------------------------------*/
local block = {}
block.ID = 7

// Block settings:
block.name = "Blocked West"

// Block shit:
block.s_w = true

// Request a world entity:
AddWorldModel("template_07", block.ID, "model")

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("func_wall")
	
	// Set the model:
	ent:SetModel(self["model"])
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
