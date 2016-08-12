local M
do

local function register(m)  
	if m == nil then return end

	i.say("path: " .. (_path));
    m:subscribe(_path .. "/#",0,function(conn)
		local _m = "Connected to broker as [" .. _id .. "]";
		i.set_state(0, _m)
		dofile("mqtt/publish.lc").send_msg(m, _m );

		-- read my notes in mcfg.lua for an explaination!
		if((_name ~= nil) and (_name ~= 'UNKNOWN')) then

			m:subscribe(_endpoint .. _name ..  "/#",0,function(conn)
					_m = "Connected to broker as [" .. _name .. "]";
					i.say(_m);
					dofile("mqtt/publish.lc").send_msg(m, _m);
			end)
		end	
    end)

	m:on("offline", function(client) 
		tmr.stop(6)
		i.set_state(1, "Lost connection to broker.");
	end)
end

M = {
	register = register
}
end
return M
