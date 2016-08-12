local M
do
local dhtstatus = 0;
local tmep = 0;
local humi = 0;
local temp_decimal = 0;
local humi_decimal = 0;
local status = 0;

local function pub(m)
	if (dhtstatus == dht.OK) then
		local _payload = 
			{
				['humi'] = humi, 
				['temp'] = temp
			};

		dofile("mqtt/publish.lc").c_publish(m, ("/humi"), _payload,0,0);
	end
end

local function sub(m)
end

local function start(m)
	tmr.stop(5);
	tmr.alarm(5, 10000, 1, function()
		dhtstatus,temp,humi,temp_decimal,humi_decimal = dht.read11(4)
		if( status == dht.ERROR_CHECKSUM ) then
		elseif( status == dht.ERROR_TIMEOUT ) then
		end
	end)
end

M = {
	pub = pub,
	sub = sub,
	start = start
}
end
return M
