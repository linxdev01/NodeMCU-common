-- file : safe.lua


app = nil
setup = nil
cfg = nil
led = nil
setup = nil
led = nil
_stop = 0

function main()
	setup = require("setup")
	cfg = dofile("cfg.lc");
	cfg.load();


	dofile("telnet.lc").start();

	i = require("indicator");
	i.start();
	i.set_state(-1, nil);

	setup.start()  
end

print ("Will start in 10(s)");

tmr.alarm(0,10000,0,main)


