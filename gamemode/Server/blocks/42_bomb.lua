/*---------------------------------------------------------
Server/blocks/42_bomb.lua
---------------------------------------------------------*/
local block = {}
block.ID = 42
// Block settings:
block.name = "Bomb"

// When an ai lands on this block:
block.ai_land = function(ai, dir, k, kk, me)
	// Grab the ai type:
	local t = _ai[ai][1]
	
	// Check if it's fire proof:
	if _ai_types[t] and _ai_types[t].proof_bomb then return end
	
	// KILL IT:
	ai_remove(ai)
	
	// We also need to kill ourself:
	Remove_From_Layer(me, k, kk)
end

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("bomb")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
