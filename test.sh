#!/bin/bash

$PROCESSOR     # Processor type
$HARDWARE      # Hardware type 


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
	elif [ $PLATFORM = "D8" ]; then
		# Avoid macchanger asking for information
		export DEBIAN_FRONTEND=noninteractive
		echo "deb http://ftp.es.debian.org/debian/ jessie main" > etc/apt/sources.list
		echo "deb http://ftp.es.debian.org/debian/ jessie-updates main" >> etc/apt/sources.list
		echo "deb http://security.debian.org/ jessie/updates main" >> etc/apt/sources.list
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
	apt-get install -y isc-dhcp-server hostapd bridge-utils macchanger ntpdate tor unbound 2>&1 > /tmp/apt-get-install.log
	if [ $? -ne 0 ]; then
		echo "ERROR: unable to install packages"
		exit 3
	fi
}


# ----------------------------------------------
# This function checks hardware (ARM or INTEL)
# ----------------------------------------------
get_hardware()
{
        echo "Detecting hardware ..."
      
        
	if grep ARM /proc/cpuinfo > /dev/null 2>&1; then     # Checking CPU for ARM
           PROCESSOR="ARM"	                             # Processor type
           HARDWARE=`cat /proc/cpuinfo | grep Hardware`      # Hardware type
        elif grep Intel /proc/cpuinfo > /dev/null 2>&1; then # Checking CPU for Intel
           PROCESSOR="Intel"	                             # Processor type
           HARDWARE=`dmidecode -s system-product-name`       # Hardware typr
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
# 1. Checking for DHCP server and Internet in  
# *  network connected to eth0.
# *
# ***** If success.
# *   *
# *   * 2. Enable DHCP client on eth0 and   
# *        default route to eth0
# *
# ***** If no success. 
#     * 
#     * 2. Checking for DHCP server and Internet 
#       *  in network connected to eth1
#       *
#       ***** If success.
#       *   * 
#       *   * 3. Enable DHCP client on eth1.
#       *
#       *
#       ***** If no success.
#           *
#           * 3. Warn user and exit with error.
#
# ----------------------------------------------
get_dhcp_and_Internet()
{
        echo "Getting Internet access on eth0"
       
        # Configuring eth0 to get ip dynamically
	echo "# interfaces(5) file used by ifup(8) and ifdown(8) " > /etc/network/interfaces
	echo -e "auto lo\niface lo inet loopback\n" >> /etc/network/interfaces
	echo -e  "auto eth0\niface eth0 inet dhcp" >> /etc/network/interfaces
	/etc/init.d/networking restart 

        # Checking Internet access on eth0
        if check_internet; then 
		echo "Internet conection established on: eth0"	
	else
		echo "Warning: Unable to get Internet access on eth0"
	        
        	echo "Getting Internet access on eth1"
         
        	# Configuring eth1 to get ip dynamically
	        echo "# interfaces(5) file used by ifup(8) and ifdown(8) " > /etc/network/interfaces
		echo -e "auto lo\niface lo inet loopback\n" >> /etc/network/interfaces
		echo -e "auto eth1\niface eth0 inet dhcp" >> /etc/network/interfaces
		/etc/init.d/networking restart 
 	        
        	# Checking Internet access on eth1
        	if check_internet; then 
			echo "Internet conection established on: eth1"	
		else
			echo "Warning: Unable to get Internet access on eth1"
			echo "Please plugin Internet cable to eth0 or eth1 and enable DHCP on gateway"
			echo "Error: Unable to get Internet access. Exiting"
			exit 7
		fi
	fi
}


# ----------------------------------------------
# MAIN 
# ----------------------------------------------
# This is the main function if this script.
# It uses functions defined above to check user,
# Platform, Hardware, System requirements and 
# Internet connection. Then it downloads
# installs all neccessary packages.
# ----------------------------------------------

check_root    # Checking user 
get_platform  # Getting platform info
get_hardware  # Getting hardware info


if [ "$PROCESSOR" = "Intel" ]; then 
	check_requirements      # Checking requirements for Physical or Virtual machine
        get_dhcp_and_Internet  	# Get DHCP on eth0 or eth1 and connect to Internet
	configure_repositories	# Prepare and update repositories
	install_packages       	# Download and install packages	
fi



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


# Prepare owncloud repo
# echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/ /' > /etc/apt/sources.list.d/owncloud.list
# wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key -O- | apt-key add -

# Prepare owncloud repo
# echo 'deb http://packages.prosody.im/debian wheezy main' > /etc/apt/sources.list.d/prosody.list
# wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -
 
# Prepare tahoe repo
# echo 'deb https://dl.dropboxusercontent.com/u/18621288/debian wheezy main' > /etc/apt/sources.list.d/tahoei2p.list

# Prepare yacy repo
# echo 'deb http://debian.yacy.net ./' > /etc/apt/sources.list.d/yacy.list
# apt-key advanced --keyserver pgp.net.nz --recv-keys 03D886E7

# Prepare i2p repo
# echo 'deb http://deb.i2p2.no/ stable main' > /etc/apt/sources.list.d/i2p.list
# wget --no-check-certificate https://geti2p.net/_static/i2p-debian-repo.key.asc -O- | apt-key add -

# Prepare tor repo
# echo 'deb http://deb.torproject.org/torproject.org wheezy main'  > /etc/apt/sources.list.d/tor.list
# gpg --keyserver keys.gnupg.net --recv 886DDD89
# gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# Install packages
## apt-get update
# autoscript-system 
# apt-get install -y i2p-keyring deb.torproject.org-keyring killyourtv-keyring
# apt-get install -y debian-keyring uboot-mkimage console-tools subversion build-essential git libncurses5-dev 
# apt-get install -y bc sudo lsb-release dnsutils ca-certificates-java openssh-server ssh wireless-tools usbutils apt-transport-https unzip
## apt-get install -y isc-dhcp-server hostapd bridge-utils macchanger ntpdate tor unbound
# apt-get install -y hostapd
# apt-get install -y bridge-utils
# apt-get install -y macchanger
# apt-get install -y ntpdate
# apt-get install -y tor
# apt-get install -y unbound

# autoscript-network
# apt-get install -y privoxy
# apt-get install -y squid3


# autoscript-services  
# apt-get install -y nginx
# apt-get install -y php5-common php5-fpm php5-cli php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-memcache php-xml-parser php-pear
# apt-get install -y tor
# apt-get install -y i2p
# apt-get install -y unbound
# apt-get install -y owncloud apache2-mpm-prefork- apache2-utils- apache2.2-bin- apache2.2-common-
# apt-get install -y openjdk-7-jre-headless
# apt-get install -y yacy
# apt-get install -y i2p-tahoe-lafs
# apt-get install -y phpmyadmin
# apt-get install -y php5 mysql-server php5-curl php5-gd php5-mysql php5-imap smarty3 git



exit 
