#!/bin/sh
echo debug cp files for clean build
TAB=`echo x | tr 'x' '\011'`

for f in `ls -1 origfiles`
do
 RFILE=`echo $f| tr '_' '/' `
 echo $RFILE
 cp origfiles/$f $RFILE
done
for f in `ls -1 addfiles`
do
 RFILE=`echo $f| tr '_' '/' `
 echo $RFILE
 cp addfiles/$f $RFILE
done
#
mkdir /var/log/aprx
chown root:root /etc/init.d/aprs /etc/ax25/ax25-up.sh /etc/ax25/ax25-down.sh
chmod 755 /etc/init.d/aprs /etc/ax25/ax25-up.sh /etc/ax25/ax25-down.sh
#
sed -f alsa-base.sed -i.bak /etc/modprobe.d/alsa-base.conf
#sed -f modules.sed -i.bak /etc/modules
sed -f aprx.sed -i.bak /etc/aprx.conf
sed -e "s/Z/$TAB/g" -i.bak /etc/asound.conf
sed -e "s/Z/$TAB/g" -i.bak /etc/ax25/axports
