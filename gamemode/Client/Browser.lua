/*---------------------------------------------------------
Client/Browser.lua

Level Browsing Code
---------------------------------------------------------*/

// Browser Settings:
local tw = 32				// The width of a tile
local th = 32				// The height of a tile
local packw = 300			// The width of the pack browser
local btn_blw = 150			// The width of the Browse Pack button
local btn_blh = 50			// The height of the Browse Pack button
local chip_w = tw * 9 + 8	// The width  of a level preview pain
local chip_h = th * 9 + 36	// The height of a level preview pain
local pp_padding = 4		// Preview Pain padding
local fs_chip_w = tw*32 + 8	// The width of the full screen view
local fs_chip_h = th*32 + 8	// The width of the full screen view
local chip_spacing = 0		// Spacing between each pain

// Storage:
_levels = {}
_levels.packs = {}
_levels.map_cache = {}

// The page we are on:
_levels.page = 1

// Request all the level packs:
function Levels_Pack_Request()
	// Clear our cache:
	_levels.packs = {}
	
	// Send the request:
	net.Start("LevelPacks")
	net.SendToServer()
end

// Recieve all the level packs:
net.Receive("LevelPacks", function(len)
	// Load all the levels:
	len = len - 16
	
	// Grab all the data:
	while(len > 0) do
		// Read the data:
		local name = net.ReadString()
		local num = net.ReadInt(16)
		
		// Remove the data:
		len = len - (string.len(name) + 1) * 8 - 16
		
		// Store the data:
		table.insert(_levels.packs, {name, num})
		
		// Try and add it to the list:
		if _LevelBrowser and _LevelBrowser:IsVisible() then
			_LevelBrowser.data_pains.Levels:AddLine(name, num)
		end
	end
end)

function GrabTotalPains()
	// Add the level drawers:
	local total_previewsx = math.floor(ScrW()/(chip_w + chip_spacing))
	local total_previewsy = math.floor((ScrH() - 36 - btn_blh)/(chip_h + chip_spacing))
	
	// Workout how many, in TOTAL the user can display:
	local total_display = total_previewsx * total_previewsy
	
	// Store it:
	_levels.pagetotal = total_display
	
	// Return it:
	return total_previewsx, total_previewsy, total_display
end

// Request a range of levels:
function RequestRange(name, lower, upper)
	// Lower case the name:
	name = string.lower(name)
	
	// Ensure it is in the valid range:
	lower = math.max(lower, 1)
	upper = math.min(upper, _levels.totalmaps)		// This can casue a glitch, as it grabs info from the currently loaded pack!!! -- FIX THIS, it should read from leveltotals[name] etc
	
	// Ensure a cache exists:
	if not _levels.map_cache then
		_levels.map_cache = {}
	end
	
	if not _levels.map_cache[name] then
		_levels.map_cache[name] = {}
	end
	
	// Request all the missing maps:
	net.Start("RequestLevel")
	
	// Tell them which pack to look in:
	net.WriteString(name)
	
	// A counter:
	local counter = 0
	
	// Check for missing levels:
	for k = lower, upper do
		// Do we have this level cached?
		if (not _levels.map_cache[name][k]) then
			// Ask for it then:
			net.WriteInt(k, 16)
			
			// Make the counter go up:
			counter = counter + 1
		end
	end
	
	// Only send if we actually asked for maps:
	if counter == (upper-lower+1) then
		// Create a request:
		net.Start("RequestLevelRange")
		net.WriteString(name)
		net.WriteInt(lower, 16)
		net.WriteInt(upper, 16)
		net.SendToServer()
	elseif counter > 0 then
		// Send the request:
		net.SendToServer()
	end
end

// Request a map from the server:
function RequestFullMap(name, num)
	// Check if we already have the map:
	if _levels.map_cache[name][num].full then
		return false
	end
	
	// Send the request:
	net.Start("RequestFullLevel")
	net.WriteString(name)
	net.WriteInt(num, 16)
	net.SendToServer()
end


