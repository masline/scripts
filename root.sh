#!/bin/bash

# To download and run
# wget  && bash root.sh

# Setup persistent iptables to survive reboot
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
aptitude -R install -y -q iptables-persistent > /dev/null 2>&1

# Firewall rules
# First run, iptables should be clean, but Flush all rules anyway
iptables -F
iptables -X

# Running this first so I don't get kicked off from SSH
# Accepts all established inbound/outbound connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow connections only from business IP
iptables -I INPUT -s 50.122.226.145 -j ACCEPT

# Set default policy to DROP all packets
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow anything over loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allows all outbound traffic
iptables -A OUTPUT -j ACCEPT

# iptables-persistent takes the work out of maintaining the firewall
# between resets. Performing a save command will save these commands
# for all resets
invoke-rc.d iptables-persistent save > /dev/null 2>&1
