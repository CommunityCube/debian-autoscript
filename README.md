Community Cube
==============

_Discover how two geeks invented a kick-ass technology that helps normal people protect themselves from government snoopers._
![c3](https://cloud.githubusercontent.com/assets/4359120/13480606/1105570a-e0b1-11e5-960e-2fad426ed6b4.png)

## What is Community Cube(C-Cube)?

It is a mini-server that can replace your router, work with your router or connect to another ***C-Cube*** by mesh based on a OpenSource: community, drivers and hardware.

## A little context...

As part of Open Source of community ***C-Cube*** target to build a complete and plug-and-play solution intended to bypass censorship, gov/spy agencies, and anything that could get in danger your privacy.

Community Cube initiative is a __Peered Cooperativeness Project__ that intends to be the biggest world wide cooperative company allowing investment only to purchase of *boxes* and connecting them to the ***C-Cube*** network. All the buyers has two possibilities, be a shareholder or not.

## What ain't Community Cube? (..and will never be)

- A private society or corporation.
- Head managed.
- Difficult to use.

## Features

- Cloud Storage (Powered by [OwnCloud](http://owncloud.org/))
- Voice/Video IM
- DNS
- Email
- Search Engine (Powered by [Yacy](yacy.net/))
- GRID computing
- Connection Sharing
- Anonymized traffic HotSpot
- CDN
- Service Gateways
- Backup of all your data... Even if your box is stolen or something.

## Why not just use existing Darknets/F2net?

None of _F2Friend-nets_, _darknets_, _private-nets_, _Libre-nets_, _peering-nets_,  _deep-web_ are the first choice for any non-technical end users, they need a product to protect their-selves. Most of _secured_ services work inside those _pseudoF2Fnets_ that often don't offer a ***decentralized real world interconnection***, and almost all don't offer a ***soft migration*** way for a those end users, often trained, for a commercial centralized product.

## Community Cube protect us against...?

Bad people with bad intentions like:

- **Sniffers**: those that are checking your traffic
- **Government spy/monitoring institutions passive actions**: like passive bots collecting general data from worldwide, if they target  anyone... that is another story.
- **CommunityCube evil nodes**:  a box Owned for those _bad people_.
- **Malicious internet nodes**: better known as _blackbones_.
- **Your internet provider (ISP)**: if they would trying anything with your data.


## How C-Cube network works?

A picture worth more than 10.000 words:

![infrastructurediagram](https://cloud.githubusercontent.com/assets/4359120/13481321/e9e5d608-e0b6-11e5-9168-8f66ae8ea968.png)

## How to collaborate?

Easy as fork us and send pull requests, but if you want to get in touch with us meet us in our web page [CageOS](www.cageos.org).

## Which hardware is needed to run C-Cube?

This is on discussion yet, but the idea is to offer a solution that can be deployable on a public distribution with your own hardware, but as standalone  we have this models:

- Low-end model - Odroid C1:

|:Description:|:Cost:|:Currency:|
|--------|----|---|
|Odroid C1  | 38|  €|
|ssd 8gbc10|  7  | €|
|USB2ETH |9   |€|
|2xWLAN 1watt|    17 | €|
|Batteries|   20  |€|
|CASE|    19  |€|
|RoboPeak Usb tft screen  | 45   |€|
|subTOTAL|    156 |€|
|Assembly|    33  |€|
|TOTAL|    190 |€|

- High-end model - Odroid XU3 Lite:

|:Description:|:Cost:|:Currency:|
|--------|----|---|
|Odroid XU3  | 99|  €|
|ssd 8gbc10|  7  | €|
|HDD 2TB|75|€|
|USB2ETH |9   |€|
|2xWLAN 1watt|    17 | €|
|CASE|    19  |€|
|RoboPeak Usb tft screen  | 45   |€|
|subTOTAL|    272 |€|
|Assembly|    33  |€|
|TOTAL|    310 |€|

## Setup
<!-- this part needs to be refactored by someone that does know the current state of building process -->
This script it's intented to transform a Debian Wheezy base installation to a CommunityCube System.

Then your computers and devices should be connected to DHCP network served in eth1/wlan1, and avoid direct contact to internet. This way your devices and your digital life will be protected.

Internal net (eth1/wlan1) - CageOS - internet (eth0/wlan09)
 
Execution order it's:

1- autoscript-system
It prepares whole system, APT repos, network, hostapd (for wlan1), DHCP server for br1, TOR as dns resolver, macchanger on each reboot, ntpdate 

2- autoscript-services
It prepares running services: yacy, friendica, owncloud, tahoe, i2p, tor hidden services, nginx access

3- autoscript-network
It prepares CommunityCube as a proxy to browse transparently darknets, filter content (squid), route petitions (iptables), dns resolution (unbound), proxifier (privoxy), blocking advertisment (iptables), redirection known domains to local domains (ex: google.com -> internal yacy)

## License
>You can check out the full license [here](https://github.com/CommunityCube/debian-autoscript/blob/master/LICENSE)

This project is licensed under the terms of the **GNU GPL V2** license.