// Attempt to load the pack:
function Load_Pack(name, num)
	// Basic noon protection:
	if not name or not num or num <= 0 then
		return
	end
	
	// Decide how many levels we can view:
	local total_previewsx, total_previewsy, total_display = GrabTotalPains()
	
	// Ensure they can display ATLEAST one:
	if total_display <= 0 then
		print("Upgrade your monitor, noob")
		return
	end
	
	// Hide the data pain:
	_LevelBrowser.data_pains:SetVisible(false)
	
	// Reset the next/prev buttons:
	_LevelBrowser.preview_pains.btn_NextPage:SetVisible(false)
	_LevelBrowser.preview_pains.btn_PrevPage:SetVisible(false)
	
	// Show the preview pains:
	_LevelBrowser.preview_pains:SetVisible(true)
	
	// Reset the page number:
	_levels.page = 1
	
	// Check for a next button:
	if num > _levels.page * total_display then
		_LevelBrowser.preview_pains.btn_NextPage:SetVisible(true)
	end
	
	// Store which one we are looking at:
	_levels.pack = string.lower(name)
	
	// Store the total number of levels:
	_levels.totalmaps = num
	
	// Grab the levels:
	RequestRange(name, (_levels.page-1) * total_display + 1, math.min(num, (_levels.page) * total_display))
	
	// Change the display mode:
	_LevelBrowser.mode = 1
end

function View_Big(num)
	// Enable the big view:
	if num > 0 then
		// Disable the preview pain:
		_LevelBrowser.preview_pains:SetVisible(false)
		
		// Enable the huge display:
		_LevelBrowser.huge_pains:SetVisible(true)
		
		// Grab the map:
		RequestFullMap(_levels.pack, num)
		
		// Change the display mode:
		_LevelBrowser.mode = 2
		
		// Update the huge pain's map:
		_LevelBrowser.huge_pains.fv.num = num
		
		// Grab missing maps:
		RequestRange(_levels.pack, num - _LevelBrowser.huge_pains.pt, num + _LevelBrowser.huge_pains.pt)
		
	// Disable the big view:
	else
		
	end
end

// Create's a full screen pain:
function FullScreenPain()
	local pain = vgui.Create("DPanel", _LevelBrowser)
	pain:SetPos(0, 24)
	pain:SetSize(ScrW(), ScrH() - 24)
	pain:SetVisible(false)
	pain.Paint = function()end
	return pain
end

