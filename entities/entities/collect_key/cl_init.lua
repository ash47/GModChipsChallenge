/*---------------------------------------------------------
entities/entities/collect_key/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	// Make sure it renders properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 127))
end

function ENT:Draw()
	// Decide which material to draw:
	if not self.mat then
		// Grab our color:
		local col = self.Entity:GetColor()
		
		// Cyan Key:
		if col['g'] == 255 and col['b'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_100.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_100.png" )
		// Yellow Key:
		elseif col['r'] == 255 and col['g'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_103.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_103.png" )
		// Red Key:
		elseif col['r'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_101.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_101.png" )
		// Green Key:
		elseif col['g'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_102.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_102.png" )
		end
		
		// We can wait until next step to draw:
		return
	end
	
	if _Map then
		self:DrawTile(self.mat)
	else
		self:DrawSprite(self.mata, 32, 32)
	end
end
