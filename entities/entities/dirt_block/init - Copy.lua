/*---------------------------------------------------------
entities/entities/dirt_block/init.lua
---------------------------------------------------------*/

// Send the poo:
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	// Make it solid:
	self:PhysicsInit(SOLID_BSP)
	self:SetSolid(SOLID_BSP)
	
	// Enable drawing:
	self:SetNoDraw( false )
	
	// Disable motion:
	self:disableMotion()
end

// Enable motion:
function ENT:enableMotion()
	self:SetMoveType(MOVETYPE_NOCLIP)
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		phys:EnableMotion(true)
	end
end

// Disable motion:
function ENT:disableMotion()
	self:SetMoveType(MOVETYPE_NONE)
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:SetMaterial("gmod_silent")
	end
end

function ENT:RemoveBlock()
	// Remove ourself from the map:
	local n = _CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]]
	_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]] = n
	_CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]] = 0
	
	// Try and spawn the block:
	SpawnBlock(n, self._pos[1], self._pos[2])
end

function ENT:StartTouch( ent )
	// Make sure the player doesn't have skates:
	if ent:GetClass() == "player" then
		// Find the difference between our positions:
		local dif = (self:GetPos() + self:OBBCenter()) - ent:GetPos()
		
		local dif1 = math.abs(dif[1])
		local dif2 = math.abs(dif[2])
		
		// The way we are gonna try and move:
		k  = 0;
		kk = 0;
		
		if dif1 < 48 and dif2 < 48 then
			// We crushed a player:
			ent:kill()
		elseif dif1 < dif2 then
			if dif[2] < 0 then
				kk = 1
			else
				kk = -1
			end
		else
			if dif[1] < 0 then
				k = -1
			else
				k = 1
			end
		end
		
		// Read what is on the square we are trying to move to:
		local t = _CurrentLevel.Layer_One[(self._pos[1] + k)][(self._pos[2] + kk)] or 1
		
		if t == 0 or (not _Blocks[t]) or (not _Blocks[t].bs) then
			// The position we are moving to:
			local newk = self._pos[1] + k
			local newkk = self._pos[2] + kk
			
			// Check if we need to convert water to dirt:
			if t == 3 then
				// Dirt number:
				local dirtn = 11
				
				// Try and spawn the block:
				if _Blocks[dirtn] then
					// Play the splash noise:
					self:EmitSound("Ash47_CC/water2.wav")
					
					// Delete the dirt block:
					self:RemoveBlock()
					
					// Remove water:
					DeleteEntityTable(_CurrentLevel.ent_Layer_One[newk][newkk])
					
					// Spawn the dirt:
					SpawnBlock(dirtn, newk, newkk)
					
					// Convert to dirt:
					_CurrentLevel.Layer_One[newk][newkk] = dirtn
					
					// Remove ourself:
					self:Remove()
					
					// Stop the script:
					return
				end
			end
			
			// Enable motion:
			self:enableMotion()
			
			self:RemoveBlock()
			
			// Move the block:
			self:SetPos(self:GetPos() + Vector(k * 128, kk * -128, 0))
			
			// Move our pos:
			self._pos[1] = newk;
			self._pos[2] = newkk;
			
			// Delete the entity if it exists at that position:
			DeleteEntityTable(_CurrentLevel.ent_Layer_One[newk][newkk])
			
			// Update the global map:
			_CurrentLevel.Layer_Two[newk][newkk] = _CurrentLevel.Layer_One[newk][newkk]
			_CurrentLevel.Layer_One[newk][newkk] = 10
			
			// Disables movement:
			self:disableMotion()
		end
	end
end
