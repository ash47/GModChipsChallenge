/*---------------------------------------------------------
Server/level_loader.lua

 - Level loading code
---------------------------------------------------------*/

// Used to load a level using the CLASSIC FORMAT:
function Read_Level_Classic(map, n)
	// Open the map:
	local f = file.Open("Chips/"..map, "rb", "DATA")
	
	// Ensure we could open it for reading:
	if not f then
		print("Couldn't open "..map.." for reading!")
		return false
	end
	
	// Grab the level code / ruleset
	local code = read_long(f);
	
	// Make sure it is a valid level:
	if(code ~= "0002AAAC") then
		print(map.." is NOT a valid chips data file!");
		return false
	end
	
	// Grab how many levels are in the pack:
	local numlevels = read_word(f);
	
	// Grab how many bytes in this level
	local bimap = read_word(f);
	
	if(n>numlevels) then -- Are there even n levels in this pack?
		print("You can't load level number "..n.." since "..map.." only contains "..numlevels.." levels!");
		return false
	end
	
	// Init variables
	local xx, yy, i, oldmap = 0, 0, 0, levelnumber or 0;
	
	// How many levels to skip
	local nn = n - 1
	
	// Skip the levels:
	while(nn > 0) do
		// Skip a map
		f:Read(bimap);
		
		// Grab how many bytes in this level
		bimap = read_word(f);  
		
		// We are now at the next map:
		nn = nn - 1
	end
	
	// Read important data:
	local levelnumber = read_word(f) or 0;	// Level Number
	local timelimit = read_word(f) or -1;	// Time Limit
	local totalchips = read_word(f) or 0;	// Chips required
	
	// Map detail, useless, no need to store it:
	read_word(f);
	
	// Number of bytes in the first layer
	local bifl = read_word(f);
	
	// Reset some key values
	local hint = ""
	local password = "NOPASSWORD"
	local leveltitle = "<No Title>"
	
	// Reset chips pos:
	Chip_x = 0;
	Chip_y = 0;
	
	// Reset the layers:
	local Layer_One = {}
	local Layer_Two = {}
	
	for i=0, 31 do
		Layer_One[i] = {}
		Layer_Two[i] = {}
	end
	
	--Load the first layer:
	while(bifl>0) do
		local tmp = read_byte(f) or 0;
		bifl = bifl - 1;
		if(tmp == 255) then
			tmp = read_byte(f) or 0;
			tmpa = read_byte(f) or 0;
			bifl = bifl-2;
			for i = 1, tmp, 1 do
				// Assign the tile to the correct place:
				Layer_One[xx][yy] = tmpa
				
				// Find Chip:
				if(tmp>=108 and tmp<=111)then
					Chip_x=xx
					Chip_y=yy
				end
				
				// Move to the next square:
				xx = xx+1;
				if(xx>31) then
					xx=0;
					yy=yy+1;
				end
			end
		else
			// Assign the tile:
			Layer_One[xx][yy] = tmp
			
			// Find Chip:
			if(tmp>=108 and tmp<=111)then
				Chip_x=xx
				Chip_y=yy
			end
			
			// Move to the next square:
			xx = xx+1;
			if(xx>31) then
				xx=0;
				yy=yy+1;
			end
		end
	end
	
	// Bytes in the second layer:
	local bisl = read_word(f);
	
	// Skip the second layer:
	// f:Read(bisl);
	
	local xx,yy = 0,0;
	
	// Load the second layer:
	while(bisl>0) do
		local tmp = read_byte(f) or 0;
		bisl = bisl - 1;
		if(tmp == 255) then
			tmp = read_byte(f) or 0;
			tmpa = read_byte(f) or 0;
			bisl = bisl - 2;
			for i = 1, tmp, 1 do
				// Assign the tile to the correct place:
				Layer_Two[xx][yy] = tmpa
				
				// Move to the next square:
				xx = xx + 1;
				if(xx > 31) then
					xx = 0;
					yy = yy + 1;
				end
			end
		else
			// Assign the tile:
			Layer_Two[xx][yy] = tmp
			
			// Move to the next square:
			xx = xx + 1;
			if(xx > 31) then
				xx = 0;
				yy = yy + 1;
			end
		end
	end
	
	// Number of bytes in the optional area:
	local biop = read_word(f);
	
	// Loop through all the fields:
	while(biop>0) do
		local field = read_byte(f); // Field Number
		local bif = read_byte(f);   // Bytes in field
		biop = biop - 2 - bif; // Remove the bytes read this session
		
		// Map title:
		if(field == 3) then
			leveltitle = ""
			while(bif > 0) do
				bif = bif - 1
				leveltitle = leveltitle..string.char(read_byte(f));
			end
		
		// List of bear traps:
		elseif(field == 4)then
			// Clear beartrap list:
			//bear_x = {};
			//bear_y = {};
			//bear_xx = {};
			//bear_yy = {};
			//bear_open = {};
			//bear_total = 0;
			while(bif > 0) do
				bif = bif - 10;
				
				// TEMP:
				read_word(f);
				read_word(f);
				read_word(f);
				read_word(f);
				
				//bear_total = bear_total+1;
				//bear_x[bear_total] = read_word(f);
				//bear_y[bear_total] = read_word(f);
				//bear_xx[bear_total] = read_word(f);
				//bear_yy[bear_total] = read_word(f);
				//bear_open[bear_total] = 0;
				read_word(f); -- No idea what this is used for
			end
		// List of cloning machines:
		elseif(field == 5)then
			// Clear cloning list:
			//clone_x = {};
			//clone_y = {};
			//clone_xx = {};
			//clone_yy = {};
			//clone_total = 0;
			while(bif>0) do
				bif=bif-8;
				//clone_total = clone_total+1;
				//clone_x[clone_total] = read_word(f);
				//clone_y[clone_total] = read_word(f);
				//clone_xx[clone_total] = read_word(f);
				//clone_yy[clone_total] = read_word(f);
				
				// TEMP:
				read_word(f);
				read_word(f);
				read_word(f);
				read_word(f);
			end
		// Password:
		elseif(field == 6) then
			password = ""
			while(bif>1) do
				bif=bif-1
				password = password..string.char(bxor(read_byte(f),153));
			end
			read_byte(f) // Read terminating 0
		// Hint:
		elseif(field == 7) then
			hint = ""
			while(bif>0) do
				bif=bif-1
				hint = hint..string.char(read_byte(f));
			end
		// Monsters:
		elseif(field == 10) then
			//monsters_x = {}
			//monsters_y = {}
			//monsters_sort = {}
			//monsters_canmove = {}
			//monsters_total = 0
			
			while(bif>0) do
				bif=bif-2
				
				// TMEP:
				read_byte(f)
				read_byte(f)
				
				//monsters_total = monsters_total+1;
				//monsters_x[monsters_total] = read_byte(f) or 0;
				//monsters_y[monsters_total] = read_byte(f) or 0;
				//monsters_canmove[monsters_total]=1;
				//if(Chip_is_monster(Layer_One[monsters_x[monsters_total]][monsters_y[monsters_total]])) then
				//	monsters_sort[monsters_total] = Layer_One[monsters_x[monsters_total]][monsters_y[monsters_total]]
				//elseif(Chip_is_monster(Layer_Two[monsters_x[monsters_total]][monsters_y[monsters_total]])) then
				//	monsters_sort[monsters_total] = Layer_Two[monsters_x[monsters_total]][monsters_y[monsters_total]]
				//else
				//	monsters_total = monsters_total-1
				//end
			end
		// Unknown or unused field, Skip:
		else
			f:Read(bif);
		end
	end
	
	// Close the file:
	f:Close()
	
	// Create a store to return the level in:
	local level = {}
	
	// Fill the store:
	level.Pack = map				// The map pack that it loaded from
	level.Layer_One = Layer_One		// The first layer
	level.Layer_Two = Layer_Two		// The second layer
	level.number = levelnumber		// The level number
	level.timelimit = timelimit		// The timelimit
	level.totalchips = totalchips	// The amount of chips in the level
	level.numlevels = numlevels		// How many levels are in the map pack
	level.hint = hint				// The level's hint
	level.password = password		// The level's password
	level.leveltitle = leveltitle	// The level's title
	level.Chip_x = Chip_x			// Chip's X position
	level.Chip_y = Chip_y			// Chip's Y position
	
	return level
