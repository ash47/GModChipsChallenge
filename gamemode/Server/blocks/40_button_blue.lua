/*---------------------------------------------------------
Server/blocks/40_button_blue.lua
---------------------------------------------------------*/
local block = {}
block.ID = 40

// Block settings:
block.name = "Button Blue"

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("button")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Used for img finding:
	ent:SetColor(Color(40,255,255,255))
	
	// Return the ent we just made:
	return ent
end

// This function is called when the block is pressed
function block.Press(ent)
	// Play the sound:
	if(ent and ent:IsValid()) then
		ent:EmitSound("Ash47_CC/pop2.wav")
	end
	
	// Turn on a blue button toggle:
	_tank_change_ = true
end
// Register the block:
RegisterBlock(block)
