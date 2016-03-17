#!/bin/bash

PROCESSOR="Not Detected"     		# Processor type
HARDWARE="Not Detected"      		# Hardware type 
EXTERNAL_INTERFACE="Not Detected"	# External Interface (Connected to Internet) 

# ----------------------------------------------
# This function detects platform.
#
# Suitable platform are:
#
#  * Ubuntu 12.04
#  * Ubuntu 14.04
#  * Debian GNU/Linux 7
#  * Debian GNU/Linux 8  
# ----------------------------------------------
get_platform () 
{
        echo "Detecting platform ..."
	FILE=/etc/issue
	if cat $FILE | grep "Ubuntu 12.04" > /dev/null; then
		PLATFORM="U12"
	elif cat $FILE | grep "Ubuntu 14.04" > /dev/null; then
		PLATFORM="U14"
	elif cat $FILE | grep "Debian GNU/Linux 7" > /dev/null; then
		PLATFORM="D7"
	elif cat $FILE | grep "Debian GNU/Linux 8" > /dev/null; then
		PLATFORM="D8"
	else 
		echo "ERROR: UNKNOWN PLATFORM" 
		exit
	fi
	echo "Platform: $PLATFORM"
}

# ----------------------------------------------
# check_internet
# ----------------------------------------------
check_internet () 
{
	echo "Checking Internet access ..."
	if ! ping -c1 8.8.8.8 >/dev/null 2>/dev/null; then
		echo "You need internet to proceed. Exiting"
		exit 1
	fi
}

# ----------------------------------------------
# check_root
# ----------------------------------------------
check_root ()
{
	echo "Checking user root ..."
	if [ "$(whoami)" != "root" ]; then
		echo "You need to be root to proceed. Exiting"
		exit 2
	fi
}

