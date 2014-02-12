	/*---------------------------------------------------------
Client/VGUI/d_preview.lua

 - The way preview pains look
---------------------------------------------------------*/

local PANEL = {}

PANEL.num = -1

function PANEL:Init()
	// Start out invisible:
	self.alpha = 0
	
	// Change the cursor:
	self:SetCursor("hand");
end

// Cursor entered:
function PANEL:OnCursorEntered()
	self.inside = true
end

// Cursor exited:
function PANEL:OnCursorExited()
	self.inside = false
end

// When released:
function PANEL:OnMouseReleased()
	// Ensure it is visible:
	if self.alpha <= 0 then return end
	
	// The full screen display of maps:
	if _LevelBrowser.mode == 1 then
		// Grab our map number:
		local num = (_levels.page - 1) * _levels.pagetotal + self.num
		
		// Load the full screen view:
		View_Big(num)
	elseif _LevelBrowser.mode == 2 then
		// Grab our map number:
		local num = _LevelBrowser.huge_pains.fv.num + self.num
		
		// Load the full screen view:
		View_Big(num)
	end
end

function PANEL:Paint()
	// Decide weather or not to draw:
	if not _levels.pack then return end
	if not _levels.map_cache[_levels.pack] then return end
	
	local num = -1
	
	if _LevelBrowser.mode == 1 then
		// Grab our number:
		num = (_levels.page - 1) * _levels.pagetotal + self.num
	elseif _LevelBrowser.mode == 2 then
		// Grab our number:
		num = _LevelBrowser.huge_pains.fv.num + self.num
	end
	
	// Stop drawing if we don't know what to draw:
	if not _levels.map_cache[_levels.pack][num] then self.alpha = 0 return end
	
	// Increase the alpha
	self.alpha = self.alpha + 10
	if self.alpha >= 255 then
		self.alpha = 255
	end
	
	local w = self:GetWide()
	local h = self:GetTall()
	
	// Highlighting:
	if self.inside then
		surface.SetDrawColor(200, 255, 200, self.alpha)
	else
		surface.SetDrawColor(255, 255, 255, self.alpha)
	end
	
	// Draw an outline:
	surface.DrawRect(0, 0, w, h)
	
	draw.DrawText(num.." - ".._levels.map_cache[_levels.pack][num].leveltitle, "ChipPainText", w/2, h-24, Color(0, 0, 0, 255),TEXT_ALIGN_CENTER)
	
	// The position to draw from, -32
	local x, y = 4, 4
	
	// Reset the colour:
	surface.SetDrawColor( 255, 255, 255, self.alpha );
	
	// Draw the tiles:
	for k = 1,9 do
		for kk = 1, 9 do
			// Bottom Layer:
			surface.SetMaterial(Material("Ash47_CC/Sprites/bot_".._levels.map_cache[_levels.pack][num].mini_one[k][kk]..".png", "nocull"))
			surface.DrawTexturedRect(x + (k-1) * 32, y + (kk-1) * 32, 32, 32)
			
			// Top Layer:
			surface.SetMaterial(Material("Ash47_CC/Sprites/top_".._levels.map_cache[_levels.pack][num].mini_one[k][kk]..".png", "nocull"))
			surface.DrawTexturedRect(x + (k-1) * 32, y + (kk-1) * 32, 32, 32)
			
			//draw.DrawText(_levels.map_cache[_levels.pack][num].mini_one[k][kk], "ChipPainText", x + (k-1) * 32, y + (kk-1) * 32, Color(0, 0, 0, 255),TEXT_ALIGN_LEFT)
		end
	end
	
	return true
end

vgui.Register("D_preview", PANEL, "Panel")
