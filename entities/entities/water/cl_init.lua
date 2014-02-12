/*---------------------------------------------------------
entities/entities/water/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local mat = Material( "Ash47_CC/Sprites/bot_3.png")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 0.05))
end

function ENT:Draw()
	self:DrawTile(mat)
end
