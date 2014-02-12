/*---------------------------------------------------------
Client/Bindings.lua
---------------------------------------------------------*/

function GM:PlayerBindPress(ply, bind)
	if string.find(bind, "+jump") then
		return true
	end
end
