local M
do

local function setcustom(m, data)
	local t = { }
	if not pcall(function() t = cjson.decode(data) end) then return end;
	i.say("Received content for custom.");
end

M = { setcustom = setcustom }
end
return M
