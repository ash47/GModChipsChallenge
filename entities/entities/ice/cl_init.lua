/*---------------------------------------------------------
entities/entities/ice/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

local mat = Material( "Ash47_CC/sprites/bot_12.png")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 0.05))
end

function ENT:Draw()
	self:DrawTile(mat)
end
