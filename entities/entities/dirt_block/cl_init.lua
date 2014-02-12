/*---------------------------------------------------------
entities/entities/dirt_block/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

local mat = Material( "Ash47_CC/Sprites/bot_10.png", "alphatest")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	// Draw a cube:
	self:DrawCube(mat)
end
