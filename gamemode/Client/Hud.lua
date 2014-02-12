/*---------------------------------------------------------
Client/Hud.lua

 - Draws the hud
---------------------------------------------------------*/

// Blank texture:
local blank = Material( "Ash47_CC/Sprites/bot_0.png")

// Key Textures:
local _text_keys = {}
_text_keys[1] = Material( "Ash47_CC/Sprites/bot_100.png")
_text_keys[2] = Material( "Ash47_CC/Sprites/bot_101.png")
_text_keys[3] = Material( "Ash47_CC/Sprites/bot_102.png")
_text_keys[4] = Material( "Ash47_CC/Sprites/bot_103.png")

// Boot textures:
local _text_boots = {}
_text_boots[1] = Material( "Ash47_CC/Sprites/bot_104.png" )
_text_boots[2] = Material( "Ash47_CC/Sprites/bot_105.png" )
_text_boots[3] = Material( "Ash47_CC/Sprites/bot_106.png" )
_text_boots[4] = Material( "Ash47_CC/Sprites/bot_107.png" )

// Reset shoes:
_shoes = _shoes or {}

// Reset our keys:
_keys = _keys or {}

// Draws the hud:
function GM:HUDPaint()
	// The position for the inventory:
	local _x = -32
	local _y = ScrH() - 150
	
	local c = (_TotalChips or 0)
	local txt = "No chips left"
	
	// Change the message drawn:
	if c == 1 then
		txt = "1 chip left"
	elseif c > 0 then
		txt =  c .. " chips left"
	end
	
	// Draw the chips left:
	draw.DrawText(txt, "HudText", _x + 208, _y - 24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	
	// Get ready to draw:
	surface.SetDrawColor( 255, 255, 255, 255 );
	
	// Cycle each tile:
	for k,v in pairs(_text_boots) do
		// Grab the texture:
		if _shoes[k] then
			surface.SetMaterial( v )
		else
			surface.SetMaterial( blank )
		end
		
		// Draw the tile:
		surface.DrawTexturedRect( _x + 64*k, _y, 64, 64)
	end
	
	// Cycle each tile:
	for k,v in pairs(_text_keys) do
		// Grab the texture:
		if _keys[k] and _keys[k] > 0 then
			surface.SetMaterial( v )
		else
			surface.SetMaterial( blank )
		end
		
		// Draw the tile:
		surface.DrawTexturedRect( _x + 64*k, _y + 64, 64, 64)
		
		// Draw the amount of keys on:
		if _keys[k] and _keys[k] > 1 then
			draw.DrawText("x" .. _keys[k], "KeyNum", _x + 64*k + 2, _y + 112, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end
	end
	
	
	
	/*rtTexture = surface.GetTextureID( "pp/rt" )
	surface.SetTexture( rtTexture )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( ScrW() - 288 , 32, 256, 256 )*/
end

// Hides the old hud:
function GM:HUDShouldDraw( name )
	// Hide health and armour:
	if(name == "CHudHealth") or (name == "CHudBattery") or (name == "CHudCrosshair") then
		return false
	end
	
	// Enable everything else:
	return true
end

// Function to enable map view:
function EnableMapView(on)
	_Map = on
	
	// If map is on:
	if _Map then
		// Store the view angles:
		if(LocalPlayer():IsValid()) then
			_View_Angles = LocalPlayer():EyeAngles()
		end
		
		// View from above:
		hook.Add("CalcView", "MapView", MapView)
		
		// Draw the player:
		hook.Add("ShouldDrawLocalPlayer", "MapView", function() return true end)
	else
		// Stop view from above:
		hook.Remove("CalcView", "MapView")
		
		// Stop draw player:
		hook.Remove("ShouldDrawLocalPlayer", "MapView")
		
		// Put the old angles back:
		if _View_Angles then
			LocalPlayer():SetEyeAngles(_View_Angles)
		end
	end
end

// Toggle minimap mode:
net.Receive("Map", function(len)
	// Toggle Map:
	EnableMapView(not _Map)
end)

function MapView(ply, pos, angles, fov)
	// Lock the viewing angle:
	LocalPlayer():SetEyeAngles(Angle(0, 90, 0))
	
	// Work out where to view from:
    local view = {}
    view.origin = pos + Vector(0, 0, 1024)
    view.angles = Angle(90, 90, 0)
    view.fov = fov
 
    return view
end














function UpdateRenderTarget()
	Ent = LocalPlayer()
	
	if ( !Ent || !Ent:IsValid() ) then return end

	if ( !RenderTargetCamera || !RenderTargetCamera:IsValid() ) then
	
		RenderTargetCamera = ents.Create( "point_camera" )
		RenderTargetCamera:SetKeyValue( "GlobalOverride", 1 )
		RenderTargetCamera:Spawn()
		RenderTargetCamera:Activate()
		RenderTargetCamera:Fire( "SetOn", "", 0.0 )

	end
	Pos = Ent:LocalToWorld( Vector( 12,0,0) )
	RenderTargetCamera:SetPos(Pos)
	RenderTargetCamera:SetAngles(Ent:GetAngles())
	RenderTargetCamera:SetParent(Ent)

	RenderTargetCameraProp = Ent
	
end