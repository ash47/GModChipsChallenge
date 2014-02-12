/*---------------------------------------------------------
Client/Items.lua

 - Item handling code
---------------------------------------------------------*/

// The server sent us how many chips are remaining:
net.Receive("TotalChips", function(len)
	_TotalChips = net.ReadInt(16)
end)

// The server sent us an item update:
net.Receive("Inv", function(len)
	// Grab the mode:
	local mode = net.ReadInt(16)
	
	if mode == 0 then
		_keys = {}
		_shoes = {}
	// Flippers:
	elseif mode == 1 then
		_shoes[1] = 1
	// Fire boots:
	elseif mode == 2 then
		_shoes[2] = 1
	// Ice Skates:
	elseif mode == 3 then
		_shoes[3] = 1
	// Suction Boots:
	elseif mode == 4 then
		_shoes[4] = 1
	// Cyan Key:
	elseif mode == 5 then
		_keys[1] = net.ReadInt(16)
	// Red Key:
	elseif mode == 6 then
		_keys[2] = net.ReadInt(16)
	// Green Key:
	elseif mode == 7 then
		_keys[3] = net.ReadInt(16)
	// Yellow Key:
	elseif mode == 8 then
		_keys[4] = net.ReadInt(16)
	// Lost all keys:
	elseif mode == -1 then
		_keys = {}
	// Lost all shoes:
	elseif mode == -2 then
		_shoes = {}
	end
end)

// When a pass once is turned on:
net.Receive("TurnOn", function(len)
	// Grab the mode:
	local ent = net.ReadEntity()
	
	if ent:IsValid() then
		ent.PwnList = true
	end
end)

// The green switch mode:
net.Receive("GreenMode", function(len)
	// Grab the mode:
	_Green_Switch = net.ReadInt(2)
end)

// The server sent us the hint:
net.Receive("Hint", function(len)
	// Max length of a line:
	local maxlen = 24
	
	// Grab the hint
	local hint = string.Explode(" ", net.ReadString())
	local len = 0
	
	// The final hint to display:
	_Hint = ""
	
	// Cycle each word:
	for k,v in pairs(hint) do
		// Check the length:
		if len > 0 and (len + string.len(v)) > maxlen then
			_Hint = _Hint .. "\n"
			len = 0
		end
		
		// Store the hint:
		_Hint = _Hint .. v .. " "
		
		// Add to the length:
		len = len + string.len(v)
	end
	
end)