end

// Used to delete tables of entities:
function DeleteEntityTable( ent )
	if type(ent) == "table" then
		// Cycle each element:
		for k, v in pairs(ent) do
			// If it's a table:
			if type(v) == "table" then
				// Recurse:
				DeleteEntityTable(v)
			else
				// Check if it's valid:
				if type(v) == "Entity" and v:IsValid() then
					// Delete it:
					v:Remove()
				end
			end
		end
	elseif type(ent) == "Entity" and ent:IsValid() then
		ent:Remove()
	end
end

// Used to remove something from the top most layer it is found in:
function Remove_From_Layer(block, k, kk)
	local t = _CurrentLevel.Layer_One[k][kk]
	
	if block == t then
		_CurrentLevel.Layer_One[k][kk] = _CurrentLevel.Layer_Two[k][kk]
		_CurrentLevel.Layer_Two[k][kk] = 0
		
		DeleteEntityTable(_CurrentLevel.ent_Layer_One[k][kk])
		_CurrentLevel.ent_Layer_One[k][kk] = _CurrentLevel.ent_Layer_Two[k][kk]
		_CurrentLevel.ent_Layer_Two[k][kk] = nil
		return true
	else
		t = _CurrentLevel.Layer_Two[k][kk]
			
		if block == t then
			_CurrentLevel.Layer_Two[k][kk] = 0
			DeleteEntityTable(_CurrentLevel.ent_Layer_Two[k][kk])
			_CurrentLevel.ent_Layer_Two[k][kk] = nil
			return true
		else
			return false
		end
	end
	
	return false
