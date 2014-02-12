/*---------------------------------------------------------
Server/blocks/102_key_green.lua
---------------------------------------------------------*/
local block = {}
block.ID = 102

// Block settings:
block.name = "Green Key"

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("collect_key")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Color it green:
	ent:SetColor(Color(0, 255, 0, 255))
	
	// Store the type:
	ent.KeyNum = 3
	
	// Grab the physics object:
	local phys = ent:GetPhysicsObject();
	if phys:IsValid() then
		// Stop it from making noises:
		phys:SetMaterial("gmod_silent")
	end
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
