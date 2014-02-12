/*---------------------------------------------------------
Server/gm_funcs.lua

 - Contains all non-specific GM functions
---------------------------------------------------------*/

// This runs once all map entities have been made:
function GM:InitPostEntity()
	// Find all the missing models:
	FindMissingModels()
	
	// Load a map:
	Load_Map("CHIPS.DAT", 1)
end

/*---------------------------------------------------------
F1 - F4 buttons
---------------------------------------------------------*/

function GM:ShowHelp(ply)
end

function GM:ShowTeam(ply)
end

// Toggle 'minimap mode'
function GM:ShowSpare1(ply)
	net.Start("Map")
	net.Send(ply)
end

// Browse levels:
function GM:ShowSpare2(ply)
	net.Start("BrowseLevels")
	net.Send(ply)
end

/*---------------------------------------------------------
Spawn handling functions
---------------------------------------------------------*/

// When the first joins the server:
function GM:PlayerInitialSpawn( ply )
	// Send the total number of chips:
	net.Start("TotalChips")
	net.WriteInt(_TotalChips or 0, 16)
	net.Send(ply)
	
	// Send the hint:
	if _CurrentLevel and _CurrentLevel.hint then
		net.Start("Hint")
		net.WriteString(_CurrentLevel.hint)
		net.Send(ply)
	end
	
	// Put them onto chip team:
	ply:SetTeam(1)
	
	// Reset their inventory:
	ply:ResetItems()
	
	// Attempt to send them the green value:
	if _Green_Switch then
		net.Start("GreenMode")
		net.WriteInt(1, _Green_Switch)
		net.Send(ply)
	end
	
	// Enable the map view:
	net.Start("Map")
	net.Send(ply)
end

// When the player spawns / respawns:
function GM:PlayerSpawn( ply )
	// Ensure they have no weapons:
	ply:StripWeapons()
	
	// Check if a start exists:
	if chip_start then
		// Set the player's starting position:
		ply:SetPos(chip_start)
		
		// Set their angles:
		ply:SetEyeAngles(Angle(0, 90, 0))
	end
	
	// Set the player's model:
	ply:SetModel("models/player/group01/male_01.mdl")
	
	// Stop the player from colliding with their team mates:
	ply:SetNoCollideWithTeammates(true)
	
	// Disable jumping:
	ply:SetJumpPower(0)
	
	// Reset their speed:
	ply:SetWalkSpeed(320)
	ply:SetRunSpeed(320)
	
	// Reset their inventory:
	ply:ResetItems()
end

/*---------------------------------------------------------
Death Stuff:
---------------------------------------------------------*/

// What happens when they die:
function GM:DoPlayerDeath( ply, attacker, dmginfo )
	// Create a ragdoll:
	ply:CreateRagdoll()
	
	// Makes them drop their keys:
	ply:DropKeys()
end

// Stop death noises:
function GM:PlayerDeathSound()
	return true
end

/*---------------------------------------------------------
Player Disconnect
---------------------------------------------------------*/

// When a player disconnects:
function GM:PlayerDisconnected( ply )
	// Makes them drop their keys:
	ply:DropKeys()
end

/*---------------------------------------------------------
Damage handle:
---------------------------------------------------------*/

function GM:PlayerShouldTakeDamage( victim, pl )
	// No one gets hurt ever:
	return false
end

// Stop that fall noise:
function GM:GetFallDamage( ply, speed )
    return false
end

/*---------------------------------------------------------
Collision Handling Stuff
---------------------------------------------------------*/

hook.Add( "ShouldCollide", "TileCollisions", function ( ent1, ent2 )
	if ent1:IsPlayer() then
		if ent2:GetClass() == "wall" then
			return true
		end
	elseif ent2:IsPlayer() then
		if ent1:GetClass() == "wall" then
			return true
		end
	end 
end )

/*---------------------------------------------------------
Foot Steps
---------------------------------------------------------*/

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	return true
end
