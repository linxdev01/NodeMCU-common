local M
do

local function cfgSave(t)
	file.remove("data.txt");
	file.open("data.txt", "w");
	file.write(cjson.encode(t));
	file.flush();
	file.close();
end


local function _load()
	-- start with factory

	tab = dofile("cfg/factory.lc").get_factory();

	local do_save = 0;
	if file.open("data.txt", "r") == nil then
		print ("Create new config!");
		cfgSave(tab);
		file.open("data.txt", "r");
	end

	local tstr = file.read();
	file.close();

	-- Chip ID needs to be really the chip
	-- yes, you can set it, but on load that will be fixed!
	tab["id"] = node.chipid()

    local status, err = pcall(function ()
		tab = cjson.decode(tstr);

		-- merge
		tab =dofile("utils.lc").merge( dofile("cfg/factory.lc").get_factory(), tab);
	end)

	-- we have bad data.  Need to remake
	if err ~= nil then
		tab = dofile("cfg/factory.lc").get_factory();
		cfgSave(tab);
	end


	if tab["name"] == nil then
		tab["name"] = "UNKNOWN"
		do_save = 1;
	end

	if tab["uuid"] == nil then
		tab["uuid"] = dofile("utils.lc").gen_uuid();
		do_save = 1;
	end

	if do_save == 1 then
		cfgSave(tab);
	end

	return tab;

end



M = { 
	_load = _load

};
end
return M;
