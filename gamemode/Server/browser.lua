/*---------------------------------------------------------
Server/browser.lua

Level Browsing Code
---------------------------------------------------------*/

function Level_Find_Packs()
	// Find data packs:
	local f, d = file.Find("Chips/*.DAT", "DATA")
	
	// Return them:
	if f then
		return f
	else
		return {}
	end
end

// Read meta data:
function Read_Level_Num(pack)
	// Open the map:
	local f = file.Open("Chips/"..pack, "rb", "DATA")
	
	// Ensure we could open it for reading:
	if not f then
		print("Couldn't open "..pack.." for reading!")
		return false
	end
	
	// Grab the level code / ruleset
	local code = read_long(f);
	
	// Make sure it is a valid level:
	if(code ~= "0002AAAC") then
		print(pack.." is NOT a valid chips data file!");
		return false
	end
	
	// Grab how many levels are in the pack:
	local numlevels = read_word(f);
	
	// Close the file:
	f:Close()
	
	// Return how many levels there are:
	return numlevels
end

// A player requested all the level packs:
net.Receive("LevelPacks", function(len, ply)
	// Find all the data packs:
	local packs = Level_Find_Packs()
	
	// Start writing the packs:
	net.Start("LevelPacks")
	
	for k,v in pairs(packs) do
		// Work out how many levels there are:
		local n = Read_Level_Num(v)
		
		if n then
			// Write the pack name:
			net.WriteString(v)
			
			// Write how many levels it has:
			net.WriteInt(n, 16)
		end
	end
	
	// Send it to our player:
	net.Send(ply)
end)

function SendMap(name, num, ply)
	// Grab the data:
	local data = Read_Level_Classic(name, num)
	
	// Grab the part to center around:
	local x = math.min(math.max(data.Chip_x, 4), 27)
	local y = math.min(math.max(data.Chip_y, 4), 27)
	
	// Start the pack:
	net.Start("RequestLevel")
	
	// Pack the pack name:
	net.WriteString(data.Pack)
	
	// Pack the level number:
	net.WriteInt(num, 16)
	
	// Pack the level title:
	net.WriteString(data.leveltitle)
	
	// Pack the hint:
	net.WriteString(data.hint)
	
	// Pack how many chips are needed:
	net.WriteInt(data.totalchips, 16)
	
	// Pack the data:
	for _x = x-4, x+4 do
		for _y = y-4, y+4 do
			net.WriteInt(data.Layer_One[_x][_y], 8)
			net.WriteInt(data.Layer_Two[_x][_y], 8)
		end
	end
	
	// Send to the client:
	net.Send(ply)
end

function SendFullMap(name, num, ply)
	// Grab the data:
	local data = Read_Level_Classic(name, num)
	
	// Start the pack:
	net.Start("RequestFullLevel")
	
	// Pack the pack name:
	net.WriteString(data.Pack)
	
	// Pack the level number:
	net.WriteInt(num, 16)
	
	// Send layer one:
	local count = 1
	local prev = data.Layer_One[0][0]
	for _y = 0, 31 do
		for _x = 0, 31 do
			if _x >0 or _y > 0 then
				// Grab the data:
				local d = data.Layer_One[_x][_y]
				
				// Check if the data matches up with our prev:
				if d ~= prev then
					if count == 1 then
						net.WriteInt(prev, 8)
					else
						net.WriteInt(-prev-1, 8)
						net.WriteInt(count, 12)
						count = 1
					end
				else
					count = count + 1
				end
				
				// Store the prev:
				prev = d
			end
		end
	end
	if count == 1 then
		net.WriteInt(prev, 8)
	else
		net.WriteInt(-prev-1, 8)
		net.WriteInt(count, 12)
	end
	
	// Send layer two:
	local count = 1
	local prev = data.Layer_Two[0][0]
	for _x = 0, 31 do
		for _y = 0, 31 do
			if _x >0 or _y > 0 then
				// Grab the data:
				local d = data.Layer_Two[_x][_y]
				
				// Check if the data matches up with our prev:
				if d ~= prev then
					if count == 1 then
						net.WriteInt(prev, 8)
					else
						net.WriteInt(-prev-1, 8)
						net.WriteInt(count, 12)
						count = 1
					end
				else
					count = count + 1
				end
				
				// Store the prev:
				prev = d
			end
		end
	end
	if count == 1 then
		net.WriteInt(prev, 8)
	else
		net.WriteInt(-prev-1, 8)
		net.WriteInt(count, 12)
	end
	
	// Send to the client:
	net.Send(ply)
end

// A player requested a RANGE of levels:
net.Receive("RequestLevelRange", function(len, ply)
	// Read the name of the pack:
	local name = net.ReadString()
	
	// Read the lower/upper bound:
	local lower = net.ReadInt(16)
	local upper = net.ReadInt(16)
	
	// Validate lower:
	if lower <= 0 then
		return false
	end
	
	// More validation:
	if lower>upper then
		return false
	end
	
	// One final check:
	local total = Read_Level_Num(name)
	if not total or total < upper then
		return false
	end
	
	// PURE LAZINESS, we could write a function that saves time here, but I'm gonna use what I already have:
	
	// Load, then send, each level they request:
	for k = lower, upper do
		// Send the map over:
		SendMap(name, k, ply)
	end	
end)

// A player requested atleast one level:
net.Receive("RequestLevel", function(len, ply)
	// Read the name of the pack:
	local name = net.ReadString()
	
	// Some checking:
	local total = Read_Level_Num(name)
	if not total then
		return false
	end
	
	// Remove from the len:
	len = len - (string.len(name) + 1) * 8
	
	while(len > 0) do
		// Read which number:
		local k = net.ReadInt(16)
		len = len - 16
		
		if k > 0 and k <=total then
			// Send the map:
			SendMap(name, k, ply)
		end
	end
end)

// A player requested a FULL level:
net.Receive("RequestFullLevel", function(len, ply)
	// Read the name of the pack:
	local name = net.ReadString()
	// Some checking:
	local total = Read_Level_Num(name)
	if not total then
		return false
	end
	
	// Read which map they want us to read:
	local num = net.ReadInt(16)
	
	// Validate, and send the map:
	if num >= 1 and num <= total then
		SendFullMap(name, num, ply)
	end
end)