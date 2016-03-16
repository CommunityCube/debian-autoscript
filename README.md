Community Cube
==============

_Discover how two geeks invented a kick-ass technology that helps normal people protect themselves from government snoopers._
![c3](https://cloud.githubusercontent.com/assets/4359120/13480606/1105570a-e0b1-11e5-960e-2fad426ed6b4.png)

## What is Community Cube(C-Cube)?

***COMMUNITY CUBE*** is a technology that makes protecting your privacy easy. Thanks to a unique combination of  open hardware and software, it’s both a server and a provider of free secure services. You can trust us, we are fully open.

***C-Cube*** is a plug and play, open source, energy efficient server designed from the ground up with security and privacy in mind.

###Why do we need this technology?

The Internet is full of ___free___ services. Most are offered by __large corporations__ that work for the _common good_. Right? 

**NOT TRUE!**. They are giving you something for _free_ because they want something in return - your personal data.  By **burying** the details in their _terms and conditions page_, that ***almost nobody reads***, they are in fact hiding their nefarious intentions.

**Community Cube** operates exactly the opposite, because we integrate into each **C-Cube** a carefully selected  security audited services, you no longer need to depend on the good intentions of these big corporations.

Community Cube initiative work as a __Peered Cooperativeness Project__ that intends to be the biggest world wide cooperative company allowing investment only to purchase of *boxes* and connecting them to the ***C-Cube*** network. 

## What ain't Community Cube? (..and will never be)

- A private society or corporation.
- Head managed.
- Difficult to use.

## Features Comparison

Some of __C-Cube__ services has being provided by some time, but un-integrated and with some flaws, let's show you:

![Services](https://ksr-ugc.imgix.net/assets/003/699/855/2679953ba748e512d3ec207f732d1bb2_original.jpg?v=1430329011&w=680&fit=max&auto=format&q=92&s=b7153d55686098a5c8a52ef9a57e10bd)

If you want more information about the software that we picked check [here](https://cageos.org/index.php?page=apps).

## Why not just use existing Darknets/F2net?

None of _F2Friend-nets_, _darknets_, _private-nets_, _Libre-nets_, _peering-nets_,  _deep-web_ are the first choice for any non-technical end users, they need a product to protect their-selves. Most of _secured_ services work inside those _pseudoF2Fnets_ that often don't offer a ***decentralized real world interconnection***, and almost all don't offer a ***soft migration*** way for a those end users, often trained, for a commercial centralized product.

## Community Cube protect us against...?

Bad people with bad intentions like:

- **Sniffers**: those that are checking your traffic
- **Government spy/monitoring institutions passive actions**: like passive bots collecting general data from worldwide, if they target  anyone... that is another story.
- **CommunityCube evil nodes**:  a box Owned for those _bad people_.
- **Malicious internet nodes**: better known as _blackbones_.
- **Your internet provider (ISP)**: if they would trying anything with your data.

## How does it protect me?

In technical words , to protect you, Community Cube does:

 - Filtering virus, exploits _malware_, ads , bad IP-sources and bad content.
 - Decentralizing the services (doing impossible to apply big data to you )
 - Open authentication (dissolve legal relation between user and name-ip), Dark-nets (anonymisation of IP)
 - Forcing encryption for all communications and data storage and in rest.
 - Filtering the data that expose you, like scripts,cookies, browser info,etc.


## How C-Cube network works?

In our decentralized system your valuable information is encrypted three times:

1. Before it even leaves your computer, in the web browser
2. In the collaboration tool before the data goes to the hard disk
3. When backing up to the grid, the slices will also be encrypted.

![CCube Network](https://ksr-ugc.imgix.net/assets/003/699/998/0698df91b8b2e9e1c61368ae8eeb7798_original.jpg?v=1430330247&w=680&fit=max&auto=format&q=92&s=e140edd32e6462fdd221c8b299bc965f)

You want more information, you can check [here](https://cageos.org/index.php?page=network) for more information or [here](https://213.129.164.215:4580/dokuwiki/doku.php?id=communitycube_overview) for a lot more information.

## How to collaborate?

Easy as fork us and send pull requests, but if you want to get in touch with us meet us in our web page [CageOS](www.cageos.org).

## Which hardware is needed to run C-Cube?

This is on discussion yet, but the idea is to offer a solution that can be deployable on a public distribution with your own hardware, but as standalone  we have this models:

- **C-Cube** has two presentations:

|Low-end model - Odroid C2| High-end model - Odroid XU4|
|--------|--------|
|Odroid C2  | Odroid XU4 |
|ssd 8gbc10|ssd 8gbc10|
|USB2ETH | HDD 2TB|
|2xWLAN 1watt| SB2ETH |
|Batteries|2xWLAN 1watt|
|CASE| CASE|
|RoboPeak Usb tft screen  |RoboPeak Usb tft screen  |

![XU4](https://ksr-ugc.imgix.net/assets/003/944/858/1dd038cc6d011fae2e9c64b3373f26aa_original.jpg?v=1433797073&w=680&fit=max&auto=format&q=92&s=7465889c0357eb0ccbaf781a4c0e7016)

More information [here](https://213.129.164.215:4580/dokuwiki/doku.php?id=technical:hardware:communitycube_-_odroid_xu3_lite).


## Setup
<!-- this part needs to be refactored by someone that does know the current state of building process -->
There are 2 ways to join to CommunityCube network

#### 1. Setup CommunityCube software on Physical/Virtual machine.
#### 2. Setup CommunityCube software on Odroid XU3/XU4/C1+/C2

### Steps to setup on Physical/Virtual machine.

#### Step 1: Checking requirements

Your Physical/Virtual machine need to meet the minimum requirements:

1. 2 network interface
2. 1 GB of Physical memory
3. 16 GB of free space

If your machine is ok with requirement, then you can process to next step.

#### Step 2: Setup the network.

In this step you need to connect one interface of your machine to Internet, and other one to local network device.

#### Step 3. Executing scripts.

In this step you need to download and execute the following scripts on your machine with given order.

#### 1. test.sh (Initialization script)

Script workflow

1. Check User 
You need to run script as root user

2. Check Platform 
Platform should be Debian 7/8, Ubuntu 12.04/14.04

3. Check Hardware 
If you are running this script on odroid it should detect Intel processor

4. Check Requirements 
Machine should match the requirements mentioned above

5. Check Internet
Check Internet connection.

6. Prepare perositories
Update repositories for necessary packages

7. Download packages
Download necessary packages

8. Install packages
Install necessary packages

>You can find Initialization workflow [here](https://213.129.164.215:4580/dokuwiki/doku.php?id=initialization_workflow)

#### 2. app-installation-script.sh (Configuration script)

It aims to configure all the packages and services.


### Steps to setup on Odroid board.

#### Step 1. Get an odroid and assemble it.

There are several seperate modules that need to be connected to odroid board.

You can find more information about necessary modules [here](https://213.129.164.215:4580/dokuwiki/doku.php?id=technical:hardware:communitycube_-_odroid_xu3_lite).

#### Step 2. Executing scripts.

In this step you need to download and execute the following scripts on your machine with given order.

#### 1. test.sh (Initialization script)

Script workflow

1. Check User 
You need to run script as root user

2. Check Platform 
Platform should be Debian 7/8, Ubuntu 12.04/14.04

3. Check Hardware 
If you are running this script on odroid it should detect ARM processor

4. Check If Assembled 
All neccessary modules should be connected to odroid board

5. Configure Bridge Interfaces 
eth0 and wlan0 will be bridged into interface br0
eth1 and wlan1 will be bridged into interface br1
In ethernet network, br0 should be connected to Internet and br0 to local network
In wireless network, bridge interdace with wore powerful wlan will be connected to Internet and other one to local network

6. Check Internet
Check Internet connection.

7. Prepare perositories
Apdate repositories for necessary packages

8. Download packages
Download necessary packages

9. Install packages
Install necessary packages


>You can find Initialization workflow [here](https://213.129.164.215:4580/dokuwiki/doku.php?id=initialization_workflow)

#### 2. app-installation-script.sh (Configuration script)

It aims to configure all the packages and services.


## License
>You can check out the full license [here](https://github.com/CommunityCube/debian-autoscript/blob/master/LICENSE)

This project is licensed under the terms of the **GNU GPL V2** license.
