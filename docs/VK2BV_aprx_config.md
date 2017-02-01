VK2BV APRS iGate - User Configuration

RaspberryPi using USB sound card

 

# latest image 20151115

The master image is updated from time to time to include major changes and security patches. …This is a 7z file uncompress and load to relevant sd card.

The uncompressed image is 1GB with the standard 2 partition structure for raspbian. This image has been built after reviewing several of the current raspberry pi images. It is maintained at 1gb with approximately 90MB free space for logs, this should be more than sufficient as it uses logrotate to minimise old logs.

After installing the image on an SD you should first connect ethernet and your sound card. The unit can then be powered up and may appear on a network as **aprxigate **otherwise search for the appropriate IP.

ssh   with  usual  pi and raspberry

The initial boot process confirms location and timezone.

If you are using the unit in NSW then you could just cancel each of these setups. The unit will default to:

Locale en_AU.UTF and timezone for Sydney, NSW Australia.

Detailed Set up for locale and timezone.

after login it is just reading the .profile to run some scripts, first pass runs the ``` configaprx``` , then recommends reboot second pass runs the ```testaprx``` (which is the step to listen to the radio, adjust sound card and then commit the startup).

The config script...```configaprx```

> Valid Callsign [e.g. VK2ABC]  
> Terminal number [e.g. 1]  
> Passcode is unique for your Callsign  
> Passcode for [$user] calculated as [$passcode]  
> APRSIS Passcode number [$passcode]  
> lat and long for your igate location  
> Format is degMM.MMS  use the [aprs.is](http://aprs.is/) google map to get the value  
> lat value [e.g. 3351.12S]  
> lon value [e.g. 15151.12E]  


it shows the values then

> If the values are correct enter "Y"  

it is looking for   Y  otherwise it will just loop defaulting to the values you last typed for correction.


Basically the bit I need to expand on... is the steps in ```testaprx```

> a) start soundmodem/ax25 (no aprx)  

this starts the soundmodem process to listen to the radio without running the aprx program which decodes and sends to the aprs network servers, use this option to see if you are receiving packet data from the radio.

> b) stop soundmodem/ax25 (no aprx)  

this stops the soundmodem process listening to the radio.

> c) start alsamixer  

alsamixer is used to adjust the sound levels.... in particular we need to switch to the input group and adjust the MIC to about 50%

> d) tail syslog  

tailing a file shows the last few lines, in this case the syslog to look for errors or startup

> e) axlisten (for signal or test track)  

axlisten will "decode" whatever soundmodem gives it, when I was testing I actually kept a looped wav file from the net that I played direct from notebook to soundcard.

> f) mheard  

mheard will display a log of all decoded packets it has received (they don't appear where you would expect!! ie aprx.log or aprx-rf.log)

> g) tail aprx.log  

> h) tail aprx-rf.log  

These are useful after you have committed to see messages to from aprx servers

> i) Commit soundmodem/ax25/aprx to startup   

This commits the autostartup, after you have everything tested this sets the values for atomatic restart after boot.

> X) Clear All values and start again  

literally.... it will try and reset the scripts, setups , hostnames ... everything but the passwd

so that you can start from the first menu cleanly.

> q) quit this menu  

for a new build I use 

 c) alsamixer to adjust the MIC in to 50%

 a) start soundmodem noaprx

 e) start axlisten

  then try to generate and/or listen on radio or listen to a wav file.

then 

i) Commit soundmodem....

and reboot.

I only use the other options if somethings not working.

If you want to use with wifi plug in your usb wifi, and then at the command line you can use wicd_curses     which will run you through an old curses based setup for wifi.

