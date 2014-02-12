/*---------------------------------------------------------
Server/blocks/44_wall_invisible_appear.lua
---------------------------------------------------------*/
local block = {}
block.ID = 44

// Block settings:
block.name = "Invisible Wall (will appear)"

// Block Solid
block.bs = true

// AI Solid:
block.ais = true

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("fake_wall")
	
	// Make it turn into a wall:
	ent.FakeType = 2
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
