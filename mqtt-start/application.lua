-- file : application.lua
local module = {}  
m = nil
local appStart = tmr.time();
local stateSend = 0;
local _mark = 0;
local _path = nil;

-- Sends a simple ping to the broker
local function send_ping()  
		if m == nil then return end

		if ((tmr.time() - stateSend) >= 60) then
			dofile("mcfg.lc").send_state(m)
			stateSend = tmr.time();
		elseif ((tmr.time() - _mark) >= 7200) then
			dofile("mcfg.lc").send_msg(m, "-- MARK --");
			_mark = tmr.time();
		else
			dofile("mcfg.lc").send_ping(m);
		end
end

-- Sends my id to the broker for registration
local function register_myself()  
	local _name = cfg.getV("name");
	i.say("path: " .. (_path));
    m:subscribe(_path .. "/#",0,function(conn)
		local _m = "Connected to broker as [" .. cfg.getV("id") .. "]";
		i.set_state(0, _m)
		dofile("mcfg.lc").send_msg(m, _m );

		-- read my notes in mcfg.lua for an explaination!
		if((_name ~= nil) and (_name ~= 'UNKNOWN')) then

			m:subscribe(cfg.getV("endpoint") .. _name ..  "/#",0,function(conn)
					_m = "Connected to broker as [" .. _name .. "]";
					i.say(_m);
					dofile("mcfg.lc").send_msg(m, _m);
			end)
		end	
    end)

	m:on("offline", function(client) 
		tmr.stop(6)
		i.set_state(1, "Lost connection to broker.");
	end)
end

local function mqtt_start()  

	_path = (cfg.getV("endpoint") .. cfg.getV("id"));

    m = mqtt.Client(cfg.getV("id"), 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
		  -- do something, we have received a message
		  if (string.find(topic, "/po/1") ~= nil) then
			dofile("mcfg.lc").send_msg(m, "/po/1 -> " .. (data));
			dofile("relay.lc").relay(1,data);
		  elseif (string.find(topic, "/state") ~= nil) then
			-- ignore this
		  elseif (string.find(topic, "/cmd/echo") ~= nil) then
			dofile("mcfg.lc").send_msg(m, data);
		  elseif (string.find(topic, "/cmd/restart") ~= nil) then
			dofile("cmds.lc").restart(m, data);
		  elseif (string.find(topic, "/cmd/show") ~= nil) then
			dofile("mcfg.lc").send_cfg(m);
		  elseif (string.find(topic, "/cmd/setv") ~= nil) then
			dofile("mcfg.lc").set_cfg(m,data);
		  elseif (string.find(topic, "/msg") ~= nil) then
			-- ignore these
		  else
			-- i.say("Topic: " .. (topic));
		  end
      end
    end)
    -- Connect to broker
    m:connect(cfg.getV("gateway"), 1883, 0, 1, function(con) 
        register_myself()
        tmr.stop(6)
        tmr.alarm(6, 30000, 1, send_ping)
    end,
    function(client, reason) 
		-- We've lost Wifi?
		if wifi.sta.getip()== nil then
			i.set_state(2, nil);
			tmr.stop(6)
			m = nil;
			setup.start();
		else
			i.set_state(1, nil);
		end
	end)	

end

function module.start()  
	dofile("relay.lc").restore(1);
	_mark = tmr.time();
	mqtt_start()
end


return module  
