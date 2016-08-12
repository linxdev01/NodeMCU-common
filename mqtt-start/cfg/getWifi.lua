local M
do

local function getWifi(rec)
	if rec == 0 then rec = 1 end
	local _ap     = getV("wifi/sta/" .. (rec) .. "/ap");
	local _pass   = getV("wifi/sta/" .. (rec) .. "/pass");
	local _enable = getV("wifi/sta/" .. (rec) .. "/enable");
	if _enable == nil or _enable == 0 then return nil,nil end	
	return _ap, _pass
end

M = { getWifi = getWifi }
end
return M
