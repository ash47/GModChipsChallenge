/*---------------------------------------------------------
entities/entities/thief/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

local mat = Material( "Ash47_CC/Sprites/bot_33.png" )
local mata = Material( "Ash47_CC/Sprites/top_33.png" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
end

function ENT:Draw()
	if _Map then
		self:DrawTile(mat)
	else
		self:DrawSprite(mata, 32, 64)
	end
end