end

// Used to clear a map:
function ClearMap()
	// Check if there is anything to clear:
	if _Clear then
		// Clear the table:
		DeleteEntityTable(_Clear)
	end
	
	// Reset the clear array:
	_Clear = {}
	
	// Reset AI:
	_ai = {}
	
	// Reset green switch position:
	_Green_Switch = 0
	
	// Tell everyone:
	net.Start("GreenMode")
	net.WriteInt(_Green_Switch, 2)
	net.Broadcast()
end

// Load a map:
function Load_Map(a, n)
	// Check what we are doing:
	if type(a) ~= "table" then
		// Load a map from the same pack:
		if type(a) == "number" then
			// Store n as a:
			n = a
			
			// Grab a:
			if not _CurrentLevel then
				print("Unable to load level number "..a.." as no pack has been selected!")
				return
			end
			
			a = _CurrentLevel.Pack
		end
		
		// Attempt to load the map:
		a = Read_Level_Classic(a, n)
		
		// Failed, don't spawn the next map:
		if not a then return end
	end
	
	// Clear the map:
	ClearMap()
	
	// move a:
	_CurrentLevel = a
	
	// Used for storing the entity array:
	_CurrentLevel.ent_Layer_One = {}
	for i = 0,32 do
		_CurrentLevel.ent_Layer_One[i] = {}
	end
	
	_CurrentLevel.ent_Layer_Two = {}
	for i = 0,32 do
		_CurrentLevel.ent_Layer_Two[i] = {}
	end
	
	// Load the first layer:
	for k,v in pairs(_CurrentLevel.Layer_One) do
		// Cycle columns:
		for kk,vv in pairs(v) do
			// Cycle rows:
			SpawnBlock(vv, k, kk)
			
			// Check if it is AI:
			if _Blocks[vv] and _Blocks[vv].ai then
				// Add the ai:
				ai_add(_Blocks[vv].ai_type, k, kk, _Blocks[vv].dir)
			end
		end
	end
	
	// Load the second layer:
	for k,v in pairs(_CurrentLevel.Layer_Two) do
		// Cycle columns:
		for kk,vv in pairs(v) do
			// Cycle rows:
			SpawnBlock2(vv, k, kk)
		end
	end
	
	// Set everyone's position:
	chip_start = Vector(128 * Chip_x + 64, -128 * Chip_y - 64, 0)
	
	for k,v in pairs(player.GetAll()) do
		// Set their position:
		v:SetPos(chip_start)
		v:SetEyeAngles(Angle(0, 90, 0))
	end
	
	// Reset player's Items:
	ResetItems()
	
	// Reset the total number of chips:
	_TotalChips = _CurrentLevel.totalchips or 0
	
	// Send how many chips are left:
	net.Start("TotalChips")
	net.WriteInt(_TotalChips, 16)
	net.Broadcast()
	
	// Send the hint:
	net.Start("Hint")
	net.WriteString(_CurrentLevel.hint or "")
	net.Broadcast()
	
	// Start AI:
	timer.Destroy("ai_movement")
	timer.Create("ai_movement", 0.5, 0, ai_proccess)
