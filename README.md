This script it's intented to transform a Debian Wheezy base installation to a CommunityCube System.


Then your computers and devices should be connected to DHCP network served in eth1/wlan1, and avoid direct contact to internet. This way your devices and your digital life will be protected.



internal net (eth1/wlan1) - CageOS - internet (eth0/wlan09


 
Execution order it's:
1- autoscript-system
It prepares whole system, APT repos, network, hostapd (for wlan1), DHCP server for br1, TOR as dns resolver, macchanger on each reboot, ntpdate 

2- autoscript-services
It prepares running services: yacy, friendica, owncloud, tahoe, i2p, tor hidden services, nginx access

3- autoscript-network
It prepares CommunityCube as a proxy to browse transparently darknets, filter content (squid), route petitions (iptables), dns resolution (unbound), proxifier (privoxy), blocking advertisment (iptables), redirection known domains to local domains (ex: google.com -> internal yacy)


If you want to read more:  www.cageos.org
