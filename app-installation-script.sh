#!/bin/bash
# ---------------------------------------------------------
# This script aims to configure all the packages and 
# services which have been installed by test.sh script.
# This script is functionally seperated into 3 parts
# 	1. Configuration of Network Interfaces 
# 	2. Configuration of Revers Proxy Services 
# 	3. Configuration of Applications
# ---------------------------------------------------------


# Global variables list
EXT_INETRFACE="N/A"		# External interface variable
INT_INTERfACE="N/A"		# Internal interface variable


# ---------------------------------------------------------
# This function checks user. 
# Script must be executed by root user, otherwise it will
# output an error and terminate further execution.
# ---------------------------------------------------------
check_root ()
{
	echo -ne "Checking user root ... "
	if [ "$(whoami)" != "root" ]; then
		echo "Fail"
		echo "You need to be root to proceed. Exiting"
		exit 1
	else
		echo "OK"
	fi
}


# ---------------------------------------------------------
# Function to get varibales from /tmp/variables.log file
# Variables to be initialized are:
#   PLATFORM
#   HARDWARE
#   PROCESSOR
#   EXT_INTERFACE
#   INT_INTERFACE
# ----------------------------------------------------------
get_variables()
{
	echo "Initializing variables ..."
	if [ -e /tmp/variables.log ]; then
		PLATFORM=`cat /tmp/variables.log | grep "Platform" | awk {'print $2'}`
		HARDWARE=`cat /tmp/variables.log | grep "Hardware" | awk {'print $2'}`
		PROCESSOR=`cat /tmp/variables.log | grep "Processor" | awk {'print $2'}`
		EXT_INTERFACE=`cat /tmp/variables.log | grep "Ext_int" | awk {'print $2'}`
		INT_INTERFACE=`cat /tmp/variables.log | grep "Int_int" | awk {'print $2'}`
		if [ -z "$PLATFORM" -o -z "$HARDWARE" -o -z "$PROCESSOR" \
		     -o -z "$EXT_INTERFACE" -o -z "$INT_INTERFACE" ]; then
			echo "Error: Can not detect variables. Exiting"
			exit 5
		else
			echo "Platform:      $PLATFORM"
			echo "Hardware:      $HARDWARE"
			echo "Processor:     $PROCESSOR"
			echo "Ext Interface: $EXT_INTERFACE"
			echo "Int Interface: $INT_INTERFACE"
		fi 
	fi
}


# ---------------------------------------------------------
# This function checks network interfaces.
# The interface connected to network will be saved on 
# EXT_INTERFACE variaable and other awailable interface
# will be saved on INT_INTERFACE variable.
# ---------------------------------------------------------
get_interfaces()
{
	echo "Checking network interfaces ..."
	# Getting external interface name
	EXT_INTERFACE=`route -n | awk {'print $1 " " $8'} \
			| grep "0.0.0.0" | awk {'print $2'}`
	echo "External interface: $EXT_INTERFACE"
	
	# Getting internal interface name
	INT_INTERFACE=`ls /sys/class/net/ | grep -w 'eth0\|eth1\|wlan0\|wlan1' | grep -v $EXT_INTERFACE | sed -n '1p'`
	echo "Internal interface: $INT_INTERFACE"
}


# ---------------------------------------------------------
# This functions configures hostname and static lookup
# table 
# ---------------------------------------------------------
configure_hosts()
{
echo "communitycube" > /etc/hostname

cat << EOF > /etc/hosts
#
# /etc/hosts: static lookup table for host names
#

#<ip-address>   <hostname.domain.org>   <hostname>
127.0.0.1       communitycube.localdomain localhost.localdomain communitycube localhost
::1             communitycube.localdomain localhost.localdomain communitycube localhost ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
EOF
}


