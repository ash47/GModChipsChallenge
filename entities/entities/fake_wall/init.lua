/*---------------------------------------------------------
entities/entities/fake_wall/init.lua
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
		// Stop it from moving:
		phys:EnableMotion(false)
		
		// Stop it from making a noise:
		phys:SetMaterial("gmod_silent")
	end
end

function ENT:StartTouch( ent )
	// Make sure it's a player:
	if ent:GetClass() == "player" then
		// Check which type it is:
		if not self.FakeType then
			// Fake / Tile type:
			self:Remove()
		else
			// Turns into a wall:
			SpawnBlock(1, self._pos[1], self._pos[2])
			
			// Remove ourself:
			self:Remove()
		end
	end
end
