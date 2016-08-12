local M
do

local _init = 0;

local function _relay(root,cmd) 
	local path = "po/" .. (root) .. "/";

	local pin = cfg.getV((path) .. "pin");
	if pin == nil then return end

	local enable = cfg.getV((path) .. "enable");
	if enable == 0 then return end

	local state = cfg.getV((path) .. "state");


	if _init == 0 then
		_init = 1
		if(enable == 1) then
			gpio.mode(pin, gpio.OUTPUT);
			gpio.write(pin, state);
		end
	end
		
	print ("CMD " .. (cmd));

	if cmd == "RESTORE" then
		gpio.write(pin, state);
	elseif cmd == "ON" then
		gpio.write(pin, 1);
		state = 1;
	elseif cmd == "OFF" then
		gpio.write(pin, 0);
		state = 0;
	elseif cmd == "FLIP" then	
		if(state == 1) then
			gpio.write(pin, 0);
			state = 0;
		else
			gpio.write(pin, 1);
			state = 1;
		end
	end

	cfg.setVs((path) .. "state", state);

end

local function relay(root, cmd)
	local status, err = pcall(function ()
		_relay(root, cmd);
	end)
end

local function restore(root)
	if root == nil then root = 1 end
	relay(root,"RESTORE");
end

M = {
	restore = restore,
	relay = relay
}
end
return M