function Browse_Maps()
	// Add the level drawers:
	local total_previewsx, total_previewsy, total_display = GrabTotalPains()
	
	// Ensure they can display ATLEAST one:
	if total_display <= 0 then
		print("Upgrade your monitor, noob")
		return
	end
	
	// Contains all our shit:
	_LevelBrowser = vgui.Create("DFrame")
	_LevelBrowser:SetPos(0, 0)
	_LevelBrowser:SetSize(ScrW(), ScrH())
	_LevelBrowser:SetTitle("Level Browser")
	_LevelBrowser:SetVisible(true)			// Visible
	_LevelBrowser:SetDraggable(false)		// No Dragging
	_LevelBrowser:ShowCloseButton(true)		// Show Close Button
	_LevelBrowser:SetSizable(false)			// No resizing
	_LevelBrowser:SetDeleteOnClose(true)	// Remove when closed
	_LevelBrowser:MakePopup()
	
	// Reset the mode:
	_LevelBrowser.mode = 0
	
	// The different frames:
	_LevelBrowser.data_pains = FullScreenPain()
	_LevelBrowser.preview_pains = FullScreenPain()
	_LevelBrowser.huge_pains = FullScreenPain()
	
	// Only display the data pains:
	_LevelBrowser.data_pains:SetVisible(true)
	
	/* ----------
	Data Pack Browser
	---------- */
	
	// Contains all our levels:
	local Levels = vgui.Create("DListView", _LevelBrowser.data_pains)
	Levels:SetPos(4, 4)
	Levels:SetSize(packw, Levels:GetParent():GetTall() - btn_blh - 16)
	Levels:SetMultiSelect(false)
	Levels:AddColumn("Pack Name")
	Levels:AddColumn("Total Levels")
	
	// Store levels:
	_LevelBrowser.data_pains.Levels = Levels
	
	// If we didn't find any packs:
	if #_levels.packs == 0 then
		// Request the packs:
		Levels_Pack_Request()
	else
		// Put the packs into our thingo:
		for k,v in pairs(_levels.packs) do
			Levels:AddLine(v[1], v[2])
		end
	end
	
	// The button "Browse Pack"
	local btn = vgui.Create("DButton", _LevelBrowser.data_pains)
	btn:SetText("Browse Pack")
	btn:SetSize(btn_blw, btn_blh)
	btn:SetPos(packw/2 - btn_blw/2 + 2, btn:GetParent():GetTall() - btn_blh - 6)
	btn:SetEnabled(true)
	btn.DoClick = function()
		// Read which level they want to load:
		local n = _LevelBrowser.data_pains.Levels:GetSelectedLine()
		
		// Only try to load if they selected a map:
		if n then
			// Grab the info:
			local m = _LevelBrowser.data_pains.Levels:GetLine(n)
			
			// Grab the name and number of levels
			local name = m:GetValue(1)
			local num  = m:GetValue(2)
			
			// Lets try and load the pack:
			Load_Pack(name, num)
		end
	end
	
	// Store the button:
	_LevelBrowser.data_pains.btn_BrowsePack = btn
	
	/* ----------
	Preview Pains
	---------- */
	
	// Workout some values to center it:
	local cw = _LevelBrowser.preview_pains:GetWide()/2 - ((chip_w + chip_spacing)*total_previewsx)/2
	local ch = (_LevelBrowser.preview_pains:GetTall() - 6 - btn_blh)/2 - ((chip_h + chip_spacing)*total_previewsy)/2
	
	for k = 1, total_previewsx do
		for kk = 1, total_previewsy do
			// Spawn a new frame:
			local p = vgui.Create("D_preview", _LevelBrowser.preview_pains)
			
			// Set the position:
			p:SetPos(cw + (k-1)*(chip_w + chip_spacing) + pp_padding, ch + (kk-1)*(chip_h + chip_spacing) + pp_padding)
			
			// Set the size:
			p:SetSize(chip_w, chip_h)
			
			// Store which number it is:
			p.num = (kk-1) * total_previewsx + k
			
			// Store the mode on it:
			p.mode = 1
		end
	end
	
	// The button "Next Page"
	local btn = vgui.Create("DButton", _LevelBrowser.preview_pains)
	btn:SetText("Next Page")
	btn:SetSize(btn_blw, btn_blh)
	btn:SetPos(btn:GetParent():GetWide() - btn_blw - 6, btn:GetParent():GetTall() - btn_blh - 6)
	btn:SetEnabled(true)			
	btn:SetVisible(false)
	
	// Allow it to be pressed
	btn.DoClick = function()
		// Stop from going the last map:
		if(_levels.page * _levels.pagetotal > _levels.totalmaps) then
			return
		end
		
		// Reset the page number:
		_levels.page = _levels.page + 1
		
		// Grab the levels:
		RequestRange(_levels.pack, (_levels.page-1) * total_display + 1, math.min(_levels.totalmaps, (_levels.page) * total_display))
		
		// Enable the prev button:
		_LevelBrowser.preview_pains.btn_PrevPage:SetVisible(true)
		
		// Hide ourselves:
		if(_levels.page * _levels.pagetotal >= _levels.totalmaps) then
			_LevelBrowser.preview_pains.btn_NextPage:SetVisible(false)
		end
	end
	
	// Store the button:
	_LevelBrowser.preview_pains.btn_NextPage = btn
	
	// The button "Previous Page"
	local btn = vgui.Create("DButton", _LevelBrowser.preview_pains)
	btn:SetText("Previous Page")
	btn:SetSize(btn_blw, btn_blh)
	btn:SetPos(btn:GetParent():GetWide() - 2 * btn_blw - 12, btn:GetParent():GetTall() - btn_blh - 6)
	btn:SetEnabled(true)
	btn:SetVisible(false)
	
	// Allow it to be pressed
	btn.DoClick = function()
		// Stop from going the last map:
		if((_levels.page - 1) * _levels.pagetotal <= 0) then
			return
		end
		
		// Reset the page number:
		_levels.page = _levels.page - 1
		
		// Grab the levels:
		RequestRange(_levels.pack, (_levels.page-1) * total_display + 1, math.min(_levels.totalmaps, (_levels.page) * total_display))
		
		// Enable the next button:
		_LevelBrowser.preview_pains.btn_NextPage:SetVisible(true)
		
		// Hide ourself:
		if(_levels.page <= 1) then
			_LevelBrowser.preview_pains.btn_PrevPage:SetVisible(false)
		end
	end
	
	// Store the button:
	_LevelBrowser.preview_pains.btn_PrevPage = btn
	
	// The button "Back"
	local btn = vgui.Create("DButton", _LevelBrowser.preview_pains)
	btn:SetText("Back")
	btn:SetSize(btn_blw, btn_blh)
	btn:SetPos(6, btn:GetParent():GetTall() - btn_blh - 6)
	btn:SetEnabled(true)
	btn.DoClick = function()
		// Go back:
		_LevelBrowser.preview_pains:SetVisible(false)
		_LevelBrowser.data_pains:SetVisible(true)
		_LevelBrowser.mode = 0
	end
	
	// Store the button:
	_LevelBrowser.preview_pains.btn_Back = btn
	
	/* ----------
	Huge preview screen
	---------- */
	
	// The full sized view:
	local p = vgui.Create("D_preview_full", _LevelBrowser.huge_pains)
	p:SetPos(p:GetParent():GetWide()/2 - fs_chip_w/2, p:GetParent():GetTall()/2 - fs_chip_h/2)
	p:SetSize(fs_chip_w, fs_chip_h)
	p.num = -1	// The map number to draw
	p.ts = 32	// How big each tile should be
	
	// Store the maxL
	_LevelBrowser.huge_pains.pt = 0
	
	// Store the full screen view:
	_LevelBrowser.huge_pains.fv = p
	
	// See how much space is left on a single side:
	local sp = (p:GetParent():GetWide() - fs_chip_w)/2
	
	// Decide how many panels on EACH side we can fit:
	local px = math.floor(sp/chip_w)
	
	// See if they can actually fit any:
	if px > 0 then
		// See how many panels we can fit vertically:
		local py = math.floor((p:GetParent():GetTall() - btn_blh)/chip_h)
		
		// Lets see how many pixels we have to do sexy looking shifts in:
		local shift_space = sp - px*chip_w
		
		// Work out how far to shift each one:
		local to_shift = shift_space/(px * py + 2)
		
		// Work out the vertical shift:
		local v_shift_space = p:GetParent():GetTall() - py * chip_h - btn_blh
		
		// Work out a good shift amount:
		local v_shift = v_shift_space/(py + 1)
		
		// How many in total to spawn:
		local pt = px * py
		
		// Update the total:
		_LevelBrowser.huge_pains.pt = pt
		
		// The movement dir:
		local dir = 1
		
		// How many we have put into a column:
		local col = 0
		
		// The one we are up to:
		local upto = 0
		
		// Starting out shift values:
		local xshift = to_shift
		local yshift = v_shift
		
		// Spawn them all:
		while upto < pt do
			// Spawn left stream:
			local pp = vgui.Create("D_preview", _LevelBrowser.huge_pains)
			pp:SetPos(p:GetParent():GetWide()/2 - fs_chip_w/2 - chip_w - upto * to_shift - xshift, (chip_h + v_shift) * col + yshift)
			pp:SetSize(chip_w, chip_h)
			pp.num = -(upto+1)
			pp.mode = 2
			
			// Spawn right stream:
			local pp = vgui.Create("D_preview", _LevelBrowser.huge_pains)
			pp:SetPos(p:GetParent():GetWide()/2 + fs_chip_w/2 + upto * to_shift + xshift, (chip_h + v_shift) * col + yshift)
			pp:SetSize(chip_w, chip_h)
			pp.num = (upto+1)
			pp.mode = 2
			
			// Add to col:
			col = col + dir
			
			// Ensure col:
			if col >= py then
				xshift = xshift + chip_w
				col = col - dir
				dir = -dir
			end
			
			// Move onto the next one:
			upto = upto + 1
		end
	else
		// If they actually read this, maybe they will follow it :D
		print("Upgrade your resolution for s SEXIER view :P")
	end
	
	// The button "Back"
	local btn = vgui.Create("DButton", _LevelBrowser.huge_pains)
	btn:SetText("Back")
	btn:SetSize(btn_blw, btn_blh)
	btn:SetPos(6, btn:GetParent():GetTall() - btn_blh - 6)
	btn:SetEnabled(true)
	btn.DoClick = function()
		// Go back:
		_LevelBrowser.huge_pains:SetVisible(false)
		_LevelBrowser.preview_pains:SetVisible(true)
		_LevelBrowser.mode = 1
	end
	
	// Store the button:
	_LevelBrowser.huge_pains.btn_Back = btn
