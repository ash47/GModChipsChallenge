/*---------------------------------------------------------
entities/entities/ice/init.lua
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
	// Make sure the player doesn't have skates:
	if ent.shoes and (not ent.shoes["ice"]) then
		// Check if we need to change their direction:
		if not (ent.IceSail) or CurTime()-0.1 > ent.IceSail then
			// Reset the psh direction:
			ent.IceDir = Vector(0, 0, 0)
			
			// Find the difference between our positions:
			local dif = (self:GetPos() + self:OBBCenter()) - ent:GetPos()
			
			local dif1 = math.abs(dif[1])
			local dif2 = math.abs(dif[2])
			
			//if dif1 >= 48 and dif2 >= 48 then
			//	print("we should bounce them back :P")
			if dif1 < dif2 then
				if dif[2] < 0 then
					ent.IceDir = Vector(0, -1, 0)
				else
					ent.IceDir = Vector(0, 1, 0)
				end
				
				// Used to force them into the middle of the square:
				ent.IceFix = Vector(0.01, 0, 0)
			else
				if dif[1] < 0 then
					ent.IceDir = Vector(-1, 0, 0)
				else
					ent.IceDir = Vector(1, 0, 0)
				end
				
				// Used to force them into the middle of the square:
				ent.IceFix = Vector(0, 0.01, 0)
			end
		end
		
		// Store the entities old pos:
		ent.oldpos = Vector(10,20,30)
	end
end

function ENT:Touch( ent )
	// Do they have the shoe?
	if ent.shoes and (not ent.shoes["ice"]) then
		// Workout how far off center we are:
		local fix = (self:GetPos() + self:OBBCenter() - ent:GetPos()) * ent.IceFix
		
		// Push the player:
		ent:SetLocalVelocity((ent.IceDir + fix)*500)
		
		// Bounce against walls:
		if ent:GetPos()*ent.IceDir == ent.oldpos then
			if CurTime()-0.001 > ent.IceSail then
				// Reverse the direction:
				ent.IceDir = ent.IceDir * -1
				
				// Stop us from double bouncing:
				ent.IceSail = CurTime()+0.025
				//print("REVERSE!")
			end
		else
			ent.IceSail = CurTime()
		end
		
		// Update their old positoion:
		ent.oldpos = ent:GetPos()*ent.IceDir
	end
end
