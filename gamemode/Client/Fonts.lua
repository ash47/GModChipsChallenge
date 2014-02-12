/*---------------------------------------------------------
Client/Fonts.lua

 - Contains all fonts
---------------------------------------------------------*/

// "How many chips left":
surface.CreateFont("HudText", {
	size = 24,
	weight = 0,
	antialias = false,
	shadow = true,
	font = "coolvetica"})

// How many keys you have:
surface.CreateFont("KeyNum", {
	size = 18,
	weight = 0,
	antialias = false,
	shadow = true,
	font = "coolvetica"})

// Drawing the hint:
surface.CreateFont("HintText", {
	size = 24,
	weight = 0,
	antialias = false,
	shadow = true,
	font = "coolvetica"})

// Chip Preview Pains:
surface.CreateFont("ChipPainText", {
	size = 24,
	weight = 0,
	antialias = false,
	shadow = false,
	font = "coolvetica"})
