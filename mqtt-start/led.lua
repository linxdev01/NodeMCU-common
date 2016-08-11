local M
do
local dutyCycle = 100;
local dutyMax   = 1023;

local _init = 0;
local _r = -1;
local _g = -1;
local _b = -1;
local _rec = 0;

local _colors = {
	["black"]   = {0,   0,   0  },
	["red"]     = {255, 0,   0  },
	["green"]   = {0,   255, 0  },
	["cyan"]    = {0,   255, 255},
	["blue"]    = {0,   0,   255},
	["purple"]  = {255, 0,   255},
	["yellow"]  = {200, 75,  0  },
	["white"]   = {255, 255, 255}
};


-- sanity wrapper
local function _set(pin, val) 
	if pin  >=  0 then
	  local status, err = pcall(function ()
			--if cfg.getV("rgb/1/per") ~= nil then
			----	val = math.floor(255 - ((cfg.getV("rgb/1/per")/100)*255));
			----end
			pwm.setduty(pin, val);
		end)
	end
end

local function getPin(rec, color)
	return cfg.getV("rgb/" .. (rec) .. "/" .. (color));
end

local function _setup()


	if getPin(_rec, 'r') ~= nil then
		_r =  getPin(_rec, 'r')
		pwm.setup(_r, dutyCycle, dutyMax);
		pwm.start(_r);
	end

	if getPin(_rec, 'g') ~= nil then
		_g =  getPin(_rec, 'g')
		pwm.setup(_g, dutyCycle, dutyMax);
		pwm.start(_g);
	end

	if getPin(_rec, 'b') ~= nil then
		_b =  getPin(_rec, 'b')
		pwm.setup(_b, dutyCycle, dutyMax);
		pwm.start(_b);
	end

end

local function led(r,g,b)
	
	-- No setup then we setup
	if _init == 0 then
		_setup();
		_init = 1;
	end


	_set(_r, 0);
	_set(_g, 0);
	_set(_b, 0);

	_set(_r, r*1023/255);
	_set(_g, g*1023/255);
	_set(_b, b*1023/255);

end

local function white()
	led(255,255,255);
end

local function off()
	led(0,0,0);
end

local function blink()
end

local function start(rec)
	-- Throw exception?
	if rec == nil then
		return;
	end

	-- this block allows us to reinit.
	-- Maybe after config update eh?
	if _init == 1 then 
		led(0,0,0);
	end

	_init = 0;
	_r = -1;
	_g = -1;
	_b = -1;
	_rec = rec;

	-- turn it off.
	led(0,0,0);
end

local function color(name) 
	-- What do to if not exists?
	if name == nil then
		return
	end

	if _colors[name] == nil then
		return
	end

	local r,g,b = unpack(_colors[name])

	led(r,g,b);


end

M = {
	led = led,
	white = white,
	off = off,
	start = start,
	blink = blink,
	color = color
}
end
return M

