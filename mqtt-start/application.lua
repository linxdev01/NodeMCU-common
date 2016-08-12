-- file : application.lua
local module = {}  
m = nil
local appStart = tmr.time();
local stateSend = 0;
local _mark = 0;
_path = nil;
_endpoint = nil;
_id = nil;
_name = nil;
custom = nil;


-- Sends a simple ping to the broker
local function send_ping()  
		if m == nil then return end
		if ((tmr.time() - stateSend) >= 60) then
			dofile("mqtt/publish.lc").send_state(m)
			stateSend = tmr.time();
		elseif ((tmr.time() - _mark) >= 7200) then
			dofile("mqtt/publish.lc").send_msg(m, "-- MARK --");
			_mark = tmr.time();
		else
			dofile("mqtt/publish.lc").send_ping(m);
		end

		-- custom
		custom.pub(m);
end

-- Sends my id to the broker for registration
local function register()  
	dofile("mqtt/register.lc").register(m);
end

local function mqtt_start()  

	_name = cfg.getV("name");
	_endpoint = cfg.getV("endpoint");
	_id = cfg.getV("id");
	_path = (_endpoint .. _id);

	custom = nil
	custom = dofile("custom.lc");
	custom.start();

    m = mqtt.Client(_id, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
		dofile("mqtt/topics.lc").process_topic(m, topic, data)
      end
    end)

    -- Connect to broker
    m:connect(cfg.getV("gateway"), 1883, 0, 1, function(con) 
		register();
        tmr.stop(6)
        tmr.alarm(6, 30000, 1, send_ping)
    end,
    function(client, reason) 
		-- We've lost Wifi?
		if wifi.sta.getip()== nil then
			i.set_state(2, nil);
			tmr.stop(6)
			m = nil;
			dofile("setup.lc").start(function() app.start() end);
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
