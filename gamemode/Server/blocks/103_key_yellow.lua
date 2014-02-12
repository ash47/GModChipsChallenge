/*---------------------------------------------------------
Server/blocks/103_key_yellow.lua
---------------------------------------------------------*/
local block = {}
block.ID = 103

// Block settings:
block.name = "Yellow Key"

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("collect_key")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Color it yellow:
	ent:SetColor(Color(255, 255, 0, 255))
	
	// Store the type:
	ent.KeyNum = 4
	
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
