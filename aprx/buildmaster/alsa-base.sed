s/^# Keep snd-pcsp from beeing loaded as first soundcard/#&/
s/^options snd-pcsp index=-2/#&/
s/^# Keep snd-usb-audio from beeing loaded as first soundcard/#&/
s/^options snd-usb-audio index=-2/#&/
/^# Prevent abnormal drivers from grabbing index 0/a # rewrite to force usb for aprx options snd slots=snd_bcm2835,snd_usb_audio options snd_usb_audio index=0 options snd_bcm2835 index=2
s/# Prevent abnormal drivers from grabbing index 0/#&/
