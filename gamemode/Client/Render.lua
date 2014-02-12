/*---------------------------------------------------------
Client/Render.lua

 - Handels Rendering tiles
---------------------------------------------------------*/

// Grab the entity meta table:
local meta = FindMetaTable("Entity")

// Draw a tile:
function meta:DrawTile(mat)
	// Decide where to draw it:
	pos = self:GetPos() + Vector(0, 0, 0.05)
	
	// Set the material:
	render.SetMaterial(mat)
	
	// Draw it:
	render.DrawQuad(pos + Vector(-64, 64, 0), pos + Vector(64, 64, 0), pos + Vector(64, -64, 0), pos + Vector(-64, -64, 0))
end

// Draw a sprite:
function meta:DrawSprite(mat, up, size)
	// Set the material:
	render.SetMaterial(mat)
	
	// Draw it:
	render.DrawSprite( self:GetPos() + Vector(0, 0, up), size, size)
end

// Draw a tile:
function meta:DrawCube(mat)
	// Decide where to draw it:
	pos = self:GetPos()
	
	// Set the material:
	render.SetMaterial(mat)
	
	//Sides:
	render.DrawQuad(pos + Vector(64, 64, 128), pos + Vector(-64, 64, 128), pos + Vector(-64, 64, 0), pos + Vector(64, 64, 0))		// TOP
	render.DrawQuad(pos + Vector(-64, 64, 128), pos + Vector(-64, -64, 128), pos + Vector(-64, -64, 0), pos + Vector(-64, 64, 0))	// LEFT
	render.DrawQuad(pos + Vector(-64, -64, 128), pos + Vector(64, -64, 128), pos + Vector(64, -64, 0), pos + Vector(-64, -64, 0))	// BOTTOM
	render.DrawQuad(pos + Vector(64, -64, 128), pos + Vector(64, 64, 128), pos + Vector(64, 64, 0), pos + Vector(64, -64, 0))		// RIGHT
	
	// Top:
	render.DrawQuad(pos + Vector(-64, 64, 128), pos + Vector(64, 64, 128), pos + Vector(64, -64, 128), pos + Vector(-64, -64, 128))
end

function meta:DrawCubeNew(mat)
	// Decide where to draw it:
	pos = self:GetPos()
	
	local matrix = Matrix( );
	matrix:Translate( self:GetPos( ) );
	matrix:Rotate( self:GetAngles( ) );
 
	cam.PushModelMatrix( matrix );
 
		render.SetMaterial( mat );
 
		mesh.Begin( MATERIAL_QUADS, 5 );
			// WEST
			mesh.Quad(
				Vector(-64, -64, 0),
				Vector(-64, 64, 0),
				Vector(-64, 64, 128),
				Vector(-64, -64, 128)
			);
			// SOUTH
			mesh.Quad(
				Vector(64, -64, 0),
				Vector(-64, -64, 0),
				Vector(-64, -64, 128),
				Vector(64, -64, 128)
			);
			// EAST
			mesh.Quad(
				Vector(64, 64, 0),
				Vector(64, -64, 0),
				Vector(64, -64, 128),
				Vector(64, 64, 128)
			);
			// NORTH
			mesh.Quad(
				Vector(-64, 64, 0),
				Vector(64, 64, 0),
				Vector(64, 64, 128),
				Vector(-64, 64, 128)
			);
			
			// TOP
			mesh.Quad(
				Vector(64, -64, 128),
				Vector(-64, -64, 128),
				Vector(-64, 64, 128),
				Vector(64, 64, 128)
			);
 
		mesh.End( );
 
	cam.PopModelMatrix( );
end
