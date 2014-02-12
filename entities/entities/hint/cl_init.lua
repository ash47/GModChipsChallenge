/*---------------------------------------------------------
entities/entities/hint/cl_init.lua
---------------------------------------------------------*/

include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local mat = Material("Ash47_CC/Sprites/bot_47.png")

function ENT:Initialize()
	// Make it render properly:
	self:SetRenderBounds(Vector(-64, -64, 0), Vector(64, 64, 128))
end

function ENT:Draw()
	self:DrawTile(mat)
	
	if not _Map then
		// Draw the hint:
		local Pos = self:GetPos() + Vector(0,0,50)
		local Ang = (self.Entity:GetPos() - LocalPlayer():GetPos()):Angle()//self:GetAngles()
		
		// The hint to draw:
		local hint = _Hint or ""
		
		surface.SetFont("HintText")
		
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		local TextAng = Ang
		
		TextAng:RotateAroundAxis(TextAng:Right(), 90)
		
		cam.Start3D2D(Pos, TextAng, 0.25)
			draw.DrawText(hint, "HintText", 0, 0, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
