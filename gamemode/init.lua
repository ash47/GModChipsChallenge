/*---------------------------------------------------------
init.lua

 - Load everything
 - Send client side files
---------------------------------------------------------*/

// Send all the lua in a folder:
function AddCSLuaFolder(folder)
	// Find all the files and directories:
	local f, d = file.Find(GM.FolderName.."/gamemode/"..folder.."/*", "LUA")
	
	// Add each file:
	for k,v in pairs(f) do
		AddCSLuaFile(folder.."/"..v)
	end
	
	// Add all folders:
	for k,v in pairs(d) do
		AddCSLuaFolder(folder.."/"..v)
	end
end

// Send all the sounds in a folder:
function AddFileFolder(folder)
	// Find all the files and directories:
	local f, d = file.Find(folder.."/*", "GAME")
	
	// Add each file:
	for k,v in pairs(f) do
		resource.AddFile(folder.."/"..v)
	end
	
	// Add all folders:
	for k,v in pairs(d) do
		AddCSLuaFolder(folder.."/"..v)
	end
end

// Send the client side loader:
AddCSLuaFile("cl_init.lua")

// Send over the client files:
AddCSLuaFolder("Shared")
AddCSLuaFolder("Client")

// Send over all the sounds:
AddFileFolder("Sound/Ash47_CC")
AddFileFolder("Materials/Ash47_CC")

// Load the server config file:
include("server_settings.lua")

// Load the shared content:
include("Shared/_sHared.lua")

// Load the gamemode:
include("Server/_server.lua")

// Load the blocks:
LoadBlocks()

// Reload the ai types:
ai_type_reload()

AddCSLuaFile("quick_messages.lua")
include("quick_messages.lua")
