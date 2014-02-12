/*---------------------------------------------------------
entities/entities/pass_once/init.lua
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
	
	// A list of players who have touched this:
	self.PwnList = {}
end

function ENT:StartTouch( ent )
	// Make sure the player doesn't have skates:
	if self.PwnList[ent] then
		// Reset the push direction:
		ent.IceDir = Vector(0, 0, 0)
		
		// Find the difference between our positions:
		local dif = (self:GetPos() + self:OBBCenter()) - ent:GetPos()
		
		local dif1 = math.abs(dif[1])
		local dif2 = math.abs(dif[2])
		
		if dif1 < dif2 then
			if dif[2] < 0 then
				ent.IceDir = Vector(0, 1, 0)
			else
				ent.IceDir = Vector(0, -1, 0)
			end
		else
			if dif[1] < 0 then
				ent.IceDir = Vector(1, 0, 0)
			else
				ent.IceDir = Vector(-1, 0, 0)
			end
		end
	else
		if ent:IsPlayer() then
			net.Start("TurnOn")
			net.WriteEntity(self)
			net.Send(ent)
		end
	end
end

function ENT:EndTouch( ent )
	if ent:IsPlayer() then
		self.PwnList[ent] = true
	end
end

function ENT:Touch( ent )
	if self.PwnList[ent] and ent.IceDir then
		// Push the player:
		ent:SetLocalVelocity(ent.IceDir*500)
	end
end