# ---------------------------------------------------------
# This function configures internal and external interfaces
# ---------------------------------------------------------
configure_interfaces()
{
	# Network interfaces configuration for 
	# Physical/Virtual machine
if [ "$PROCESSOR" = "Intel" -o "$PROCESSOR" = "AMD" ]; then
	cat << EOF >  /etc/network/interfaces 
	# interfaces(5) file used by ifup(8) and ifdown(8)
	auto lo
	iface lo inet loopback

	#External network interface
	auto $EXT_INTERFACE
	allow-hotplug $EXT_INTERFACE
	iface $EXT_INTERFACE inet dhcp

	#Internal network interface
	auto $INT_INTERFACE
	allow-hotplug $INT_INTERFACE
	iface $INT_INTERFACE inet static
	    address 10.0.0.1
	    netmask 255.255.255.0
            network 10.0.0.0
    
	#Yacy
	auto $INT_INTERFACE:1
	allow-hotplug $INT_INTERFACE:1
	iface $INT_INTERFACE:1 inet static
	    address 10.0.0.251
            netmask 255.255.255.0

	#Friendica
	auto $INT_INTERFACE:2
	allow-hotplug $INT_INTERFACE:2
	iface $INT_INTERFACE:2 inet static
	    address 10.0.0.252
	    netmask 255.255.255.0
    
	#OwnCloud
	auto $INT_INTERFACE:3
	allow-hotplug $INT_INTERFACE:3
	iface $INT_INTERFACE:3 inet static
	    address 10.0.0.253
	    netmask 255.255.255.0
    
	#Mailpile
	auto $INT_INTERFACE:4
	allow-hotplug $INT_INTERFACE:4
	iface $INT_INTERFACE:4 inet static
	    address 10.0.0.254
	    netmask 255.255.255.0
EOF
	# Network interfaces configuration for board
	elif [ "$PROCESSOR" = "ARM" ]; then
	cat << EOF >  /etc/network/interfaces 
	# interfaces(5) file used by ifup(8) and ifdown(8)
	auto lo
	iface lo inet loopback

	#External network interface
	auto eth0
	allow-hotplug eth0
	iface eth0 inet dhcp

	#External network interface
	# wireless wlan0
	auto wlan0
	allow-hotplug wlan0
	iface wlan0 inet dhcp

	##External Network Bridge 
	#auto br0
	allow-hotplug br0
	iface br0 inet dhcp   
	    bridge_ports eth0 wlan0

	#Internal network interface
	auto eth1
	allow-hotplug eth1
	iface eth1 inet manual

	#Internal network interface
	# wireless wlan1
	auto wlan1
	allow-hotplug wlan1
	iface wlan1 inet manual

	#Internal network Bridge
	auto br1
	allow-hotplug br1
	# Setup bridge
	iface br1 inet static
	    bridge_ports eth1 wlan1
	    address 10.0.0.1
	    netmask 255.255.255.0
	    network 10.0.0.0
    
	#Yacy
	auto eth1:1
	allow-hotplug eth1:1
	iface eth1:1 inet static
	    address 10.0.0.251
	    netmask 255.255.255.0

	#Friendica
	auto eth1:2
	allow-hotplug eth1:2
	iface eth1:2 inet static
	    address 10.0.0.252
	    netmask 255.255.255.0
    
	#OwnCloud
	auto eth1:3
	allow-hotplug eth1:3
	iface eth1:3 inet static
	    address 10.0.0.253
	    netmask 255.255.255.0
    
	#Mailpile
	auto eth1:4
	allow-hotplug eth1:4
	iface eth1:4 inet static
	    address 10.0.0.254
	    netmask 255.255.255.0
EOF

fi
}


# ---------------------------------------------------------
# Function to configure iptables
# ---------------------------------------------------------
configre_blacklists()
{
mkdir -p /etc/blacklists
cd /etc/blacklists

cat << EOF > /etc/blacklists/update-blacklists.sh
#!/bin/bash

#squidguard DB
mkdir -p /etc/blacklists/shallalist/tmp 
cd /etc/blacklists/shallalist/tmp
wget http://www.shallalist.de/Downloads/shallalist.tar.gz
tar xvzf shallalist.tar.gz ; res=\$?
rm -f shallalist.tar.gz
if [ "\$res" = 0 ]; then
 rm -fr /etc/blacklists/shallalist/ok
 mv /etc/blacklists/shallalist/tmp /etc/blacklists/shallalist/ok
else
 rm -fr /etc/blacklists/shallalist/tmp 
fi

mkdir -p /etc/blacklists/urlblacklist/tmp
cd /etc/blacklists/urlblacklist/tmp
wget http://urlblacklist.com/cgi-bin/commercialdownload.pl?type=download\\&file=bigblacklist -O urlblacklist.tar.gz
tar xvzf urlblacklist.tar.gz ; res=\$?
rm -f urlblacklist.tar.gz
if [ "\$res" = 0 ]; then
 rm -fr /etc/blacklists/urlblacklist/ok
 mv /etc/blacklists/urlblacklist/tmp /etc/blacklists/urlblacklist/ok
else
 rm -fr /etc/blacklists/urlblacklist/tmp 
fi

mkdir -p /etc/blacklists/mesdk12/tmp
cd /etc/blacklists/mesdk12/tmp
wget http://squidguard.mesd.k12.or.us/blacklists.tgz
tar xvzf blacklists.tgz ; res=\$?
rm -f blacklists.tgz
if [ "\$res" = 0 ]; then
 rm -fr /etc/blacklists/mesdk12/ok
 mv /etc/blacklists/mesdk12/tmp /etc/blacklists/mesdk12/ok
else
 rm -fr /etc/blacklists/mesdk12/tmp 
fi

mkdir -p /etc/blacklists/capitole/tmp
cd /etc/blacklists/capitole/tmp
wget ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/publicite.tar.gz
tar xvzf publicite.tar.gz ; res=\$?
rm -f publicite.tar.gz
if [ "\$res" = 0 ]; then
 rm -fr /etc/blacklists/capitole/ok
 mv /etc/blacklists/capitole/tmp /etc/blacklists/capitole/ok
else
 rm -fr /etc/blacklists/capitole/tmp 
fi


# chown proxy:proxy -R /etc/blacklists/*

EOF

chmod +x /etc/blacklists/update-blacklists.sh
/etc/blacklists/update-blacklists.sh

cat << EOF > /etc/blacklists/blacklists-iptables.sh
#ipset implementation for nat
for i in \$(grep -iv [A-Z] /etc/blacklists/shallalist/ok/BL/adv/domains)
do
  iptables -t nat -I PREROUTING -i br1 -s 10.0.0.0/16 -p tcp -d \$i -j DNAT --to-destination 5.5.5.5
done
EOF

chmod +x /etc/blacklists/blacklists-iptables.sh
}


