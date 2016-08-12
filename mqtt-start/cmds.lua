local M
do

local function restart(m, data)
	dofile("cmds/restart.lc").restart(m,data);
end

local function safe(v, r)
	dofile("cmds/safe.lc").safe(v,r);
end

local function setcustom(v, r)
	dofile("cmds/setcustom.lc").setcustom(v,r);
end

M = { 
	restart = restart,
	setcustom = setcustom,
	safe = safe	
}
end
return M
