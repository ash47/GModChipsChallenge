/*---------------------------------------------------------
entities/entities/monster/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

// Set the material to draw:
local mat = Material( "Ash47_CC/Sprites/bot_64.png" )
local mata = Material( "Ash47_CC/Sprites/top_64.png" )

function ENT:Initialize()
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	// Grab our material:
	local img = self:GetNetworkedInt("f")
	local img3d = self:GetNetworkedInt("g")
	
	// Render the map view:
	if _Map then
		// Try and grab the material:
		if img then
			mat = Material("Ash47_CC/Sprites/top_"..img..".png")
		end
		
		self:DrawTile(mat)
	// Render the 3D top down view:
	elseif img3d < 0 then
		// Try and grab the material:
		if img then
			mat = Material("Ash47_CC/Sprites/top_"..(img3d*-1)..".png")
		end
		
		self:DrawTile(mat)
	// Render the 3D view:
	else
		if img3d then
			mat = Material("Ash47_CC/Sprites/top_"..img3d..".png")
		end
		
		self:DrawSprite(mat, 32, 64)
	end
end