end

// Spawns block n at k, kk
function SpawnBlock(n, k, kk)
	if _Blocks[n] then
		// Spawn the block:
		local e = _Blocks[n]:Spawn(Vector(k * 128,-kk * 128,0))
		
		// Give it a way to find it's position:
		e._pos = {k, kk}
		
		// Test for button functions:
		if _Blocks[n].Press then
			e.PressFunction = _Blocks[n].Press
		end
		
		// Insert a into the clear array:
		table.insert(_Clear, e)
		
		// Store into our ent array:
		_CurrentLevel.ent_Layer_One[k][kk] = e
	else
		_CurrentLevel.ent_Layer_One[k][kk] = nil
	end
end

// Spawns block n at k, kk
function SpawnBlock2(n, k, kk)
	if _Blocks[n] then
		// Spawn the block:
		local e = _Blocks[n]:Spawn(Vector(k * 128,-kk * 128,0))
		
		// Give it a way to find it's position:
		e._pos = {k, kk}
		
		// Insert a into the clear array:
		table.insert(_Clear, e)
		
		// Store into our ent array:
		_CurrentLevel.ent_Layer_Two[k][kk] = e
	else
		_CurrentLevel.ent_Layer_Two[k][kk] = nil
	end
end

// This is called when a player finishes a level:
function FinshLevel(ply, ent)
	// Check if we finished via a finish:
	if ent:IsValid() then
		// Play the sound:
		ply:EmitSound("Ash47_CC/ditty1.wav")
	end
	
	// Check if a valid player finished the level:
	if ply:IsValid() then
		// Give them a point, or something etc?
	end
	
	// Ensure there is a map to load:
	if _CurrentLevel.number >= _CurrentLevel.numlevels then
		// Load the first level in the pack:
		Load_Map(_CurrentLevel.Pack, 1)
	else
		// Load the next level in the pack:
		Load_Map(_CurrentLevel.Pack, _CurrentLevel.number + 1)
	end
end

// A console command to load maps:
concommand.Add("LoadMap", function(ply, cmd, arg)
	// Stop non-admins from running this command:
	if not ply:IsAdmin() then return end
	
	// Make sure they passed an argument:
	if not arg[1] then return end
	
	// See if they are passing a level number:
	if not arg[2] then
		if tonumber(arg[1]) then
			arg[1] = tonumber(arg[1])
		else
			arg[2] = 1
		end
	else
		arg[2] = tonumber(arg[2])
	end
	
	// Try and load the level they have specified:
	Load_Map(arg[1], arg[2])
end)

concommand.Add("nextmap", function(ply, cmd, args)
	if _CurrentLevel.number >= _CurrentLevel.numlevels then
		// Load the first level in the pack:
		Load_Map(_CurrentLevel.Pack, 1)
	else
		// Load the next level in the pack:
		Load_Map(_CurrentLevel.Pack, _CurrentLevel.number + 1)
	end
end)