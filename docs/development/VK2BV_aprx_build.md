VK2BV APRS iGate - Build Image

RaspberryPi using USB sound card

 

# Rebuild a Master Image 20151115

From time to time you may need to completely rebuild the image. These instructions and some scripts represent a minimal set of installs and script changes that were needed to build the image. Most of this came about as I was searching and trying several different base images, trying to find a balance of function for size. I ended up automating several of these steps and these notes are the result. Your mileage may vary!!!

Source for minimal headless raspbian image:

http://www.linuxsystems.it/raspbian-wheezy-armhf-raspberry-pi-minimal-image/

login is: root/raspberry

boots to sh (ssh available)

basic config stuff:

```dpkg-reconfigure locales```


 (EN.AU-UTF) remove EN.GB* if exist

```dpkg-reconfigure tzdata```


    AU/Syd

```
apt-get update  
apt-get -y upgrade  
apt-get -y install raspi-copies-and-fills  
apt-get -y install soundmodem ax25-tools ax25-apps libax25-dev alsa-base usbutils build-essential sudo subversion psmisc
```


add the pi user


```
adduser --disabled-password --gecos "" pi passwd pi << EOF
raspberry
raspberry
EOF
```

```
visudo
```


add to end of file 

pi ALL=(ALL) NOPASSWD: ALL

reboot and login as pi 

## Scripts and setup - vk2bv-aprx-pi.tar.gz

load up the current config and files (this will change the .profile to the configuration script so from now on ^C after login) this contains a number of setup files that are used for the rest of the process.

Copy the current vk2bv-aprx-pi.tar.gz from the current image, if you just mount an image to a windows or OSX the boot partition should be visible and you can get the file from there.

```
tar -zxf /boot/vk2bv-aprx-pi.tar.gz  
cd aprx  
cd buildmaster
```


### aprx folder - description of contents

*     buildmaster - folder 

* configaprx - configure aprx - runs from .profile or aprx/configaprx 
*  keygen.py - generates APRSIS passcode - runs from configaprx
*  nikesed.sh - script that edits config files - runs from configaprx

* testaprx - scripts to test aprx settings runs from .profile or aprx/testaprx
*  autostartaprx - insserv script - run from testaprx
*  clearaprx - clean up and reset config - run from testaprx


### buildmaster folder


* alsa-base.sed  (sed scripts for editing config files)
* aprx.sed

* checkorig.sh  (check scripts just diff between files in the relevant directory and the path)
* checkuser.sh  (e.g. /etc/hosts and _etc_hosts)

* cronfile  (not used at the moment was for web page)

* nikebuild.sh  (script to edit config files)

* ./src: (directory for aprx build etc.)

* ./addfiles: (files added to system by nikebuild.sh)
* _etc_asound.conf _etc_ax25_ax25-down.sh _etc_ax25_ax25-up.sh _etc_ax25_axports _etc_ax25_soundmodem.conf _etc_hostname _etc_hosts _etc_init.d_aprs _etc_logrotate.d_aprx _etc_modules

* ./debugfiles: (workfiles for a problem where /etc/modules changed)
* _etc_modules modules.sed

* ./origfiles: (original files after clean install before customisation)
* _etc_aprx.conf _etc_ax25_axports _etc_ax25_soundmodem.conf _etc_modprobe.d_alsa-base.conf _etc_modules

* ./userfiles: (option 'X' overwrites current files to return settings to default)
* _etc_aprx.conf _etc_ax25_axports _etc_ax25_soundmodem.conf _etc_hostname _etc_hosts


This next step will download the most recent edition of aprx (doesn’t change often)

```
svn co http://repo.ham.fi/svn/aprx src
cd src/trunk
./configure && make clean all
sudo make install
```

installs to /sbin

return to the buildmaster directory (../..)

run the script checkorig.sh

#### checkorig.sh

```
#!/bin/sh
for f in `ls -1 origfiles`
do
 RFILE=`echo $f| tr '_' '/' `
 echo $RFILE
 diff $RFILE origfiles/$f
done
```

This script simply tries to compare several files from the origfiles directory with currently installed entries. If they are different then the nikebuild.sh script which is trying to sed them may or may not work. I wrote this following a slight upgrade to one of the products during the process.

#### nikebuild.sh

```
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
```

nikebuild.sh will fix up most of the installation scripts and boot files so that the configuration scripts will work (they also work by doing sed replacements)

```
chmod 7555 /etc/ax25/soundmodem.conf
```

It was too much work to fix a couple of the records at the moment so after it runs you have to manually edit /etc/aprx.conf  (filter, interface and beacon) 

> ….  
>\#  
>filter "m/20"	     # My-Range filter: positions within 100 km from my location  
>\#filter "f/OH2XYZ-3/50"  # Friend-Range filter: 50 km of friend's last beacon position  
>….  
>`<interface>`  
>   ax25-device   $mycall  
>\#   #tx-ok        false  # transmitter enable defaults to false  
>\#   #telem-to-is  true # set to 'false' to disable  
>`</interface>`  
>….  
>\#  
>\#beacon symbol "R&" lat "0000.00N" lon "00000.00E" comment "Rx-only iGate"  
>beacon symbol "R&" $myloc comment "Rx-only iGate"  
>\#  

### checkuser.sh

```
#!/bin/sh  
for f in `ls -1 userfiles`  
do
 RFILE=`echo $f| tr '_' '/' `
 echo $RFILE
 diff $RFILE userfiles/$f
done  
```

when you are finished you should run checkuser.sh these are the files that will be used to clear all settings (‘X’ in the testaprx menu) if there are any discrepencies you need to fix them 

(edit or copy as required)

finally I have been installing wicd-curses for wifi, I will change this if I can find a more reliable command line method.

```
sudo apt-get install wicd-curses
```

