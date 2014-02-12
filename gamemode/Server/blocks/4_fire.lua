/*---------------------------------------------------------
Server/blocks/4_fire.lua
---------------------------------------------------------*/
local block = {}
block.ID = 4

// Block settings:
block.name = "Fire"

// When an ai lands on this block:
block.ai_land = function(ai)
	// Grab the ai type:
	local t = _ai[ai][1]
	
	// Check if it's fire proof:
	if _ai_types[t] and _ai_types[t].proof_fire then return end
	
	// KILL IT:
	ai_remove(ai)
end

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("fire")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
