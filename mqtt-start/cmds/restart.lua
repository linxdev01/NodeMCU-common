local M
do

local function restart(m, data)
	local _i = 2;
	local _w = 0;

	if data ~= nil then _i = tonumber(data) end

	if((_i == nil) or (_i < 2)) then _i = 2 end

	i.set_state(-1, "Remote restart (" .. (_i) .. "s)");
	dofile("mqtt/publish.lc").send_msg(m, "Restarting (" .. (_i) .. "s)");
	tmr.stop(6)
	
	tmr.alarm(6, (_i*1000), 0, function()
		node.restart();
	end)
end

M = { 
	restart = restart 
}
end
return M
