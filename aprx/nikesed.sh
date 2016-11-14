sed -e 's/raspberrypi/VK2PSF1/' -i.bak /etc/hosts
sed -e 's/raspberrypi/VK2PSF1/' -i.bak /etc/hostname
sed -e 's/NOCALL-01/VK2PSF-1/' -i.bak /etc/ax25/soundmodem.conf
sed -e 's/NOCALL-01/VK2PSF-1/' -i.bak /etc/ax25/axports
sed -e 's/NOCALL-01/VK2PSF-1/' -e 's/3152.22S/3352.07S/' -e 's/15151.51E/15112.15E/' -e 's/12345/17599/' -i.bak /etc/aprx.conf
