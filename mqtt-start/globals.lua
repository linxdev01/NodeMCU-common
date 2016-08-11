local M
do

local tab = {} ;

local function getV(name)
	return tab[name];
end

local function setV(name, value)
	tab[name] = value;
	return value;
end


M = { 
	getV = getV,
	setV = setV
};
end
return M;
