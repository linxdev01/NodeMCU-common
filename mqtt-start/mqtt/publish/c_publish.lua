local M
do
local function c_publish(m, topic, payload, qos, retain, func)
	local _payload =  
		{
			["id"]    = _id,
			["name"]  = _name,
			["heap"] = node.heap(),
			["ip"]   = wifi.sta.getip(),
			['data']  = payload
		};

	dofile("mqtt/publish.lc").publish(m, topic, _payload, qos, retain, func);

end
M = { c_publish = c_publish }
end
return M
