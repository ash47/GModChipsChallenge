/*---------------------------------------------------------
Server/blocks/31_wall_fake_real.lua
---------------------------------------------------------*/
local block = {}
block.ID = 31

// Block settings:
block.name = "Blue Block (becomes Wall)"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("fake_wall")
	
	// Make it turn into a wall:
	ent.FakeType = 1
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
