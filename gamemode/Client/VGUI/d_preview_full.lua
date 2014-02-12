	/*---------------------------------------------------------
Client/VGUI/d_preview_Full.lua

 - The way the full preview looks
---------------------------------------------------------*/

local PANEL = {}

PANEL.Num = -1

function PANEL:Init()
	// Start out invisible:
	self.alpha = 0
end

function PANEL:Paint()
	// Decide weather or not to draw:
	if not _levels.pack then return end
	if not _levels.map_cache[_levels.pack] then return end
	
	// Grab our number:
	local num = self.num
	
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
	
	// The position to draw from, -32
	local x, y = 4, 4
	
	// Reset the colour:
	surface.SetDrawColor( 255, 255, 255, self.alpha );
	
	if not _levels.map_cache[_levels.pack][num].full then return end
	
	// Draw the tiles:
	for kk = 1,32 do
		for k = 1, 32 do
			// Bottom layer:
			surface.SetMaterial(Material("Ash47_CC/Sprites/bot_"..(_levels.map_cache[_levels.pack][num].full_two[k][kk] or 2)..".png"))
			surface.DrawTexturedRect(x + (k-1) * self.ts, y + (kk-1) * self.ts, self.ts, self.ts)
			
			// Top layer:
			surface.SetMaterial(Material("Ash47_CC/Sprites/top_"..(_levels.map_cache[_levels.pack][num].full[k][kk] or 2)..".png"))
			surface.DrawTexturedRect(x + (k-1) * self.ts, y + (kk-1) * self.ts, self.ts, self.ts)
		end
	end
	
	return true
end

vgui.Register("D_preview_full", PANEL, "Panel")
