
local M
do
local _ap;
local _pass;
local _tries = 0;
local _rec = 0;
local _run = nil;


local function wifi_wait_ip()  
	
  if _stop == 1 then return end


  if _tries >= 5 then i.set_state(2, nil) end

  if _tries % 10 == 0 then
	_rec  = _rec + 1;
	_ap, _pass = cfg.getWifi(_rec);
	if _ap == nil then
		_rec  = _rec - 1;
		_ap, _pass = cfg.getWifi(_rec);
	end

	-- We either have 1 or 1 is not even configured
	if _ap == nil then
		i.say("No wifi configuration!");
		return
	end

	wifi.setmode(wifi.STATION);
	wifi.sta.config(_ap, _pass);
	wifi.sta.connect()


	i.say("Connecting to " .. (_ap) .. " ...");
  end

  _tries = _tries + 1;

  if wifi.sta.getip()== nil then
    i.say("IP unavailable, Waiting...")
  else
    tmr.stop(1)
	i.set_state(0, nil);
    i.say("\n====================================")
    i.say("ESP8266 mode is: " .. wifi.getmode())
    i.say("MAC address is: " .. wifi.sta.getmac())
    i.say("IP is "..wifi.sta.getip())
    i.say("====================================")

    local status, err = pcall(function ()
		if _run ~= nil then _run() end
	end)

	if err ~= nil then print("ERR: " .. (err)) end

  end
end

local function wifi_start()  
	_tries = 0;
	if _rec ~= 0 then _tries = 1 end;
	tmr.alarm(1, 3000, 1, wifi_wait_ip)
end

local function start(val)  
  _run = val
  i.say("Configuring Wifi ...")
  wifi.sta.disconnect();
  wifi_start();
end

M = {
	start = start,
	get_wifi = get_wifi
}
end
return M

