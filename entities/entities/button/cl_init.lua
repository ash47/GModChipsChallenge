/*---------------------------------------------------------
entities/entities/button/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	local mat = Material("Ash47_CC/Sprites/bot_"..(self.Entity:GetColor()['r']..".png"))
	
	self:DrawTile(mat)
end
