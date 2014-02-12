/*---------------------------------------------------------
Server/blocks/6_blocked_north.lua
---------------------------------------------------------*/
local block = {}
block.ID = 6

// Block settings:
block.name = "Blocked North"

// Block shit:
block.s_n = true

// Request a world entity:
AddWorldModel("template_06", block.ID, "model")

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
