
local _safe = 0;

if not  pcall(function() 
		_safe = dofile("cfg.lc").getV("safe");
		if _safe == nil then _safe = 0 end
	end) then 
	-- we need to do this if we've failed
	_safe = 1;
end

if _safe == 1 then 
	print("Safe mode");
	dofile("safe.lc");
else
	dofile("main.lc");
end
