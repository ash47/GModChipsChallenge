/*---------------------------------------------------------
entities/entities/pass_once/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

local closed  = Material("Ash47_CC/Sprites/bot_37.png")
local open = Material("Ash47_CC/Sprites/bot_38.png")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 0.05))
end

function ENT:Draw()
	local on = false
	
	/* Flip if opposite*/
	if self.Entity:GetColor()['r'] ~= 255 then
		on = not on
	end
	
	/* Flip of green is on */
	if _Green_Switch and _Green_Switch == 1 then
		on = not on
	end
	
	/* Draw based on the 'on' value */
	if on then
		self:DrawTile(open)
	else
		self:DrawTile(closed)
	end
end
