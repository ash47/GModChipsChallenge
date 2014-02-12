/*---------------------------------------------------------
entities/entities/forcer/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 0.05))
	
	// Reset the material:
	self.mat = nil
end

function ENT:Draw()
	// Decide which material to draw:
	if not self.mat then
		// Grab our color:
		local col = self.Entity:GetColor()
		
		// Cyan Key:
		if col['g'] == 1 then
			self.mat = Material( "Ash47_CC/Sprites/bot_18.png" )
		// Yellow Key:
		elseif col['g'] == 2 then
			self.mat = Material( "Ash47_CC/Sprites/bot_20.png" )
		// Red Key:
		elseif col['g'] == 3 then
			self.mat = Material( "Ash47_CC/Sprites/bot_13.png" )
		// Green Key:
		elseif col['g'] == 4 then
			self.mat = Material( "Ash47_CC/Sprites/bot_19.png" )
		end
		
		// We can wait until next step to draw:
		return
	end
	
	// Draw the tile:
	self:DrawTile(self.mat)
end
