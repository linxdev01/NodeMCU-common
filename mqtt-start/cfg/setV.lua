local M
do

local function setV(name,val,t)

	if t == nil then
		t = tab
	end

	local items = dofile("utils.lc").strsplit("/", name);
	if (#items-1) > 0 then
		local ptr = items[1];
		table.remove(items, 1);
		-- Build as we go!
		if t[ptr] == nil then
			t[ptr] = {};
		end

		if type(t[ptr]) == "table" then
			return setV(dofile("utils.lc").strjoin("/", items), val, t[ptr]);
		end
	end

	t[name] = val;
end
M = { setV = setV }
end
return M
