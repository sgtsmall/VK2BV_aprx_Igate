VK2BV APRS iGate - Build Image

RaspberryPi using USB sound card

 

# Rebuild a Master Image 20151115

From time to time you may need to completely rebuild the image. These instructions and some scripts represent a minimal set of installs and script changes that were needed to build the image. Most of this came about as I was searching and trying several different base images, trying to find a balance of function for size. I ended up automating several of these steps and these notes are the result. Your mileage may vary!!!

Source for minimal headless raspbian image:

http://www.linuxsystems.it/raspbian-wheezy-armhf-raspberry-pi-minimal-image/

login is: root/raspberry

boots to sh (ssh available)

basic config stuff:

<table>
  <tr>
    <td>dpkg-reconfigure locales </td>
  </tr>
</table>


 (EN.AU-UTF) remove EN.GB* if exist

<table>
  <tr>
    <td>dpkg-reconfigure tzdata</td>
  </tr>
</table>


    AU/Syd

<table>
  <tr>
    <td>apt-get update<br>
    apt-get -y upgrade<br>
    apt-get -y install raspi-copies-and-fills<br>
    apt-get -y install soundmodem ax25-tools ax25-apps libax25-dev alsa-base usbutils build-essential sudo subversion psmisc
</td>
  </tr>
</table>


add the pi user

<table>
  <tr>
    <td>adduser --disabled-password --gecos "" pi passwd pi << EOF<br>
raspberry<br>
raspberry<br>
EOF</td>
  </tr>
</table>
<table>
  <tr>
    <td>visudo</td>
  </tr>
</table>


add to end of file 

pi ALL=(ALL) NOPASSWD: ALL

reboot and login as pi 

# Scripts and setup - vk2bv-aprx-pi.tar.gz

load up the current config and files (this will change the .profile to the configuration script so from now on ^C after login) this contains a number of setup files that are used for the rest of the process.

Copy the current vk2bv-aprx-pi.tar.gz from the current image, if you just mount an image to a windows or OSX the boot partition should be visible and you can get the file from there.

<table>
  <tr>
    <td>tar -zxf /boot/vk2bv-aprx-pi.tar.gz<br>
cd aprx<br>
cd buildmaster<br></td>
  </tr>
</table>
 

## aprx folder - description of contents

*     buildmaster - folder 

* configaprx - configure aprx - runs from .profile or aprx/configaprx 
*  keygen.py - generates APRSIS passcode - runs from configaprx
*  nikesed.sh - script that edits config files - runs from configaprx

* testaprx - scripts to test aprx settings runs from .profile or aprx/testaprx
*  autostartaprx - insserv script - run from testaprx
*  clearaprx - clean up and reset config - run from testaprx


## buildmaster folder


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

<table>
  <tr>
    <td>svn co http://repo.ham.fi/svn/aprx src<br>
cd src/trunk<br>
./configure && make clean all<br>
sudo make install</td>
  </tr>
</table>


installs to /sbin

return to the buildmaster directory (../..)

run the script checkorig.sh

### checkorig.sh

<table>
  <tr>
    <td>#!/bin/sh<br>
for f in `ls -1 origfiles`<br>
do<br>
 RFILE=`echo $f| tr '_' '/' `<br>
 echo $RFILE<br>
 diff $RFILE origfiles/$f<br>
done</td>
  </tr>
</table>


This script simply tries to compare several files from the origfiles directory with currently installed entries. If they are different then the nikebuild.sh script which is trying to sed them may or may not work. I wrote this following a slight upgrade to one of the products during the process.

### nikebuild.sh

<table>
  <tr>
    <td>#!/bin/sh<br>
echo debug cp files for clean build<br>
TAB=`echo x | tr 'x' '\011'`<br>
<br>
for f in `ls -1 origfiles`<br>
do<br>
 RFILE=`echo $f| tr '_' '/' `<br>
 echo $RFILE<br>
 cp origfiles/$f $RFILE<br>
done<br>
for f in `ls -1 addfiles`<br>
do<br>
 RFILE=`echo $f| tr '_' '/' `<br>
 echo $RFILE<br>
 cp addfiles/$f $RFILE<br>
done<br>
#<br>
mkdir /var/log/aprx<br>
chown root:root /etc/init.d/aprs /etc/ax25/ax25-up.sh /etc/ax25/ax25-down.sh<br>
chmod 755 /etc/init.d/aprs /etc/ax25/ax25-up.sh /etc/ax25/ax25-down.sh<br>
#<br>
sed -f alsa-base.sed -i.bak /etc/modprobe.d/alsa-base.conf<br>
#sed -f modules.sed -i.bak /etc/modules<br>
sed -f aprx.sed -i.bak /etc/aprx.conf<br>
sed -e "s/Z/$TAB/g" -i.bak /etc/asound.conf<br>
sed -e "s/Z/$TAB/g" -i.bak /etc/ax25/axports</td>
  </tr>
</table>


nikebuild.sh will fix up most of the installation scripts and boot files so that the configuration scripts will work (they also work by doing sed replacements)

<table>
  <tr>
    <td>chmod 7555 /etc/ax25/soundmodem.conf</td>
  </tr>
</table>

It was too much work to fix a couple of the records at the moment so after it runs you have to manually edit /etc/aprx.conf  (filter, interface and beacon) 

<table>
  <tr>
    <td>….
#<br>
filter "m/20"	     # My-Range filter: positions within 100 km from my location<br>
#filter "f/OH2XYZ-3/50"  # Friend-Range filter: 50 km of friend's last beacon position<br>
….<br>
`<interface>`<br>
   ax25-device   $mycall<br>
#   #tx-ok        false  # transmitter enable defaults to false<br>
#   #telem-to-is  true # set to 'false' to disable<br>
`</interface>`<br>
….<br>
#<br>
#beacon symbol "R&" lat "0000.00N" lon "00000.00E" comment "Rx-only iGate"<br>
beacon symbol "R&" $myloc comment "Rx-only iGate"<br>
#</td>
  </tr>
</table>


### checkuser.sh

<table>
  <tr>
    <td>#!/bin/sh<br>
for f in `ls -1 userfiles`<br>
do<br>
 RFILE=`echo $f| tr '_' '/' `<br>
 echo $RFILE<br>
 diff $RFILE userfiles/$f<br>
done</td>
  </tr>
</table>


when you are finished you should run checkuser.sh these are the files that will be used to clear all settings (‘X’ in the testaprx menu) if there are any discrepencies you need to fix them 

(edit or copy as required)

finally I have been installing wicd-curses for wifi, I will change this if I can find a more reliable command line method.

<table>
  <tr>
    <td>sudo apt-get install wicd-curses</td>
  </tr>
</table>