end

// We pressed F4:
net.Receive("BrowseLevels", function(len)
	// Open the level browser:
	Browse_Maps()
end)

// Server just sent a MAP over:
net.Receive("RequestLevel", function(len)
	// Read the pack:
	local pack = string.lower(net.ReadString())
	
	// Read the level number:
	local num = net.ReadInt(16)
	
	// Build the cache:
	if not _levels.map_cache[pack] then
		_levels.map_cache[pack] = {}
	end
	
	if not _levels.map_cache[pack][num] then
		_levels.map_cache[pack][num] = {}
	end
	
	// Read the level title:
	_levels.map_cache[pack][num].leveltitle = net.ReadString()
	
	// Read the hint:
	_levels.map_cache[pack][num].hint = net.ReadString()
	
	// Read how many chips:
	_levels.map_cache[pack][num].totalchips = net.ReadInt(16)
	
	// Storage:
	_levels.map_cache[pack][num].mini_one = {}
	_levels.map_cache[pack][num].mini_two = {}
	
	// Read the data:
	for _x = 1, 9 do
		_levels.map_cache[pack][num].mini_one[_x] = {}
		_levels.map_cache[pack][num].mini_two[_x] = {}
		for _y = 1, 9 do
			_levels.map_cache[pack][num].mini_one[_x][_y] = net.ReadInt(8)
			_levels.map_cache[pack][num].mini_two[_x][_y] = net.ReadInt(8)
		end
	end
end)

