/*---------------------------------------------------------
entities/entities/dirt/init.lua
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

function ENT:StartTouch( ent )
	// Unlock the door:
	if ent.keys and ent.keys[self.KeyNum] and ent.keys[self.KeyNum] > 0 then
		// Play the door sound:
		self:EmitSound("Ash47_CC/door.wav")
		
		// Remove ourself:
		DeleteEntityTable(_CurrentLevel.ent_Layer_One[self._pos[1]][self._pos[2]])
		
		// Remove it from the global grid:
		local n = _CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]]
		_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]] = n
		_CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]] = 0
		
		// Spawn it:
		SpawnBlock(_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]], self._pos[1], self._pos[2])
		
		// Don't remove green keys:
		if self.KeyNum == 3 then return end
		
		// Remove the key from the player:
		ent.keys[self.KeyNum] = ent.keys[self.KeyNum] - 1
		
		// Look at each element:
		for k, v in pairs(ent._keys) do
			// If we find a matching key:
			if v[1] == self.KeyNum then
				// Remove it and stop:
				table.remove(ent._keys, k)
				break
			end
		end
		
		// Tell the player they lost a key:
		net.Start("Inv")
		net.WriteInt(self.KeyNum + 4, 16)
		net.WriteInt(ent.keys[self.KeyNum], 16)
		net.Send(ent)
	end
end
