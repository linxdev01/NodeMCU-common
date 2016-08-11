local M
do

-- mqtt:publish(topic, payload, qos, retain[, function(client)])
-- Not sure what to do here.  Do we call func 2x?  I'm assuming really only
-- once.   The idea is the were are using the chipid as the real address, but
-- if the user assigns a name to the NodeMCU we'll also publish under that name
-- It is possible an agent at the broker could handle this.  I'm not sure of the best method.
-- ALL I know is that I can't remember the chipids and have to look at command history etc.
local function publish(con, topic, payload, qos, retain, func)
	if m == nil then return end;
	if payload == nil then return end

	if type(payload) == "table" then
		payload = cjson.encode(payload);
	end

	_path = (cfg.getV("endpoint") .. cfg.getV("id"));
	m:publish( _path .. topic, payload, qos, retain, function(client)
	  -- pub under our alias
	  if((cfg.getV("name")) ~= nil and (cfg.getV("name") ~= "UNKNOWN")) then
		_path = (cfg.getV("endpoint") .. cfg.getV("name"));
		m:publish( _path .. topic, payload, qos, retain, function(client)
		end)
	  end
	end)
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
			["id"] = cfg.getV("id"),
			["name"] = cfg.getV("name"),
			['data']  = {
				["1"]  = cfg.getV("po/1/state");
			}
		};
	publish(m, "/state", _payload, 0,0, nil);
end

local function set_cfg(m, data)
	t = cjson.decode(data);
	if t["name"] == nil then return end
	i.say("set: " .. t["name"] .. " -> " .. t["value"])
	cfg.setV(t["name"], t["value"]);
	cfg.save();
end

local function send_msg(m, msg)
	if m == nil then return end;
	local _payload = cjson.encode( 
			{ 
				["name"] = cfg.getV("name"),
				["id"]   = cfg.getV("id"),
				["msg"]  = msg 
			} 
	);
	publish(m, "/msg", _payload, 0,0, nil);
end

local function send_ping(m)
	if m == nil then return end;
	m:publish(cfg.getV("endpoint") .. "ping",cjson.encode(
				{
					["id"] = cfg.getV("id"),
					["name"] = cfg.getV("name"),
					["heap"] = node.heap(),
					["ip"] = wifi.sta.getip()
				}
	),0,0)
end


M = { 
	send_cfg = send_cfg,
	send_state = send_state,
	send_msg = send_msg,
	send_ping = send_ping,
	publish = publish,
	set_cfg = set_cfg
}
end
return M

