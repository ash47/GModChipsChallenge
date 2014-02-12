/*---------------------------------------------------------
Server/blocks/105_boots_fire.lua
---------------------------------------------------------*/
local block = {}
block.ID = 105

// Block settings:
block.name = "Fire Boots"

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
	ent:SetColor(Color(255, 0, 0, 255))
	
	// Set it to a lava shoe type:
	ent.shoetype = "lava"
	ent.shoenum = 2
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
