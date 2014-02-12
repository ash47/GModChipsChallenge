/*---------------------------------------------------------
Server/blocks/106_boots_ice.lua
---------------------------------------------------------*/
local block = {}
block.ID = 106

// Block settings:
block.name = "Ice Boots"

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create a colectable chip:
	ent = ents.Create("collect_shoe")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	ent:SetModel("models/props_junk/Shoe001a.mdl")
	
	// Spawn it:
	ent:Spawn()
	
	// Make it the fire boot:
	ent:SetColor(Color(0, 255, 255, 255))
	
	// Set it to a lava shoe type:
	ent.shoetype = "ice"
	ent.shoenum = 3
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
