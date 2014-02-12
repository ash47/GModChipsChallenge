/*---------------------------------------------------------
Server/network_vars.lua

 - Network variable names for the net library
---------------------------------------------------------*/

// Server ==> Client || Client ==> Server

// Usermessages:
util.AddNetworkString("TotalChips")			// Total Number of Chips remaining	|| N/A
util.AddNetworkString("Hint")				// Sending the level's hint			|| N/A
util.AddNetworkString("Inv")				// Sending inventory status			|| N/A
util.AddNetworkString("Map")				// Toggle the map on/off			|| N/A
util.AddNetworkString("TurnOn")				// Turns a Pass Once on				|| N/A
util.AddNetworkString("TurnOff")			// Turns all pass onces off			|| N/A

util.AddNetworkString("GreenMode")			// Green Switch Block Mode			|| N/A

util.AddNetworkString("LevelPacks")			// Sending the level packs			|| Requesting the level packs
util.AddNetworkString("BrowseLevels")		// Open the map viewer				|| N/A

util.AddNetworkString("RequestLevel")		// Sending a level over				|| N/A
util.AddNetworkString("RequestLevelRange")	// N/A								|| Requesting a RANGE of levels

util.AddNetworkString("RequestFullLevel")	// Sending a FULL level				|| Request a FULL level
