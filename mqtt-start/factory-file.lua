
local factory_tab = {
	["server"] = "",
	["wifi"] = {
		["sta"] = {
			["1"] = {
				["ap"] = "",
				["pass"] = "",
				["enable"] = 0,
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
	["debug"] = 0,
	["endpoint"] = "nodemcu/",
	["gateway"]  = "192.168.1.9",
	["id"] = 0

}

local cjson = require "cjson";

local file, err = io.open("factory.txt", "w")
if file == nil then
	print ("Failed to open factory.txt");
else
	file:write(cjson.encode(factory_tab));
	file:flush();
	file:close();
end
