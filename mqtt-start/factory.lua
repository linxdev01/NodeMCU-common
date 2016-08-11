local M
do
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
	["broker"] = {
		["1"] = {
			["ip"] = "192.168.1.9",
			["login"] = 0,
			["pass"] = 0
		},
	},
	["debug"] = 0,
	["endpoint"] = "nodemcu/",
	["gateway"]  = "192.168.1.9",
	["id"] = node.chipid()

}

local function get_factory()
	return factory_tab;
end

M = {
	get_factory = get_factory
}
end
return M
