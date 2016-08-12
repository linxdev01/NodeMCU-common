local M
do

local function safe(v,r)
	if v ~= nil and v == 1 then
		cfg.setVs("safe", 1);
	else
		cfg.setVs("safe", 0);
	end

	if r ~= nil and r == 1 then node.restart() end
end

M = { safe = safe }
end
return M
