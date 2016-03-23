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
# This function checks network interfaces.
# The interface connected to network will be saved on 
# EXT_INTERFACE variaable and other awailable interface
# will be saved on INT_INTERFACE variable.
# ---------------------------------------------------------
get_interfaces()
{
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
}






# ---------------------------------------------------------
# ************************ MAIN ***************************
# This is the main function on this script
# ---------------------------------------------------------
check_root			# Checking user
get_interfaces			# Getting external and internal interfaces
configure_hosts			# Configurint hostname and /etc/hosts
configure_interfaces		# Configuring external and internal interfaces

