# NodeMCU-common

mqtt-start:  Basic load for all projects

I found myself writing the same code over and over.  I'm lazy
and prefer to create an API once and reuse over and over.

The idea in mqtt-start is to create a basic Lua load for the
NodeMCU dev kit units I deploy.  All units can receive this 
code.  Using config I can then configure AP, relay, RGB LED, etc.

Some notes:

1. indicator.Lua and led.lua  

I like using a single RGB LED for visual status.  Indicator 
implements something like a state engine idea where the device is
in either start, normal/clear, warn, or error mode.  Other
programs can change state with i.set_state(state, message).
I consolidated the message argument in the function to keep from
doing a print in the caller.  Heap is crucial.  Without a RGB
LED enabled this really does nothing.  

2. setup.lua

The code in mqtt-start was started with an example I found
and I liked the structure.  I wanted to support the idea of
multiple wifi profiles in config.  If I travel and take a device 
it could use my phone hotspot or my Tripmate Nano WISP device.

3. application.lua, cmds.lua, and mcfg.lua

This is where the MQTT stuff is.  cmds.lua and mcfg.lua is
only there to conserve memory by calling them only when I need them.
I want to consolidate all sub processing in cmds.lua.  

What maybe odd is the double publish and double sub based on
config 'name'.  Doing my development remembering the chip ids I
have running was not possible. I added the ability of using the 
name as another method of addressing the units.  Just consider I learned 
MQTT only about 3 weeks ago. :)

4. init.lua vs test.lua and safe.lua.  

init is the one for production.  Upload and compile of programs
over telnet can fail due to memory.  The other two can get the
unit up with ip and telnet and allow files to be uploaded.

Originally I called it 'test', but over time it seemed more like
a 'safe' mode.  I'm still toying with automated OTA.  Maybe MQTT
message to go to safe mode?   So far file.rename("safe.lua", "init.lua")
fails.


Summary:

I started with the NodeMCU 3 months ago.  I have 0 experience with
Lua.  I picked up what I knew about Lua from reading the syntax, web
pages, and just experimenting.  There are plenty of examples of ignorance
in both technologies in this code.  I[m putting it out here for correction.
Please use, modify, etc.


I'm also not even sure if what I am trying to do is a good idea
on the NodeMCU.  Again, correction would be appreciated.


Credits:

I found the source I used to start

http://www.foobarflies.io/a-simple-connected-object-with-nodemcu-and-mqtt/


