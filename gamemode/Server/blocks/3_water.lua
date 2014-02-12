/*---------------------------------------------------------
Server/blocks/3_water.lua
---------------------------------------------------------*/
local block = {}
block.ID = 3

// Block settings:
block.name = "Water"

// When an ai lands on this block:
block.ai_land = function(ai)
	// Grab the ai type:
	local t = _ai[ai][1]
	
	// Check if it's fire proof:
	if _ai_types[t] and _ai_types[t].proof_water then return end
	
	// KILL IT:
	ai_remove(ai)
end

function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("water")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
