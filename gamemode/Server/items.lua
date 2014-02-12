/*---------------------------------------------------------
Server/items.lua

 - Item related code
 - Handle chip counting
---------------------------------------------------------*/

// This is called when a chip is collected
function CollectChip(ply)
	// Take one from the total chip count:
	_TotalChips = _TotalChips - 1
	
	// Stop the chip count from going negative:
	if _TotalChips < 0 then
		_TotalChips = 0
	end
	
	// Send the number of chips remaining to all clients:
	net.Start("TotalChips")
	net.WriteInt(_TotalChips, 16)
	net.Broadcast()
	
	// Attempt to give the player a point:
	if ply:IsValid() then
		ply:AddFrags(1)
	end
end

// This is called to reset items:
function ResetItems()
	for k,v in pairs(player.GetAll()) do
		// Set the amount of chips everyone has collected to 0:
		v:SetFrags(0)
		
		// Reset their shoes:
		v.shoes = {}
		
		// Reset their keys:
		v.keys = {}
		
		// Reset their key store:
		v._keys = {}
		
		// Send a reset thingo:
		net.Start("Inv")
		net.WriteInt(0, 16)
		net.Send(v)
	end
end

// Used to reset a single player's items:
local meta = FindMetaTable("Player")

function meta:ResetItems()
	// Reset their shoes:
	self.shoes = {}
	
	// Reset their keys:
	self.keys = {}
	
	// Reset their key store:
	self._keys = {}
	
	// Send a reset thingo:
	net.Start("Inv")
	net.WriteInt(0, 16)
	net.Send(self)
end

// Used to drop keys:
function meta:DropKeys()
	for k, v in pairs(self._keys) do
		// Grab the ent number:
		local vv = v[1] + 99
		
		// Spawn the block:
		local a = _Blocks[vv]:Spawn(Vector(v[2] * 128,-v[3] * 128,0))
		
		// Give it a way to find it's position:
		a._pos = {v[2], v[3]}
		
		// Insert a into the clear array:
		table.insert(_Clear, a)
	end
	
	// Reset their key hold:
	self._keys = {}
	
	// Reset their key number:
	self.keys = {}
	
	// Tell them they have no keys:
	net.Start("Inv")
	net.WriteInt(-1, 16)
	net.Send(self)
end
