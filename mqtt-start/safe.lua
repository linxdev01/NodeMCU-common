-- file : safe.lua


app = nil
setup = nil
cfg = nil
led = nil
setup = nil
led = nil
_stop = 0

p_start = tmr.time();

function main()

	wifi.setmode(wifi.STATION);
	wifi.sta.config("K4FH/UNIFI", nil);
	wifi.sta.connect()
	dofile("telnet.lc").start();

    dofile("led.lc").color("purple");
	print("Started.");

end

print ("Will start in 10(s)");

tmr.alarm(0,10000,0,main)


