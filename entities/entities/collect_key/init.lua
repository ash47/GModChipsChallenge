/*---------------------------------------------------------
entities/entities/collect_key/init.lua
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
	// Check if it's not a green key:
	if self.KeyNum ~= 3 then
		// Give them the shoe:
		activator.keys[self.KeyNum] = (activator.keys[self.KeyNum] or 0) + 1
		
		// Store a key to reset:
		table.insert(activator._keys,{self.KeyNum, self._pos[1], self._pos[2]})
		
		// Remove the key:
		self:Remove()
		
		// Remove it from the global grid:
		_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]] = 0
	else
		// Check if they already had a green key:
		if not activator.keys[self.KeyNum] then
			// Store that they got a green key:
			activator.keys[self.KeyNum] = 1
		else
			return
		end
	end
	
	/// Play the sound:
	self:EmitSound("Ash47_CC/blip2.wav")
	
	// Tell them they got a key:
	net.Start("Inv")
	net.WriteInt(self.KeyNum + 4, 16)
	net.WriteInt(activator.keys[self.KeyNum], 16)
	net.Send(activator)
end
