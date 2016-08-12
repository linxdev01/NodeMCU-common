local M
do

-- 08a4bef8-07c6-4697-8c7f-bab023538295

local function newStack ()
	return {""}   -- starts with an empty string
end

local function addString (stack, s)
	table.insert(stack, s)    -- push 's' into the the stack
	for i=#stack-1, 1, -1 do
		if string.len(stack[i]) > string.len(stack[i+1]) then
			break
		end
		stack[i] = stack[i] .. table.remove(stack)
	end
end

local function get_rhex() 
	return string.format("%02x", math.random(255));
end

local function gen_uuid() 
	local s = newStack();
	math.randomseed(tmr.now());
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, table.concat( strsplit(":", wifi.sta.getmac()), ""));
	return table.concat(s, "");
end

M = { gen_uuid = get_uuid }
end
return M
