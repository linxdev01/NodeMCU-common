local M
do

local function getV(name,t)


	if t == nil then
		t = tab
	end

	local items = dofile("utils.lc").strsplit("/", name);
	if (#items-1) > 0 then
		local ptr = items[1];
		table.remove(items, 1);
		if type(t[ptr]) == "table" then
			return getV(dofile("utils.lc").strjoin("/", items), t[ptr]);
		end
	end

	if t[name] == nil then
		return nil;
	end

	return t[name];
end

M= { getV = getV }
end
return M
