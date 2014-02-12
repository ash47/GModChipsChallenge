/*---------------------------------------------------------
entities/entities/key_door/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	// Decide which material to draw:
	if not self.mat then
		// Grab our color:
		local col = self.Entity:GetColor()
		
		// Cyan Key:
		if col['g'] == 255 and col['b'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_22.png", "alphatest")
			//self.mat = Material( "Ash47_CC/Tiles/22.png" )
		// Yellow Key:
		elseif col['r'] == 255 and col['g'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_25.png", "alphatest")
			//self.mat = Material( "Ash47_CC/Tiles/25.png" )
		// Red Key:
		elseif col['r'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_23.png", "alphatest")
			//self.mat = Material( "Ash47_CC/Tiles/23.png" )
		// Green Key:
		elseif col['g'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_24.png", "alphatest")
			//self.mat = Material( "Ash47_CC/Tiles/24.png" )
		end
		
		// We can wait until next step to draw:
		return
	end
	
	// Draw a cube:
	self:DrawCubeNew(self.mat)
end
