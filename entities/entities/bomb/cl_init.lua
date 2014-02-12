/*---------------------------------------------------------
entities/entities/bomb/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

local mat = Material( "Ash47_CC/Sprites/bot_42.png" )
local mata = Material( "Ash47_CC/Sprites/top_42.png" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	if _Map then
		self:DrawTile(mat)
	else
		self:DrawSprite(mata, 54, 128)
	end
end
