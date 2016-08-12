local M
do

local function _listap(t)
	print ("Listing APs");
	for ssid,v in pairs(t) do
		authmode, rssi, bssid, channel =
			string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
			print(ssid,authmode,rssi,bssid,channel)
	end
end

local function listap()
	wifi.sta.getap(_listap)
end

M = { listap = listap }
end
return M
