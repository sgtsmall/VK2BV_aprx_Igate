s/^mycall  N0CALL-1/mycall  NOCALL-01/
s/^#myloc lat ddmm.mmN lon dddmm.mmE/myloc lat 3152.22S lon 15151.51E/
s/^passcode -1/passcode 12345/
/^server    rotate.aprs2.net/a server sydney.aprs2.net
s/^server    rotate.aprs2.net/#&/
s/^#beaconmode { aprsis | both | radio }/beaconmode aprsis/
s/^#cycle-size  20m/cycle-size  20m/
