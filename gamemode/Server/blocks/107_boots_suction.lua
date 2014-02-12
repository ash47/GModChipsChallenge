/*---------------------------------------------------------
Server/blocks/107_boots_suction.lua
---------------------------------------------------------*/
local block = {}
block.ID = 107

// Block settings:
block.name = "Suction Boots"

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
	ent:SetColor(Color(0, 255, 0, 255))
	
	// Set it to a lava shoe type:
	ent.shoetype = "forcer"
	ent.shoenum = 4
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
