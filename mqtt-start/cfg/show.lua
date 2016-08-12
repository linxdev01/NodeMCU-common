local M
do

local function _show(tree, sappend)

	local treeV = tree;

	if tree == nil then
		treeV = tab;
	end


	local a = {}
	for n in pairs(treeV) do table.insert(a, n) end
	table.sort(a)

	for i,n in ipairs(a) 
	do
		local v = treeV[n];
		if type(v) ~= "table" then
			if v == nil then
				v = "[nil]";
			end
			if sappend ~= nil then
				print(string.format("%-20s : %s",(sappend .. "/" .. n), v)) 
			else
				print(string.format("%-20s : %s",n, v)) 
			end
		end
	end

	for i,n in ipairs(a) 
	do 
		local v = treeV[n];
		if type(v) == "table" then
			local _sappend = sappend;
			if sappend ~= nil then
				sappend = ((sappend) .. "/" .. (n));
			else
				sappend = n;
			end

			_show(treeV[n], sappend);
			-- restore
			sappend = _sappend;
		else
		end
	end

end

local function show(path)
	local tree;

	if path ~= nil then
		tree = getV(path, tab);
		_show(tree);
	else 
		_show();
	end

	if wifi.sta.getip() ~= nil then
		print("--");
		print("-- " .. (wifi.sta.getip()));
	end
end

M = {
	_show = _show,
	show = show
}
end
return M

