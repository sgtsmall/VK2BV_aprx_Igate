#!/bin/sh  
#/etc/ax25/ax25-up.sh
# Start ax25 with the soundmodem driver using the port sm0 
# as defined in /etc/ax25/axports PA0ESH RASPBERRY PI & APRX Page 9 08-12-13 
# Raspberry PI with aprx and soundmodem 
# PA0ESH - updated August 6th 2013 
echo "Starting soundmodem, please wait...." 
soundmodem /etc/ax25/soundmodem.conf -R -M >/dev/null 2>/dev/null& 
sleep 5 
/sbin/route add -net 44.0.0.0 netmask 255.0.0.0 dev sm0 
echo "Soundmodem started at sm0" 
 
# Uncomment the following lines in case of an TNC - check the TNC port by dmesg | grep tty 
# it is assumed that the TNC modem communicates with 9600 baud with the Raspberry PI 
# /usr/sbin/kissattach /dev/ttyUSB0 aprs 44.24.250.250 
# /usr/sbin/kissparms  -p aprs  -t 500  -s 200    -r 32       -l 100  -f n 
# /sbin/route add -net 44.0.0.0 netmask 255.0.0.0 dev aprs 
# echo "ax25 tnc modem started at aprs" 
sleep 3 
# listen for stations heard 
/usr/sbin/mheardd 
sleep 1 
# to start aprx also automatically - uncomment the following line 
#/sbin/aprx -f /etc/aprx.conf restart 
# do not forget to adapt the config file with your own data.