# ----------------------------------------------
# configure_repositories
# ----------------------------------------------
configure_repositories () 
{
	echo "Configuring repositories ... "
	if [ $PLATFORM = "U12" ]; then
		exit
	elif [ $PLATFORM = "U14" ]; then
		exit
	elif [ $PLATFORM = "D7" ]; then
		echo "deb http://ftp.us.debian.org/debian wheezy main non-free contrib" > etc/apt/sources.list
		echo "deb http://ftp.debian.org/debian/ wheezy-updates main contrib non-free" >> etc/apt/sources.list
		echo "deb http://security.debian.org/ wheezy/updates main contrib non-free" >> etc/apt/sources.list
	
		# Prepare owncloud repo
		echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/ /' > /etc/apt/sources.list.d/owncloud.list
		wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key -O- | apt-key add -

		# Prepare owncloud repo
		echo 'deb http://packages.prosody.im/debian wheezy main' > /etc/apt/sources.list.d/prosody.list
		wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -
 
		# Prepare tahoe repo
		echo 'deb https://dl.dropboxusercontent.com/u/18621288/debian wheezy main' > /etc/apt/sources.list.d/tahoei2p.list

		# Prepare yacy repo
		echo 'deb http://debian.yacy.net ./' > /etc/apt/sources.list.d/yacy.list
		apt-key advanced --keyserver pgp.net.nz --recv-keys 03D886E7

		# Prepare i2p repo
		echo 'deb http://deb.i2p2.no/ stable main' > /etc/apt/sources.list.d/i2p.list
		wget --no-check-certificate https://geti2p.net/_static/i2p-debian-repo.key.asc -O- | apt-key add -

		# Prepare tor repo
		echo 'deb http://deb.torproject.org/torproject.org wheezy main'  > /etc/apt/sources.list.d/tor.list
		gpg --keyserver keys.gnupg.net --recv 886DDD89
		gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -


	elif [ $PLATFORM = "D8" ]; then
		# Avoid macchanger asking for information
		export DEBIAN_FRONTEND=noninteractive
		echo "deb http://ftp.es.debian.org/debian/ jessie main" > etc/apt/sources.list
		echo "deb http://ftp.es.debian.org/debian/ jessie-updates main" >> etc/apt/sources.list
		echo "deb http://security.debian.org/ jessie/updates main" >> etc/apt/sources.list

		# Prepare owncloud repo
		echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/ /' > /etc/apt/sources.list.d/owncloud.list
		wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key -O- | apt-key add -

		# Prepare owncloud repo
		echo 'deb http://packages.prosody.im/debian wheezy main' > /etc/apt/sources.list.d/prosody.list
		wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -
 
		# Prepare tahoe repo
		echo 'deb https://dl.dropboxusercontent.com/u/18621288/debian wheezy main' > /etc/apt/sources.list.d/tahoei2p.list

		# Prepare yacy repo
		echo 'deb http://debian.yacy.net ./' > /etc/apt/sources.list.d/yacy.list
		apt-key advanced --keyserver pgp.net.nz --recv-keys 03D886E7

		# Prepare i2p repo
		echo 'deb http://deb.i2p2.no/ stable main' > /etc/apt/sources.list.d/i2p.list
		wget --no-check-certificate https://geti2p.net/_static/i2p-debian-repo.key.asc -O- | apt-key add -

		# Prepare tor repo
		echo 'deb http://deb.torproject.org/torproject.org wheezy main'  > /etc/apt/sources.list.d/tor.list
		gpg --keyserver keys.gnupg.net --recv 886DDD89
		gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
	else 
		echo "ERROR: UNKNOWN PLATFORM" 
		exit
	fi
}
# ----------------------------------------------
# This script installs bridge-utils package and
# configures bridge interfaces.
#
# br0 = eth0 and wlan0 
# br1 = eth1 and wlan1
# ----------------------------------------------
configure_bridge()
{
	# Updating and installing bridge-utils package
	echo "Updating repositories ..."
        apt-get update 2>&1 > /tmp/apt-get-update-bridge.log
 	echo "Installing bridge-utils ..."
	apt-get install bridge-utils 2>&1 > /tmp/apt-get-install-bridge.log

	# Checking if bridge-utils is installed successfully
        if [ $? -ne 0 ]; then
		echo "Error: Unable to install bridge-utils"
		exit 8
	else

        # Configuring bridge interfaces
	echo "Configuring bridge interfaces..."
	echo "# interfaces(5) file used by ifup(8) and ifdown(8) " > /etc/network/interfaces
	echo "auto lo" >> /etc/network/interfaces
	echo "iface lo inet loopback" >> /etc/network/interfaces
	echo "#External network interface" >> /etc/network/interfaces
	echo "auto eth0" >> /etc/network/interfaces
	echo "allow-hotplug eth0" >> /etc/network/interfaces
	echo "iface eth0 inet dhcp" >> /etc/network/interfaces
	echo "#External network interface" >> /etc/network/interfaces
	echo "# wireless wlan0" >> /etc/network/interfaces
	echo "auto wlan0" >> /etc/network/interfaces
	echo "allow-hotplug wlan0" >> /etc/network/interfaces
	echo "iface wlan0 inet manual" >> /etc/network/interfaces
	echo "##External Network Bridge " >> /etc/network/interfaces
	echo "#auto br0" >> /etc/network/interfaces
	echo "#allow-hotplug br0" >> /etc/network/interfaces
	echo "#iface br0 inet dhcp" >> /etc/network/interfaces   
	echo "#    bridge_ports eth0 wlan0" >> /etc/network/interfaces
	echo "#Internal network interface" >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "allow-hotplug eth1" >> /etc/network/interfaces
	echo "iface eth1 inet manual" >> /etc/network/interfaces
	echo "#Internal network interface" >> /etc/network/interfaces
	echo "# wireless wlan1" >> /etc/network/interfaces
	echo "auto wlan1" >> /etc/network/interfaces
	echo "allow-hotplug wlan1" >> /etc/network/interfaces
	echo "iface wlan1 inet manual" >> /etc/network/interfaces
	echo "# Internal network Bridge" >> /etc/network/interfaces
	echo "auto br1" >> /etc/network/interfaces
	echo "allow-hotplug br1" >> /etc/network/interfaces
	echo "# Setup bridge" >> /etc/network/interfaces
	echo "iface br1 inet static" >> /etc/network/interfaces
	echo "    bridge_ports eth1 wlan1" >> /etc/network/interfaces
	echo "    address 10.0.0.1" >> /etc/network/interfaces
	echo "    netmask 255.255.255.0" >> /etc/network/interfaces
	echo "    network 10.0.0.0" >> /etc/network/interfaces
	fi

}


# ----------------------------------------------
# install_packages
# ----------------------------------------------
install_packages () 
{
	echo "Updating repositories packages ... "
	apt-get update 2>&1 > /tmp/apt-get-update.log
	echo "Installing packages ... "
	apt-get install -y privoxy squid3 nginx php5-common php5-fpm php5-cli php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-memcache php-xml-parser php-pear i2p unbound owncloud apache2-mpm-prefork- apache2-utils- apache2.2-bin- apache2.2-common- openjdk-7-jre-headless yacy i2p-tahoe-lafs phpmyadmin php5 mysql-server php5-gd php5-imap smarty3 git onbound ntpdate macchanger bridge-utils hostapd isc-dhcp-server hostapd bridge-utils macchanger ntpdate tor bc sudo lsb-release dnsutils ca-certificates-java openssh-server ssh wireless-tools usbutils apt-transport-https unzip debian-keyring uboot-mkimage console-tools subversion build-essential libncurses5-dev i2p-keyring deb.torproject.org-keyring killyourtv-keyring hostapd 2>&1 > /tmp/apt-get-install.log
	if [ $? -ne 0 ]; then
		echo "ERROR: unable to install packages"
		exit 3
	fi
}


