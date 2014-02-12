/*---------------------------------------------------------
entities/entities/wall/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

//ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local mat = Material( "Ash47_CC/Sprites/bot_1.png", "alphatest")
//local mat = Material( "Ash47_CC/Tiles/1")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	// Draw a cube:
	self:DrawCubeNew(mat)
end
