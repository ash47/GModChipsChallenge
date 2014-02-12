/*---------------------------------------------------------
entities/entities/chip_socket/init.lua
---------------------------------------------------------*/

// Send the poo:
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	// Collision mask for collecting:
	self:SetCollisionBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
	
	// Make it touchable:
	self:SetSolid(SOLID_BBOX)
	
	// Disable the shadow:
	self:DrawShadow(false)
	
	// Stop it from moving:
	self:SetMoveType(MOVETYPE_NONE)
	
	// Grab the physics object:
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		// Stop it from making noises:
		phys:SetMaterial("gmod_silent")
		
		// Stop it from moving:
		phys:EnableMotion(false)
	end
end

function ENT:StartTouch( ent )
	// Make sure it's a player:
	if ent:GetClass() == "player" then
		// Check if we have all the chips:
		if _TotalChips <= 0 then
			// Remove the door:
			self:Remove()
		end
	end
end
