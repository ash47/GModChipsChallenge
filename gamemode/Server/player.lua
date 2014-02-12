/*---------------------------------------------------------
Server/player.lua
---------------------------------------------------------*/

// Grab the player's meta table:
local meta = FindMetaTable("Player")

// Called when a player should die:
function meta:kill()
	// Play the sound:
	self:EmitSound("Ash47_CC/bummer.wav")
	
	// Slay the player:
	self:Kill()
end
