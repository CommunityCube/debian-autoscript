This script it's intented to transform a Debian Wheezy base installation to a CommunityCube System.

First it's needed to execute system script, and then services script.

Then your computers and devices should be connected to DHCP network served in eth1/wlan1, and avoid direct contact to internet. This way your devices and your digital life will be protected.

                                        -------------------------
 internal network    -----------  eth1  | CommunityCube System  |  eth0  -----------  The internet
     10.0.0.x        ----------- wlan1  |        10.0.0.1       |  wlan0 -----------
                                        -------------------------
                                        
                                        
If you want to read more:  www.cageos.org