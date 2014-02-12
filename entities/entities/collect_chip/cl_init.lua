/*---------------------------------------------------------
entities/entities/collect_chip/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

// Set the material to draw:
local mat = Material( "Ash47_CC/Sprites/bot_2.png" )
local mata = Material( "Ash47_CC/Sprites/top_2.png" )

function ENT:Initialize()
	// Make sure it renders properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	if _Map then
		self:DrawTile(mat)
	else
		self:DrawSprite(mata, 32, 32)
	end
end
