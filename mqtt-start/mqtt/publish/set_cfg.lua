local M
do

local function set_cfg(m, data)
	local t = cjson.decode(data);
	if t["name"] == nil then return end
	i.say("set: " .. t["name"] .. " -> " .. t["value"])
	cfg.setVs(t["name"], t["value"]);
end

M = {set_cfg = set_cfg }
end
return M
