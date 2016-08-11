local M
do
local tab = { 
	["server"] = "api.thingspeak.com",
	["wifi"] = {
		["sta"] = {
			["1"] = {
				["ap"] = "",
				["pass"] = ""
			},
		},
	},
	["po"] = {
		["1"] = {
			["state"] = 0,
			["enable"] = 0,
			["pin"] = 0

		},
	},
	['rgb'] = {
		["1"] = {
		},
	},
	["broker"] = {
		["1"] = {
			["ip"] = "192.168.1.9",
			["login"] = 0,
			["pass"] = 0
		},
	},
	["name"] = "UNKNOWN",
	["debug"] = 0,
	["endpoint"] = "nodemcu/",
	["gateway"]  = "192.168.1.9",
	["id"] = node.chipid()

};


local cjson = require "cjson";
local u     = dofile("utils.lc");

function cfgSave(t)
	file.remove("data.txt");
	file.open("data.txt", "w");
	file.write(cjson.encode(t));
	file.flush();
	file.close();
end

local function factory() 
	cfgSave(dofile("factory.lc").get_factory());
end

local function save()
	cfgSave(tab);
end

local function getT()
	return tab;
end

local function millis()
	return math.floor(tmr.now()/1000);
end

local function load() 
	local do_save = 0;
	if file.open("data.txt", "r") == nil then
		print ("Create new config!");
	  file.open("data.txt", "w");
		file.write(cjson.encode(tab));
		file.flush();
		file.close();
	  file.open("data.txt", "r");
	end

	local tstr = file.read();
	file.close();
    local status, err = pcall(function ()
		tab = cjson.decode(tstr);
	end)
	if err ~= nil then
		print ("Create new config!");
		-- we have bad data.  Need to remake
		save();
	end

	if tab["name"] == nil then
		tab["name"] = "UNKNOWN"
	end

	if tab["uuid"] == nil then
		tab["uuid"] = u.gen_uuid();
		do_save = 1;
	end

	if do_save == 1 then
		print ("do_save!");
		save();
	end

end

local function getV(name,t)
	if t == nil then
		t = tab
	end

	local items = u.strsplit("/", name);
	if (#items-1) > 0 then
		local ptr = items[1];
		table.remove(items, 1);
		if type(t[ptr]) == "table" then
			return getV(u.strjoin("/", items), t[ptr]);
		end
	end

	if t[name] == nil then
		return nil;
	end

	return t[name];
end


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


local function setV(name,val,t)
	if t == nil then
		t = tab
	end

	local items = u.strsplit("/", name);
	if (#items-1) > 0 then
		local ptr = items[1];
		table.remove(items, 1);
		-- Build as we go!
		if t[ptr] == nil then
			t[ptr] = {};
		end

		if type(t[ptr]) == "table" then
			return setV(u.strjoin("/", items), val, t[ptr]);
		end
	end

	t[name] = val;
end

local function delV(name)
	if tab[name] ~= nil then
		tab[name] = nil;
	end
end

local function _listap(t)
	print ("Listing APs");
	for ssid,v in pairs(t) do
		authmode, rssi, bssid, channel =
			string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
			print(ssid,authmode,rssi,bssid,channel)
	end
end
local function listap()
	wifi.sta.getap(_listap)
end

local function getInterval(name)
	local i = getV(name);

	if i == nil then
		i = 60
		setV(name, 60);
	end

	return i
end

local function getPath()
	_path = (getV("endpoint") .. getV("id") .. "/")
	return _path;
end


M = {
	load = load,
	getInterval = getInterval,
	setV = setV,
	getV = getV,
	delV = delV,
	show = show,
	factory = factory,
	listap = listap,
	get_path = get_path,
	getT = getT,
	millis = millis,
	save = save
}
end
return M
