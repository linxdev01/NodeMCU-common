local M
do
local function process_topic(m, topic, data)
	if m == nil then return end;
	-- do something, we have received a message
	if (string.find(topic, "/po/1") ~= nil) then
		dofile("mqtt/publish.lc").send_msg(m, "/po/1 -> " .. (data));
		dofile("relay.lc").relay(1,data);
	elseif (string.find(topic, "/state") ~= nil) then
	-- ignore this
	elseif (string.find(topic, "/cmd/echo") ~= nil) then
		dofile("mqtt/publish.lc").send_msg(m, data);
	elseif (string.find(topic, "/cmd/restart") ~= nil) then
		dofile("cmds.lc").restart(m, data);
	elseif (string.find(topic, "/cmd/show") ~= nil) then
		dofile("mqtt/publish.lc").send_cfg(m);
	elseif (string.find(topic, "/cmd/setv") ~= nil) then
		dofile("mqtt/publish.lc").set_cfg(m,data);
	elseif (string.find(topic, "/cmd/safe") ~= nil) then
		dofile("cmds.lc").safe(1, 1);
	elseif (string.find(topic, "/cmd/setcustom") ~= nil) then
		dofile("cmds.lc").setcustom(m, data);
	elseif (string.find(topic, "/msg") ~= nil) then
	-- ignore these
	else
	-- i.say("Topic: " .. (topic));
	end
end

M = {
	process_topic = process_topic
}
end
return M
