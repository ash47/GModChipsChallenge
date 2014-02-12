/*---------------------------------------------------------
entities/entities/collect_shoe/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	// Make sure it renders properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	// Decide which material to draw:
	if not self.mat then
		// Grab our color:
		local col = self.Entity:GetColor()
		
		// Ice Skates:
		if col['g'] == 255 and col['b'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_106.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_106.png" )
		// Flippers:
		elseif col['b'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_104.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_104.png" )
		// Fire Proof Boots:
		elseif col['r'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_105.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_105.png" )
		// Suction Boots:
		elseif col['g'] == 255 then
			self.mat = Material( "Ash47_CC/Sprites/bot_107.png" )
			self.mata = Material( "Ash47_CC/Sprites/top_107.png" )
		end
		
		// We can wait until next step to draw:
		return
	end
	
	if _Map then
		self:DrawTile(self.mat)
	else
		self:DrawSprite(self.mata, 32, 64)
	end
end