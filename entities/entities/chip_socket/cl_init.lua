/*---------------------------------------------------------
entities/entities/chip_socket/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local mat = Material( "Ash47_CC/Sprites/bot_34.png" )
local mata = Material( "Ash47_CC/Sprites/top_34.png" )

function ENT:Initialize()
	// Make sure it renders properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	if _Map then
		self:DrawTile(mat)
	else
		self:DrawSprite(mata, 32, 64)
	end
end
