/*---------------------------------------------------------
Server/ai.lua

 - AI Related Code
---------------------------------------------------------*/
local ai = {}

// Stores all the AI that needs proccessing:
_ai = {}

// Stores all the types of AI:
_ai_types = {}

function ai_type_reload()
	// Delete old AI entries:
	_ai_types = {}
	
	// Try and find AI files:
	local items = file.Find(GM.FolderName.."/gamemode/Server/ai/*.lua", "LUA")
	
	for k,v in pairs(items) do
		include("server/ai/"..v)
	end
end

// Registers an ai type:
function RegisterAI(ai)
	if ai.name then
		_ai_types[string.lower(ai.name)] = ai
	end
end

// Updates an AI's picture:
function ai_update_frame(sort, x, y, dir)
	// Grab the entity:
	local ent = _CurrentLevel.ent_Layer_One[x][y]
	
	// Ensure it exists:
	if ent and ent:IsValid() then
		if _ai_types[sort] and _ai_types[sort].frame and _ai_types[sort].frame[dir] then
			// Store the direction:
			ent:SetNetworkedInt("f", _ai_types[sort].frame[dir])
			ent:SetNetworkedInt("g", _ai_types[sort].frame3d[dir])
		end
	end
end

// Adds a new AI controller:
function ai_add(sort, x, y, dir)
	// Ensure sort is lowercase:
	sort = string.lower(sort or "")
	
	// Make sure the type of AI exists:
	if not _ai_types[sort] then
		print("Warning: Failed to find AI script 'ai/"..sort..".lua")
		print("AI at position "..x..", "..y.." will not move!")
		return -1
	end
	
	// Update it's frame:
	ai_update_frame(sort, x, y, dir)
	
	// Put the ai into the table:
	return table.insert(_ai, {sort, x, y, dir})
end

// Remove an AI:
function ai_remove(n)
	// Delete any entities in it's position:
	local _x = _ai[n][2]
	local _y = _ai[n][3]
	
	// Remove the ai entity:
	DeleteEntityTable(_CurrentLevel.ent_Layer_One[_x][_y])
	_CurrentLevel.ent_Layer_One[_x][_y] = _CurrentLevel.ent_Layer_Two[_x][_y]
	_CurrentLevel.ent_Layer_Two[_x][_y] = nil
	
	// Push the block layer:
	_CurrentLevel.Layer_One[_x][_y] = _CurrentLevel.Layer_Two[_x][_y]
	_CurrentLevel.Layer_Two[_x][_y] = 0
	
	// Remove it from our controllers:
	table.remove(_ai, n)
end

// Move an entity table:
function MoveEntityTable(ent, pos)
	if type(ent) == "table" then
		// Cycle each element:
		for k, v in pairs(ent) do
			// If it's a table:
			if type(v) == "table" then
				// Recurse:
				MoveEntityTable(v, pos)
			else
				// Check if it's valid:
				if type(v) == "Entity" and v:IsValid() then
					// Delete it:
					v:SetFuckingPos( pos)
				end
			end
		end
	elseif type(ent) == "Entity" and ent:IsValid() then
		ent:SetFuckingPos(pos)
	end
end

// Move an AI:
function ai_move(id, k, kk, dir)
	// Reset it's force dir:
	_ai[id][5] = 0
	
	// Grab our old position
	local _x = _ai[id][2]
	local _y = _ai[id][3]
	
	// Grab our block type:
	local b = _CurrentLevel.Layer_One[_x][_y]
	
	// Grab the lower level type:
	local bb = _CurrentLevel.Layer_Two[_x][_y]
	
	// Grab the tile we are crushing:
	local underdog = _CurrentLevel.Layer_One[k][kk]
	
	// Lower the new layer:
	_CurrentLevel.Layer_Two[k][kk] = underdog
	_CurrentLevel.Layer_One[k][kk] = b
	
	// Check for button presses:
	if _Blocks[underdog] and _Blocks[underdog].Press then
		// Press the button:
		_Blocks[underdog].Press(_CurrentLevel.ent_Layer_One[k][kk])
	end
	
	_CurrentLevel.ent_Layer_Two[k][kk] = _CurrentLevel.ent_Layer_One[k][kk]
	//DeleteEntityTable(_CurrentLevel.ent_Layer_One[k][kk])
	
	// Move our AI block:
	MoveEntityTable(_CurrentLevel.ent_Layer_One[_x][_y], Vector(k*128, kk*-128, 0))
	_CurrentLevel.ent_Layer_One[k][kk] = _CurrentLevel.ent_Layer_One[_x][_y]
	_CurrentLevel.ent_Layer_One[_x][_y] = nil
	
	// Raise the old layer:
	_CurrentLevel.Layer_One[_x][_y] = bb
	_CurrentLevel.Layer_Two[_x][_y] = 0
	//SpawnBlock(bb, _x, _y)
	_CurrentLevel.ent_Layer_One[_x][_y] = _CurrentLevel.ent_Layer_Two[_x][_y]
	_CurrentLevel.ent_Layer_Two[_x][_y] = 0
	
	// Update the AIs position:
	_ai[id][2] = k
	_ai[id][3] = kk
	_ai[id][4] = dir
	
	if _Blocks[underdog] and _Blocks[underdog].ai_land then
		// Press the button:
		_Blocks[underdog].ai_land(id, dir, k, kk, underdog)
	end