# ----------------------------------------------
# This function checks hardware (ARM or INTEL).
# It gets Processor and Hardware types and saves
# them in PROCESSOR and HARDWARE variables.
# ----------------------------------------------
get_hardware()
{
        echo "Detecting hardware ..."
      
        # Checking CPU for ARM and saving
	# Processor and Hardware types in
	# PROCESSOR and HARDWARE variables
	if grep ARM /proc/cpuinfo > /dev/null 2>&1; then    
           PROCESSOR="ARM"	                           
           HARDWARE=`cat /proc/cpuinfo | grep Hardware | awk {'print $3'}`   
        # Checking CPU for Intel and saving
	# Processor and Hardware types in
	# PROCESSOR and HARDWARE variables
	elif grep Intel /proc/cpuinfo > /dev/null 2>&1; then 
           PROCESSOR="Intel"	                             
           HARDWARE=`dmidecode -s system-product-name`       
	fi

        # Printing Processor and Hardware types     

	echo "Processor: $PROCESSOR"
        echo "Hardware: $HARDWARE"
}

# ----------------------------------------------
# This script checks requirements for Physical 
# Machines.
# 
#  Minimum requirements are:
#
#  * 2 Network Interfaces.
#  * 1 GB Physical Memory (RAM).
#  * 16 GB Free Space On Hard Drive.
#
# ----------------------------------------------
check_requirements()
{
	echo "Checking requirements ..."

        # This variable contains network interfaces quantity.  
	NET_INTERFACES=`ls /sys/class/net/ | grep -w 'eth0\|eth1\|wlan0\|wlan1' | wc -l`

        # This variable contains total physical memory size.
        MEMORY=`grep MemTotal /proc/meminfo | awk '{print $2}'`
	
	# This variable contains total free space on root partition.
	STORAGE=`df -h / | grep -w "/" | awk '{print $4}' | sed 's/[^0-9]*//g'`
        
        # Checking network interfaces quantity.
	if [ $NET_INTERFACES -le 1 ]; then
        	echo "You need at least 2 network interfaces. Exiting"
		exit 4 
        fi
	
	# Checking physical memory size.
        if [ $MEMORY -le 900000 ]; then 
		echo "You need at least 1GB of RAM. Exiting"
                exit 5
        fi

	# Checking free space. 
        if [ $STORAGE -le 16 ]; then 
		echo "You need at least 16GB of free space. Exiting"
		exit 6
        fi
}

# ----------------------------------------------
# This function enables DHCP client and checks 
# for Internet on predefined network interface.
#
# Steps to define interface are:
#
# 1. Checking Internet access. 
# *
# *
# ***** If success. 
# *
# *     2. Get Interface name 
# *
# ***** If no success. 
#     *
#     * 2. Checking for DHCP server and Internet in  
#       *  network connected to eth0.
#       *
#       ***** If success.
#       *   *
#       *   * 2. Enable DHCP client on eth0 and   
#       *        default route to eth0
#       *
#       ***** If no success. 
#           * 
#           * 2. Checking for DHCP server and Internet 
#           *  in network connected to eth1
#           *
#           ***** If success.
#           *   * 
#           *   * 3. Enable DHCP client on eth1.
#           *
#           *
#           ***** If no success.
#               *
#               * 3. Warn user and exit with error.
#
# ----------------------------------------------
get_dhcp_and_Internet()
{
	# Check internet Connection. If Connection exist then get 
	# and save Internet side network interface name in 
	# EXTERNAL_INTERFACE variable
	if ping -c1 8.8.8.8 >/dev/null 2>/dev/null; then
		EXTERNAL_INTERFACE=`route -n | awk {'print $1 " " $8'} | grep "0.0.0.0" | awk {'print $2'}`
		echo "Internet connection established on interface $EXTERNAL_INTERFACE"
	else
		# Checking eth0 for Internet connection
        	echo "Getting Internet access on eth0"
		echo "# interfaces(5) file used by ifup(8) and ifdown(8) " > /etc/network/interfaces
		echo -e "auto lo\niface lo inet loopback\n" >> /etc/network/interfaces
		echo -e  "auto eth0\niface eth0 inet dhcp" >> /etc/network/interfaces
		/etc/init.d/networking restart 
		if ping -c1 8.8.8.8 >/dev/null 2>/dev/null; then
			echo "Internet conection established on: eth0"	
			EXTERNAL_INTERFACE="eth0"
		else
			echo "Warning: Unable to get Internet access on eth0"
        		# Checking eth1 for Internet connection
			echo "Getting Internet access on eth1"
	        	echo "# interfaces(5) file used by ifup(8) and ifdown(8) " > /etc/network/interfaces
			echo -e "auto lo\niface lo inet loopback\n" >> /etc/network/interfaces
			echo -e "auto eth1\niface eth1 inet dhcp" >> /etc/network/interfaces
			/etc/init.d/networking restart 
			if ping -c1 8.8.8.8 >/dev/null 2>/dev/null; then
				echo "Internet conection established on: eth1"	
				EXTERNAL_INTERFACE="eth1"
			else
				echo "Warning: Unable to get Internet access on eth1"
				echo "Please plugin Internet cable to eth0 or eth1 and enable DHCP on gateway"
				echo "Error: Unable to get Internet access. Exiting"
				exit 7
			fi
		fi
	fi
}

