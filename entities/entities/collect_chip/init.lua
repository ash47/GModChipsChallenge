/*---------------------------------------------------------
entities/entities/collect_chip/init.lua
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

function ENT:StartTouch(activator,caller)
	self:EmitSound("Ash47_CC/click3.wav")
	CollectChip(activator)
	self:Remove()
	
	// Remove it from the global grid:
	if(_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]] == 10) then
		_CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]] = 0
		DeleteEntityTable(_CurrentLevel.ent_Layer_Two[self._pos[1]][self._pos[2]])
	else
		_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]] = 0
		DeleteEntityTable(_CurrentLevel.ent_Layer_One[self._pos[1]][self._pos[2]])
	end
end

//function ENT:Think()
//end