end

local fd = {}
fd[1] = {0, -1, 1}	// North
fd[2] = {-1, 0, 2}	// West
fd[3] = {0, 1, 3}	// South
fd[4] = {1, 0, 4}	// East

// Proccess the AI:
function ai_proccess()
	if _tank_change_ then
		_tank_change_ = false
		_tank_change = true
	end
	
	for k,v in pairs(_ai) do
		local x, y, dir = v[2], v[3], v[4]
		
		// Grab force dir:
		if v[5] and v[5] ~= 0 then
			// Grab our new direction:
			dir = v[5]
			
			// Grab where we want to move to:
			local to_check = fd[dir]
			
			// Check if we can move there:
			if check_solid_dir(x, to_check[1], y, to_check[2], sort) then
				// Store the new position:
				x = x + to_check[1]
				y = y + to_check[2]
			end
		else
			// Grab the position we should move to:
			x, y, dir = _ai_types[v[1]].NextMove(v[2], v[3], v[4], v[1])
		end
		
		// Check if they moved:
		if(x == v[2] and y == v[3]) then
			// Only update it's direction:
			_ai[k][4] = dir
		else
			// Move the AI to the chosen position:
			ai_move(k, x, y, dir)
		end
		
		// Update it's frame:
		ai_update_frame(v[1], x, y, dir)
	end
	
	_tank_change = false
end

function check_solid_dir(x, k, y, kk, sort)
	if x + k >= 0 and x + k <= 31 and y + kk >= 0 and y + kk <= 31 then
		local bt = _CurrentLevel.Layer_One[x + k][y + kk]
		local bb = _CurrentLevel.Layer_Two[x][y]
		
		// Check the position we are moving into:
		if _Blocks[bt] and _Blocks[bt].ais then
			// AI Solid Block:
			return false
		end
		
		// Check the position we are moving into:
		if _Blocks[bt] and (_Blocks[bt].ais_custom and _Blocks[bt].ais_custom()) then
			// AI Solid Block:
			return false
		end
		
		// Check for certain protections
		if _ai_types[sort] and _ai_types[sort].solid_fire and bt == 4 then
			return false
		end
		
		// Check For direction Solid:
		if k == 1 then
			// Next Square:
			if _Blocks[bt] and _Blocks[bt].s_w then
				return false
			end
			
			// Current Square:
			if _Blocks[bb] and _Blocks[bb].s_e then
				return false
			end
		elseif k == -1 then
			// Next Square:
			if _Blocks[bt] and _Blocks[bt].s_e then
				return false
			end
			
			// Current Square:
			if _Blocks[bb] and _Blocks[bb].s_w then
				return false
			end
		elseif kk == 1 then
			// Next Square:
			if _Blocks[bt] and _Blocks[bt].s_n then
				return false
			end
			
			// Current Square:
			if _Blocks[bb] and _Blocks[bb].s_s then
				return false
			end
		elseif kk == -1 then
			// Next Square:
			if _Blocks[bt] and _Blocks[bt].s_s then
				return false
			end
			
			// Current Square:
			if _Blocks[bb] and _Blocks[bb].s_n then
				return false
			end
		end
		
		// Passed all our tests:
		return true
	end
	
	// It must have failed:
	return false
end
