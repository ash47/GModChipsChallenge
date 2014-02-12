/*---------------------------------------------------------
Server/blocks/47_hint.lua
---------------------------------------------------------*/
local block = {}
block.ID = 47

// Block settings:
block.name = "Hint"

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("hint")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
