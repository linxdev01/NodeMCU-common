local M
do

local _state
local _s = 0;
local _last = -3;
local _stop = 0;
local _quiet = 0;
local led = nil;

local function quiet(val) 
	if val == nil then _quiet = 0 return end
	_quiet = val;
end

local function say(str) 
	if _quiet ~= 0 then return end
	if str == nil then return end
	print (str);
end

local function _blink(color, do_blink) 
		if do_blink == 0 then
			if _last == _state then return end
			led.color(color)
			_last = _state
			return 
		end

		_last = _state
		if _s == 0 then
			_s = 1
			led.color(color);
		else
			_s = 0
			led.off();
		end
end

local function _indicator() 
	collectgarbage("collect");
	if _state == 2 then _blink("red",1) return end; 
	if _state == 1 then _blink("yellow",1) return end; 
	if _state == 0 then _blink("green",0); return end; 

	_blink("blue",0);
	
end

local function set_state(value, msg)

	if msg ~= nil then i.say(msg) end

	if _last == value then return end
	_state = value
	_s = 0;

end

local function start()
	-- init
	if _stop == 0 then
		_state = -1
	end

	if led == nil then
		led = require "led";
		led.start(1);
	end

	_stop = 0;
	tmr.stop(4);
	tmr.alarm(4, 500, 1, _indicator)
end

local function stop()
	_stop = 1;
	_last = -3
	tmr.stop(4);
	led.off();
end

local function get_led()
	return led
end


M = { 
	quiet = quiet,
	say = say,
	start = start,
	stop = stop,
	get_led = get_led,
	set_state = set_state
};
end
return M;