# ---------------------------------------------------------
# Function to configure iptables
# ---------------------------------------------------------
configure_iptables()
{
cat << EOF > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.


iptables -F
iptables -F -t nat

#Allow ssh from internal to Communitycube and allow SSH to external servers
iptables -t nat -A PREROUTING -i br1 -p tcp -d 10.0.0.1 --dport 22 -j ACCEPT

#Allow internal access to
iptables -t nat -A PREROUTING -i br1 -p tcp -d 10.0.0.1 --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -i br1 -p tcp -d 10.0.0.1 --dport 443 -j ACCEPT
iptables -t nat -A PREROUTING -i br1 -p tcp -d 10.0.0.1 --dport 7000 -j ACCEPT

#Redirect to Local Nginx server 
iptables -t nat -I PREROUTING -i br1 -d 10.0.0.251 -p tcp -j DNAT --to 10.0.0.1:80  
iptables -t nat -I PREROUTING -i br1 -d 10.0.0.252 -p tcp -j DNAT --to 10.0.0.1:80 
iptables -t nat -I PREROUTING -i br1 -d 10.0.0.253 -p tcp -j DNAT --to 10.0.0.1:80 
iptables -t nat -I PREROUTING -i br1 -d 10.0.0.254 -p tcp -j DNAT --to 10.0.0.1:80 

#i2p petitions 
iptables -t nat -A OUTPUT     -d 10.191.0.1 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -d 10.191.0.1 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i br1 -p tcp -m tcp --sport 80 -d 10.191.0.1 -j REDIRECT --to-ports 3128 
#Allow surf onion zone
iptables -t nat -A PREROUTING -p tcp -d 10.192.0.0/16 -j REDIRECT --to-port 9040
iptables -t nat -A OUTPUT     -p tcp -d 10.192.0.0/16 -j REDIRECT --to-port 9040

###### WORK MODE 1 #####
# use TOR for regular and TOR requests

#iptables -t nat -A PREROUTING -i br1 -p tcp --syn -j REDIRECT --to-ports 9040


####### WORK MODE 2 #####
# use TOR for TOR petitions
# use Squid for the rest

#regular 80 port traffic to squid
iptables -t nat -A PREROUTING -i br1 -s 10.0.0.0/16 -p tcp --dport 80 -j REDIRECT --to-port 3129

#rest for TOR
iptables -t nat -A PREROUTING -i br1 -p tcp --syn -m multiport ! --dports 80 -j REDIRECT --to-ports 9040
[ -e /etc/blacklists/blacklists-iptables.sh ] && /etc/blacklists/blacklists-iptables.sh &

exit 0
EOF

chmod +x /etc/rc.local

/etc/rc.local
}


# ---------------------------------------------------------
# ************************ MAIN ***************************
# This is the main function on this script
# ---------------------------------------------------------

# Block 1: Configuing Network Interfaces

check_root			# Checking user
get_variables			# Getting variables
get_interfaces			# Getting external and internal interfaces
configure_hosts			# Configurint hostname and /etc/hosts
configure_interfaces		# Configuring external and internal interfaces



#configure_blacklists		# Configuting blacklist to block some ip addresses
#configure_iptables		# Configure iptables rules


