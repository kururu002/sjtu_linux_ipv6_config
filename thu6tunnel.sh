#!/bin/bash
REMOTE_IP6="2001:da8:8000:d014:0:5efe" #header for sjtu IPV6(from ipv6.sjtu.edu.cn from Windows)
REMOTE_IP4="10.32.49.2" #new ip (check out from $nslookup isatap.sjtu.edu.cn)

IFACE4=`ip route show|grep default|sed -e 's/^default.*dev \([^ ]\+\).*$/\1/'`
IP4=`ip addr show dev $IFACE4 | grep -m 1 'inet\ ' | sed -e 's/^.*inet \([^ \\]\+\)\/.*$/\1/'`

sudo ip tunnel del sit1 
sudo ip tunnel add sit1 mode sit remote $REMOTE_IP4 local $IP4
sudo ip link set dev sit1 up
sudo ip -6 addr add $REMOTE_IP6:$IP4/64 dev sit1
sudo ip -6 route add default via $REMOTE_IP6:$REMOTE_IP4 dev sit1
