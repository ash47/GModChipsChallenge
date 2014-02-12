/*---------------------------------------------------------
Shared/bInary.lua

 - Contains Binary Functions
---------------------------------------------------------*/

// Convert a decimal to a HEX:
function D2H(dec)
	// Convert to HEX:
    hex = string.upper(string.format("%x", dec))
	
	// Ensure it is of length 2:
	if string.len(hex) == 0 then
		hex = "00"
	elseif string.len(hex) == 1 then
		hex = "0" .. hex
	end
	
    return hex
end

// Read a single byte:
function read_byte(f)
	return string.byte(f:Read(1))
end

// Read a word:
function read_word(f)
	local s,i="",1;
	for i=0,1 do
		s = D2H(read_byte(f))..s;
	end
	--return H2D(s);
	return tonumber(tonumber(s, 16).."");
end

// Read a long:
function read_long(f)
	local s,i="",1;
	for i=0,3 do
		s = D2H(read_byte(f))..s;
	end
	return s;
end

// Binary XOR:
function bxor (a,b)
	local r = 0
	for i = 0, 31 do
		local x = a / 2 + b / 2
		if x ~= math.floor (x) then
			r = r + 2^i
		end
		a = math.floor (a / 2)
		b = math.floor (b / 2)
	end
	return r
end