/*---------------------------------------------------------
entities/entities/dirt_block/init.lua
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

function ENT:UnlockBlock()
	// Remove ourself from the map:
	local n = _CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]]
	_CurrentLevel.Layer_One[self._pos[1]][self._pos[2]] = n
	_CurrentLevel.Layer_Two[self._pos[1]][self._pos[2]] = 0
end

function ENT:Pushed(k, kk)
	// Read what is on the square we are trying to move to:
	local t = _CurrentLevel.Layer_One[(self._pos[1] + k)][(self._pos[2] + kk)] or 1
	
	if t == 0 or (not _Blocks[t]) or ((not _Blocks[t].bs) and (not _Blocks[t].bs_custom or not _Blocks[t].bs_custom())) then
		// Our new position:
		local newk = self._pos[1] + k
		local newkk = self._pos[2] + kk
		
		// Enable motion:
		self:enableMotion()
		
		// Update the ent matrix:
		_CurrentLevel.ent_Layer_Two[newk][newkk] = _CurrentLevel.ent_Layer_One[newk][newkk]
		_CurrentLevel.ent_Layer_One[newk][newkk] = _CurrentLevel.ent_Layer_One[self._pos[1]][self._pos[2]]
		
		_CurrentLevel.ent_Layer_One[self._pos[1]][self._pos[2]] = _CurrentLevel.ent_Layer_Two[self._pos[1]][self._pos[2]]
		_CurrentLevel.ent_Layer_Two[self._pos[1]][self._pos[2]] = 0
		
		// Set it so we are moving:
		self.moving = true
		
		// Store our changers:
		self._k = 0
		self.k = k
		self._kk = 0
		self.kk = kk
		
		// Update the global map:
		_CurrentLevel.Layer_Two[newk][newkk] = _CurrentLevel.Layer_One[newk][newkk]
		_CurrentLevel.Layer_One[newk][newkk] = 10
		
		
	end
end

function ENT:Think()
	// Check if we are moving:
	if self.moving then
		// Number of steps to move in:
		local steps = 4
		
		// Move our _k values:
		self._k  = self._k + self.k
		self._kk = self._kk + self.kk
		
		// Update our position:
		self:SetPos(self:GetPos() + Vector((128/steps)*self.k, -(128/steps)*self.kk, 0))
		
		// Check if we have made it all the way to our new position:
		if math.abs(self._k) >= steps or math.abs(self._kk) >= steps then
			// Grab the position we moved to:
			local newk = self._pos[1] + self.k
			local newkk = self._pos[2] + self.kk
			
			// Stop moving:
			self.moving = false
			
			// Disables movement:
			self:disableMotion()
			
			// Unlock the old square:
			self:UnlockBlock()
			
			// We can now remove what ever we just crushed:
			//DeleteEntityTable(_CurrentLevel.ent_Layer_One[newk][newkk])
			//_CurrentLevel.ent_Layer_Two[newk][newkk] = _CurrentLevel.ent_Layer_One[newk][newkk]
			
			// Move ourself into that position:
			_CurrentLevel.ent_Layer_One[newk][newkk] = self
			
			// Move our pos:
			self._pos[1] = newk;
			self._pos[2] = newkk;
			
			// Check what is under us:
			local u = _CurrentLevel.Layer_Two[newk][newkk]
			
			// Check if we hit water:
			if u == 3 then
				// Delete the water and block:
				DeleteEntityTable(_CurrentLevel.ent_Layer_One[newk][newkk])
				DeleteEntityTable(_CurrentLevel.ent_Layer_Two[newk][newkk])
				
				// Dirt block number:
				local dirtn = 11
				
				// Play the splash noise:
				self:EmitSound("Ash47_CC/water2.wav")
				
				// Remove water:
				_CurrentLevel.Layer_Two[newk][newkk] = 0
				
				// Spawn the dirt:
				SpawnBlock(dirtn, newk, newkk)
				
				// Convert to dirt:
				_CurrentLevel.Layer_One[newk][newkk] = dirtn
				
				// Remove ourself:
				self:Remove()
				
				// Stop the script:
				return
			// Check if there is ice under us:
			elseif u == 12 then
				// Grab the spot we are gonna move into:
				local newk = self._pos[1] + self.k
				local newkk = self._pos[2] + self.kk
				
				// Check if there is a free spot to move into:
				local t = _CurrentLevel.Layer_One[(newk)][(newkk)] or 1
	
				if t == 0 or (not _Blocks[t]) or ((not _Blocks[t].bs) and (not _Blocks[t].bs_custom or not _Blocks[t].bs_custom())) then
					self:Pushed(self.k, self.kk)
					return
				end
				
				// Lets try and bounce back:
				local newk = self._pos[1] - self.k
				local newkk = self._pos[2] - self.kk
				
				local t = _CurrentLevel.Layer_One[(newk)][(newkk)] or 1
	
				if t == 0 or (not _Blocks[t]) or ((not _Blocks[t].bs) and (not _Blocks[t].bs_custom or not _Blocks[t].bs_custom())) then
					self:Pushed(-self.k, -self.kk)
					return
				end
			end
		end
	end
end

function ENT:StartTouch( ent )
	// Ensure we aren't moving:
	if not self.moving then
		// Make sure the player doesn't have skates:
		if ent:GetClass() == "player" then
			// Find the difference between our positions:
			local dif = (self:GetPos() + self:OBBCenter()) - ent:GetPos()
			
			local dif1 = math.abs(dif[1])
			local dif2 = math.abs(dif[2])
			
			// The way we are gonna try and move:
			k  = 0;
			kk = 0;
			
			//if dif1 < 48 and dif2 < 48 then
				// We crushed a player:
				//ent:kill()
			if dif1 < dif2 then
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
			
			self:Pushed(k, kk)
		end
	end
end
