local M
do

-- mqtt:publish(topic, payload, qos, retain[, function(client)])
-- Not sure what to do here.  Do we call func 2x?  I'm assuming really only
-- once.   The idea is the were are using the chipid as the real address, but
-- if the user assigns a name to the NodeMCU we'll also publish under that name
-- It is possible an agent at the broker could handle this.  I'm not sure of the best method.
-- ALL I know is that I can't remember the chipids and have to look at command history etc.
local function publish(m, topic, payload, qos, retain, func)
	if m == nil then return end;
	if payload == nil then return end

	if type(payload) == "table" then
		payload = cjson.encode(payload);
	end

	m:publish( _path .. topic, payload, qos, retain, function(client)
	  -- pub under our alias
	  if((_name ~= nil) and (_name ~= "UNKNOWN")) then
		m:publish(_endpint .. _name ..  topic, payload, qos, retain, function(client)
		end)
	  end
	end)
end

local function c_publish(m, topic, payload, qos, retain, func)
	dofile("mqtt/publish/c_publish.lc").c_publish(m, topic, payload, qos, retain, func)
end

local function send_cfg(m)
	if m == nil then return end;
	local _payload = cjson.encode( cfg.getT() );
	publish(m, "/cfg", _payload, 0,0, nil);
end

local function send_state(m)
	if m == nil then return end;
	local _payload =  
		{
			["1"]  = cfg.getV("po/1/state");
		};
	c_publish(m, "/state", _payload, 0,0, nil);
end

local function set_cfg(m, data)
	dofile("mqtt/publish/set_cfg.lc").set_cfg(m,data);
end

local function send_msg(m, msg)
	if m == nil then return end;
	local _payload = cjson.encode( 
			{ 
				["name"] = _name,
				["id"]   = _id,
				["msg"]  = msg 
			} 
	);
	publish(m, "/msg", _payload, 0,0, nil);
end

local function send_ping(m)
	if m == nil then return end;
	m:publish(_endpoint .. "ping",cjson.encode(
				{
					["id"]   = _id,
					["name"] = _name,
					["heap"] = node.heap(),
					["ip"]   = wifi.sta.getip()
				}
	),0,0)
end


M = { 
	send_cfg = send_cfg,
	send_state = send_state,
	send_msg = send_msg,
	send_ping = send_ping,
	publish = publish,
	c_publish = c_publish,
	set_cfg = set_cfg
}
end
return M

