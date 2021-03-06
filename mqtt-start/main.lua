-- file : init.lua


app = nil
setup = nil
cfg = nil
led = nil
setup = nil
led = nil
_stop = 0


function main()
	cfg = dofile("cfg.lc");
	cfg.load();

	-- Set this up now!
	dofile("relay.lc").restore(1);

	dofile("telnet.lc").start();

	i = require("indicator");
	i.start();

	i.set_state(-1, nil);

	dofile("setup.lc").start(function()
		app = require("application")  
		app.start()
	end)
end

print ("Will start in 2(s)");

tmr.alarm(0,2000,0,main)


