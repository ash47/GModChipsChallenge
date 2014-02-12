/*---------------------------------------------------------
Server/blocks/37_green_switched.lua
---------------------------------------------------------*/
local block = {}
block.ID = 37

// Block settings:
block.name = "Switch Block Closed"

// Block Solid
block.bs_custom = function()
	if _Green_Switch and _Green_Switch == 1 then
		return false
	else
		return true
	end
end

// AI Solid:
block.ais_custom = function()
	if _Green_Switch and _Green_Switch == 1 then
		return false
	else
		return true
	end
end

// The function you call to spawn this block:
function block:Spawn(pos)
	// Create the entity stored on us:
	ent = ents.Create("switch_block")
	
	// Set the position:
	ent:SetFuckingPos(pos)
	
	// Spawn it:
	ent:Spawn()
	
	// Set it to be closed:
	ent:SetColor(Color(255, 255, 255, 255))
	
	// Return the ent we just made:
	return ent
end

// Register the block:
RegisterBlock(block)