// Server just sent a FULL MAP over:
net.Receive("RequestFullLevel", function(len)
	// Read the pack:
	local pack = string.lower(net.ReadString())
	
	// Read the level number:
	local num = net.ReadInt(16)
	
	len = len - (string.len(pack) + 1) * 8 - 16
	
	// Build the cache:
	if not _levels.map_cache[pack] then
		_levels.map_cache[pack] = {}
	end
	
	if not _levels.map_cache[pack][num] then
		_levels.map_cache[pack][num] = {}
	end
	
	// Read the level title:
	_levels.map_cache[pack][num].full = {}
	_levels.map_cache[pack][num].full_two = {}
	
	// Pre empty it:
	for i = 1, 32 do
		_levels.map_cache[pack][num].full[i] = {}
		_levels.map_cache[pack][num].full_two[i] = {}
	end
	
	// Go to the start:
	local x, y = 1, 1
	
	local two = false
	
	// Read out the encoded data:
	while(len > 0) do
		// Read data:
		local d = net.ReadInt(8)
		len = len - 8
		
		if d >= 0 then
			// Single tile:
			if not two then
				_levels.map_cache[pack][num].full[x][y] = d
			else
				_levels.map_cache[pack][num].full_two[x][y] = d
			end
		else
			// Convert D back to normal:
			d = math.abs(d+1)
			
			// How many to in a row:
			local n = net.ReadInt(12)
			
			len = len - 12
			if not two then
				_levels.map_cache[pack][num].full[x][y] = d
			else
				_levels.map_cache[pack][num].full_two[x][y] = d
			end
			
			while n>1 do
				// Drop n:
				n = n - 1
				
				// Wrap around:
				x = x + 1
				if x > 32 then
					x = 1
					y = y + 1
				end
				
				// Store it:
				 if not two then
					_levels.map_cache[pack][num].full[x][y] = d
				else
					_levels.map_cache[pack][num].full_two[x][y] = d
				end
			end
		end
		
		// Wrap around:
		x = x + 1
		if x > 32 then
			x = 1
			y = y + 1
			if y > 32 then
				two = true
				y = 1
			end
		end
	end
end)