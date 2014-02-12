/*---------------------------------------------------------
Shared/uTil.lua

 - Contains Utilities
---------------------------------------------------------*/

// Grab the entity meta table:
local meta = FindMetaTable("Entity")

// Fixes the difference beteen local and world positions:
function meta:SetFuckingPos(pos)
	// Grab the key points of the model:
	local mid = self:OBBCenter()	// The middle of the model
	local low = self:OBBMins()		// The bottom left of the model
	
	// Assuming 128 X 128 tiles, this puts the entity in the middle
	// It also puts it so it JUST touches the ground
	self:SetPos(pos - mid + Vector(64, -64, mid[3]-low[3]))
end
