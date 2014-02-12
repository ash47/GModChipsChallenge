/*---------------------------------------------------------
Server/blocks.lua

 - Block related functions
---------------------------------------------------------*/

// Contains a list of entites that still need to be found:
_Missing = {}

function AddWorldModel(ent, num, holder)
	// Ensure a container exists:
	_Missing[ent] = _Missing[ent] or {}
	
	// Store the request:
	table.insert(_Missing[ent], {num, holder})
end

// NOTE: This function is called in INIT.LUA
function LoadBlocks()
	// Stop blocks from reloading:
	if _Blocks then return end
	
	// This is our main item store:
	_Blocks = {}
	
	// Find all the items:
	local items = file.Find(GM.FolderName.."/gamemode/Server/blocks/*.lua", "LUA")
	
	for k,v in pairs(items) do
		include("Server/blocks/"..v)
	end
end

// Registers a block:
function RegisterBlock(block)
	if block.ID then
		_Blocks[block.ID] = block
	end
end

function FindMissingModels()
	// Try every entity:
	for k, v in pairs(ents.GetAll()) do
		// Check if our ent is needed:
		if _Missing[v:GetName()] then
			for kk, vv in pairs(_Missing[v:GetName()]) do
				// Store the model onto the detected block:
				_Blocks[vv[1]][vv[2]] = v:GetModel()
			end
			
			// Remove the need for our entity:
			_Missing[v:GetName()] = nil
		end
	end
	
	// Check if we failed to load any entities:
	if #_Missing > 0 then
		error("Failed to load "..#_Missing.." world entities!")
		PrintTable(_Missing)
	end
end
