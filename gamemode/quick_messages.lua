if SERVER then return end

if not _quick_messages then
	_quick_messages = true
	
	timer.Create("Quick_messages", 30, 0, function()
		chat.AddText(Color(255, 0, 0),"READ THIS: ",Color(255, 255, 255),"This gamemode is no longer in development, this server is just up for the hell of it.")
		chat.AddText(Color(255, 255, 255),"Press F4 to browse levels, then use the console command ",Color(255, 0, 0),"loadmap <number>",Color(255, 255, 255)," to load a map.")
		chat.AddText(Color(255, 255, 255),"Loadmap can also take a datapack name as the first argument. ",Color(255,0,0),"loadmap chips.dat 3",Color(255,255,255)," OR ",Color(255,0,0)," loadmap 3")
	end)
end