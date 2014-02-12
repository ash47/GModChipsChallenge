/*---------------------------------------------------------
Server/blocks/35_button_green.lua
---------------------------------------------------------*/
local block = {}
block.ID = 35

// Block settings:
block.name = "Button Green"

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("button")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Used for img finding:
	ent:SetColor(Color(35,255,255,255))
	
	// Return the ent we just made:
	return ent
end

// This function is called when the block is pressed
function block.Press(ent)
	// Play the sound:
	if(ent and ent:IsValid()) then
		ent:EmitSound("Ash47_CC/pop2.wav")
	end
	
	// Toggle the button:
	if _Green_Switch and _Green_Switch == 1 then
		_Green_Switch = 0
	else
		_Green_Switch = 1
	end
	
	// Send the change to the clients:
	net.Start("GreenMode")
	net.WriteInt(_Green_Switch, 2)
	net.Broadcast()
end

// Register the block:
RegisterBlock(block)