# ----------------------------------------------
# This scripts check odroid board to find out if
# it assembled or not.
# There are list of additional modules that need
# to be connected to board.
# Additional modules are.
# 	1. ssd 8gbc10
#	2. HDD 2TB
#	3. 2xWlan interfaces
#	4. TFT screen
# ----------------------------------------------
check_assemblance()
{
	echo "Checking assemblance ..."
	
	echo "Checking network interfaces ..."  
	# Script should detect 4 network 
	# interfaces.
	# 1. eth0
	# 2. eth1
	# 3. wlan0
	# 4. wlan1
	if   ! ls /sys/class/net/ | grep -w 'eth0'; then
		echo "Error: Interface eth0 is not connected. Exiting"
		exit 8
	elif ! ls /sys/class/net/ | grep -w 'eth1'; then
		echo "Error: Interface eth1 is not connected. Exiting"
		exit 9
	elif ! ls /sys/class/net/ | grep -w 'wlan0'; then
		echo "Error: Interface wlan0 is not connected. Exiting"
		exit 10
	elif ! ls /sys/class/net/ | grep -w 'wlan1'; then
		echo "Error: Interface wlan1 is not connected. Exiting"
		exit 11  
	fi
	echo "Network interfaces checking finished. OK"

	echo ""


}

# ----------------------------------------------
# MAIN 
# ----------------------------------------------
# This is the main function of this script.
# It uses functions defined above to check user,
# Platform, Hardware, System requirements and 
# Internet connection. Then it downloads
# installs all neccessary packages.
# ----------------------------------------------
#
# ----------------------------------------------
# At first script will check
#
# 1. User      ->  Need to be root
# 2. Platform  ->  Need to be Debian 7 / Debian 8 / Ubuntu 12.04 / Ubuntu 14.04 
# 3. Hardware  ->  Need to be ARM / Intel
# ----------------------------------------------
check_root    # Checking user 
get_platform  # Getting platform info
get_hardware  # Getting hardware info

# ----------------------------------------------
# If script detects Physical/Virtual machine
# then next steps will be
# 
# 4. Checking requirements
# 5. Get Internet access
# 6. Configure repositories
# 7. Download and Install packages
# ----------------------------------------------
if [ "$PROCESSOR" = "Intel" ]; then 
	check_requirements      # Checking requirements for Physical or Virtual machine
        get_dhcp_and_Internet  	# Get DHCP on eth0 or eth1 and connect to Internet
	configure_repositories	# Prepare and update repositories
	install_packages       	# Download and install packages	

# ---------------------------------------------
# If script detects odroid board then next 
# steps will be
#
# 4. Checking if board is assembled
# 5. Configure bridge interfaces
# 6. Check Internet Connection
# 7. Configure repositories
# 8. Download and Install packages
# ---------------------------------------------
elif [ "$PROCESSOR" = "ARM" ]; then 
	check_assemblance
	configure_bridges
	check_internet
	configure_repositories
	install_packages
fi

# ---------------------------------------------
# If script reachs to this point then it's done 
# successfully
# ---------------------------------------------
echo "Initialization done successfully"

















#check_internet
#install_packages
#configure_network
#configure_dhcp













# dpkg-reconfigure locales

# echo "communitycube" > /etc/hostname

#cat << EOF > /etc/hosts
#127.0.0.1       communitycube.localdomain localhost.localdomain communitycube localhost
#::1             communitycube.localdomain localhost.localdomain communitycube localhost ip6-localhost ip6-loopback
#fe00::0         ip6-localnet
#ff00::0         ip6-mcastprefix
#ff02::1         ip6-allnodes
#ff02::2         ip6-allrouters
#EOF





exit 
