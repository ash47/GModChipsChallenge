/*---------------------------------------------------------
entities/entities/button/init.lua
---------------------------------------------------------*/

// Send the poo:
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	// Collision mask for collecting:
	self:SetCollisionBounds(Vector(-64, -64, 0), Vector(64, 64, 0.05))
	
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
	if ent:IsPlayer() then
		if self.PressFunction then
			self.PressFunction(self)
		end
	end
end
