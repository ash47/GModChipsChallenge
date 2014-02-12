/*---------------------------------------------------------
Shared/sHared.lua

 - All the shared stuff
 - Team info
---------------------------------------------------------*/

// Include our utilities:
include("uTil.lua")
include("bInary.lua")	// Contains binary functions

// General information
GM.Version = "WiP"
GM.Name = "Chip's Challenge "..GM.Version
GM.Author = "Ash47 (STEAM_0:0:14045128)"

// SWAT Team:
team.SetUp(1, "Chip", Color(0,0,200))
