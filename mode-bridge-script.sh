#!/bin/bash

# ----------------------------------------------
# valid_ip
# ----------------------------------------------
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# ----------------------------------------------
# valid_netmask
# ----------------------------------------------
function valid_netmask()
{
    local netmask=$1
    local netmask_binary
    local octet
    local stat

    if [[ $netmask =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        stat=0
        for ((i=0; i<4; i++))
        do
            octet=${netmask%%.*}
            netmask=${netmask#*.}
            [[ $octet -gt 255 ]] && { stat=1; break; }
            netmask_binary=$netmask_binary$( echo "obase=2; $octet" | bc )
            [[ $netmask_binary =~ 01 ]] && { stat=1; break; }
        done
    else
        stat=1
    fi
    return $stat
}

# MODE SELECTION 
echo "" ; 
echo "CommunityCube initial wizard, please select an option: "
echo "  [1] Protect privacy"
echo "  [2] CommunityCube Services"
echo -n "Enter your selection: "
read -n 1 MODE
echo
while [ "$MODE" != "1" ] && [ "$MODE" != "2" ]; do
	echo -n "Option $MODE not available, please choose 1 or 2: " 
	read -n 1 MODE
	echo
done
echo " Selection $MODE" 

#  -----------------
#  ------ WAN ------
#  -----------------

# INTERNET SELECTION 
echo "" ; 
echo "How will you access to Internet: "
echo "  [1] Ethernet (wired)"
echo "  [2] WiFi (wireless)"
echo -n "Enter your selection: "
read -n 1 ACCESS
echo
while [ "$ACCESS" != "1" ] && [ "$ACCESS" != "2" ]; do
	echo -n "Option $ACCESS not available, please choose 1 or 2: " 
	read -n 1 ACCESS
	echo
done
echo "Selection $ACCESS" 

# WAN Interface
if [ "$ACCESS" == "1" ]
then
	NET_INTERFACE="eth0"
else
	NET_INTERFACE="wlan0"
fi

# WIFI SELECTION
if [ "$ACCESS" == "2" ]
then
	echo -n "Enter SSID name and press [ENTER]: "
	read SSID_NAME
	echo -n "Enter SSID password and press [ENTER]: "
	read SSID_PASSWORD
	echo "Enter SSID encryption method: "
	echo "  [1] WEP "
	echo "  [2] WPA-PSK"
	echo "  [3] WPA2-PSK"
	echo -n "Enter your selection: "
	read -n 1 SSID_METHOD
	echo
	while [ "$SSID_METHOD" != "1" ] && [ "$SSID_METHOD" != "2" ] && [ "$SSID_METHOD" != "3" ]; do
		echo -n "Option $ACCESS not available, please choose 1, 2 o 3: " 
		read -n 1 ACCESS
		echo
	done
	echo "Selection $SSID_METHOD" 
fi

# FIXED ADDRESS OR DHCP SELECTION 
echo "" ; 
echo "IP configuration:"
echo "  [1] Fixed address"
echo "  [2] DHCP"
echo -n "Enter your selection: "
read -n 1 IP_CONF
echo
while [ "$IP_CONF" != "1" ] && [ "$IP_CONF" != "2" ]; do
	echo -n "Option $IP_CONF not available, please choose 1 or 2: " 
	read -n 1 IP_CONF
	echo
done
echo "Selection $IP_CONF" 

# FIXED ADDRESS SELECTION
if [ "$IP_CONF" == "1" ]
then
	echo -n "Enter IP address and press [ENTER]: "
	read IP_ADDRESS
	while ! valid_ip $IP_ADDRESS; do
		echo -n "IP $IP_ADDRESS is not valid, please enter a valid IP address and press [ENTER]: "
		read IP_ADDRESS
	done
	echo -n "Enter net mask and press [ENTER]: "
	read IP_NETMASK
	while ! valid_netmask $IP_NETMASK; do
		echo -n "Netmask $IP_NETMASK is not valid, please enter a valid net mask address and press [ENTER]: "
		read IP_NETMASK
	done
	echo -n "Enter gateway and press [ENTER]: "
	read IP_GATEWAY
	while ! valid_ip $IP_GATEWAY; do
		echo -n "Gateway $IP_GATEWAY is not valid, please enter a gateway address and press [ENTER]: "
		read IP_GATEWAY
	done
	echo -n "Enter DNS and press [ENTER]: "
	read IP_DNS
	while ! valid_ip $IP_DNS; do
		echo -n "DNS $IP_DNS is not valid, please enter a valid IP address and press [ENTER]: "
		read IP_DNS
	done
	
	# Fix address net file
cat << EOF >  /etc/network/interfaces 
# The loopback network interface  
auto lo  
iface lo inet loopback  
# The primary network interface  
auto $NET_INTERFACE 
iface $NET_INTERFACE inet static  
    address $IP_ADDRESS
    netmask $IP_NETMASK 
    gateway $IP_GATEWAY
    dns-nameservers $IP_DNS
EOF

else	
	# DHCP net file
cat << EOF >  /etc/network/interfaces 
# The loopback network interface  
auto lo  
iface lo inet loopback  
# The primary network interface  
auto $NET_INTERFACE 
iface $NET_INTERFACE inet dhcp

EOF

fi

echo "Configuring interfaces ..."

ifdown $NET_INTERFACE 
sleep 2 
ifup $NET_INTERFACE

echo "Checking Internet access ..."
if ping -c1 www.communitycube.net >/dev/null 2>/dev/null; then
	echo "You need internet to proceed. Exiting"
	exit 
fi



exit; 
