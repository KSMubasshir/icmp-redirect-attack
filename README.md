# ICMP Redirect Attack

## Requiremnts
**OS:** Linux   
virtualbox    
scapy   

## Description

ICMP packets have different types of values.In this article only 3 of them are mentioned:

Type:8 (Echo Request)

Type:0 (Echo Reply)

Type:5 (Redirection Required)

About ICMP Redirection Required:

It is used to notify a better gateway. The host or router receiving the packet will add the new gateway to the routing table (if not configured for precaution purposes). There are 4 different codes: 

0 (for network)
1 (for Host)
2 (for service and network)
3 (for service and host)

The way to understand how to use ICMP is to look at the header information of the IP packet. If the protocol field is 1, it is understood that ICMP is used.

Scapy brings a lot of features in order not to deal with these details.

Note: Kernel ip forward must be enabled on the attacker system, this command would be useful.
````
echo “1”> /proc/sys/net/ipv4/ip_forward
````  
or   
````
sudo sysctl net.ipv4.ip_forward=1 
````  

Scapy can be called from the terminal or added as a library while on a python interactive shell.

If the modules are imported like “import scapy”, the methods must be used as scapy.metod().To use it as a method () instead module has to imported like this notation:
````
from scapy.all import * 
````

## To see routing info
````
route -n  
````
or
````
ip route show  
````
or

````
netstat -rn  
````

## Environment Setup:

Create four virtual machines(server,client,router,attacker) in vbox  
**Victim:**  client   ip = 192.168.1.11  
**Target:**  server   ip = 192.168.2.22  
**Gateway:** router   ip = 192.168.1.1  
**Source:**  attacker ip = 192.168.1.12  


**Topology:**  

				client---------neta-----------router-------------netb------------server
						|		
						|		
						|		
					     attacker
		     
## In Each vms:
````
sudo apt install openssh-server man manpages manpages-dev nano
sudo apt update
sudo apt upgrade
````

## Client:
````
sudo hostnamectl set-hostname client
sudo vi /etc/hosts
````
:wq  

#add interface configuration
````
ifconfig
sudo vi /etc/network/interfaces
````
#the internal interface for neta  
auto enp0s8  
iface enp0s8 inet static  
	address 192.168.1.11   
	netmask 255.255.255.0  
	network 192.168.1.0  
	broadcast 192.168.1.255  
	post-up route add -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.1.1 dev enp0s8  
	pre-down route del -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.1.1 dev enp0s8  


## Router:
````
sudo hostnamectl set-hostname router
sudo vi /etc/hosts
````
:wq 
````
ifconfig  
sudo nano /etc/network/interfaces  
````

#add interface configuration  
#the internal interface for neta  
auto enp0s8  
iface enp0s8 inet static  
	address 192.168.1.1   
	netmask 255.255.255.0  
	network 192.168.1.0  
	broadcast 192.168.1.255  

#the internal interface for netb  
auto enp0s9  
iface enp0s9 inet static  
	address 192.168.2.2  
	netmask 255.255.255.0  
	network 192.168.2.0  
	broadcast 192.168.2.255  

````
sudo vi /etc/sysctl.conf
````
turn ip_forwarding bit on  

## Server:
````
sudo hostnamectl set-hostname server
sudo vi /etc/hosts
````
:wq
````
ifconfig
sudo vi /etc/network/interfaces
````
#the internal interface for netb  
auto enp0s8  
iface enp0s8 inet static  
	address 192.168.2.22  
	netmask 255.255.255.0   
	network 192.168.2.0  
	broadcast 192.168.2.255  
	post-up route add -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.2.2 dev enp0s8  
	pre-down route del -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.2.2 dev enp0s8  

## Attacker:
````
sudo hostnamectl set-hostname attacker
sudo vi /etc/hosts
````
:wq
````
ifconfig
sudo vi /etc/network/interfaces
````
#the internal interface for neta  
auto enp0s8  
iface enp0s8 inet static  
	address 192.168.1.12  
	netmask 255.255.255.0  
	network 192.168.1.0  
	broadcast 192.168.1.255  
	post-up route add -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.1.1 dev enp0s8  
	pre-down route del -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.1.1 dev enp0s8  


## To see these configurations
````
cat /etc/network/interfaces
````

## Launch attack:
Run attack.py in attacker(./script.sh will make it easier) 
````
python icmp_redir_attack.py -v 192.168.1.11 -t 192.168.2.22 -g 192.168.1.12 -s 192.168.1.1
````
or

````
./script.sh
````

run server.py in server  
````
python server.py
````

run client.py in client  
````
python client.py
````



Client will not connect to server.  
It will send it's msg to attacker.  
Use wireshark to capture these packets.  







