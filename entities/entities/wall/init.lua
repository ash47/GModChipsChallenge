/*---------------------------------------------------------
entities/entities/wall/init.lua
---------------------------------------------------------*/

// Send the poo:
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	// Collision mask for collecting:
	self:SetCollisionBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
	
	// Make it solid:
	self:SetSolid(SOLID_BBOX)
	
	// Disable the shadow:
	self:DrawShadow(false)
	
	// Disable movement:
	self:SetMoveType(MOVETYPE_NONE)
	
	// Grab the physics object:
	local phys = ent:GetPhysicsObject();
	if phys:IsValid() then
		// Stop it from making noises:
		phys:SetMaterial("gmod_silent")
		
		// Stop it from moving:
		phys:EnableMotion(false)
	end
end
