#!/bin/sh 
#/etc/ax25/ax25-down.sh
# Stop ax25 with the soundmodem driver using the port sm0 
# as defined in /etc/ax25/axports 
# Raspberry PI with aprx and soundmodem 
# PA0ESH - August 6th 2013 
killall soundmodem && echo "Soundmodem closed"  
#killall kissattach && echo "ax0-9 (kissattach) closed"  
# to stop aprx also automatically - uncomment the following line 
# /sbin/aprx stop && echo "aprx stopped" 
