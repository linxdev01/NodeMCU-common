local M
do
local tab = {};
local _loaded = 0;
local cjson = require "cjson";
-- local u     = dofile("utils.lc");

-- write whatever is passed!
local function cfgSave(t)
	file.remove("data.txt");
	file.open("data.txt", "w");
	file.write(cjson.encode(t));
	file.flush();
	file.close();
end

-- reset to factory
local function factory() 
	tab = dofile("cfg/factory.lc").get_factory();
	cfgSave(tab);
end

local function save()
	if _loaded == 0 then _load() end
	cfgSave(tab);
end

local function millis()
	return math.floor(tmr.now()/1000);
end

local function _load() 
	tab = dofile("cfg/load.lc")._load();
	_loaded = 1;
end

function getV(name,t)
	if _loaded == 0 then _load() end
	local v = dofile("cfg/getV.lc").getV(name, t)
	return v;
end


local function _show(tree, sappend)
	dofile("cfg/show.lc")._show(tree, sappend);
end

local function show(path)
	if _loaded == 0 then _load() end
	dofile("cfg/show.lc").show(path);
end


local function setV(name,val,t)
	if _loaded == 0 then _load() end
	dofile("cfg/setV.lc").setV(name, val,t);
end

local function delV(name)
	if _loaded == 0 then _load() end

	if tab[name] ~= nil then
		tab[name] = nil;
	end
end


local function listap()
	dofile("cfg/listap.lc").listap();
end

local function getInterval(name)
	if _loaded == 0 then _load() end

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

local function getT()
	if _loaded == 0 then _load() end
	return tab;
end

local function getWifi(rec)
	return dofile("cfg/getWifi.lc").getWifi(rec);
end

-- so you can dofile("cfg.lc").setVs(....)
-- setV() will do the load for you
local function setVs(name,val,t)
	setV(name, val, t)
	save();
end

-- mimic constructor
local function new()
	_load();
end

local function ls()
	for k,v in pairs(file.list()) do l = string.format("%-15s",k) print(l.."   "..v.." bytes") end
end



M = {
	load = _load,
	getInterval = getInterval,
	setV = setV,
	setVs = setVs,
	getV = getV,
	delV = delV,
	show = show,
	factory = factory,
	listap = listap,
	get_path = get_path,
	getT = getT,
	millis = millis,
	new = new,
	ls = ls,
	save = save,
	getWifi = getWifi
}
end
return M
