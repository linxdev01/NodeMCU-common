local M
do

-- Concat the contents of the parameter list,
-- separated by the string delimiter (just like in perl)
-- example: strjoin(", ", {"Anna", "Bob", "Charlie", "Dolores"})
local function strjoin(delimiter, list)
  local len = #list
  if len == 0 then 
    return "" 
  end
  local string = list[1]
  for i = 2, len do 
    string = string .. delimiter .. list[i] 
  end
  return string
end

-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
local function strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if string.find("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then -- found?
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end

-- 08a4bef8-07c6-4697-8c7f-bab023538295

local function newStack ()
	return {""}   -- starts with an empty string
end

local function addString (stack, s)
	table.insert(stack, s)    -- push 's' into the the stack
	for i=#stack-1, 1, -1 do
		if string.len(stack[i]) > string.len(stack[i+1]) then
			break
		end
		stack[i] = stack[i] .. table.remove(stack)
	end
end

local function get_rhex() 
	return string.format("%02x", math.random(255));
end

local function gen_uuid() 
	local s = newStack();
	math.randomseed(tmr.now());
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, get_rhex());
	addString(s, get_rhex());
	addString(s, "-");
	addString(s, table.concat( strsplit(":", wifi.sta.getmac()), ""));
	return table.concat(s, "");
end



M = {
	strjoin = strjoin,
	strsplit = strsplit,
	gen_uuid = gen_uuid
}
end
return M
