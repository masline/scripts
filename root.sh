#!/bin/bash

# To download and run
# wget https://raw.githubusercontent.com/masline/scripts/master/root.sh && bash root.sh

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

# Allows all outbound traffic
iptables -A OUTPUT -j ACCEPT

# iptables-persistent takes the work out of maintaining the firewall
# between resets. Performing a save command will save these commands
# for all resets
invoke-rc.d iptables-persistent save > /dev/null 2>&1

############################
# Create users with SSH keys
############################
for user in $(curl -s https://raw.githubusercontent.com/masline/scripts/master/users); do
	# Add user
	useradd --create-home --groups sudo $user
	# Create .ssh directory and files for key-based authentication
	mkdir /home/$user/.ssh
	touch /home/$user/.ssh/authorized_keys
	# Take care of ownership and permissions for the specific user
	chmod 700 /home/$user/.ssh
	chmod 400 /home/$user/.ssh/authorized_keys
	chown $user:$user /home/$user/.ssh
	chown $user:$user /home/$user/.ssh/authorized_keys
	chattr +i /home/$user/.ssh/authorized_keys
	chattr +i /home/$user/.ssh
	# Fill in `authorized_keys` with users public key
	echo $(curl -s https://raw.githubusercontent.com/masline/scripts/master/$user.pub) > /home/$user/.ssh/authorized_keys
done

# /bin/sh sucks, replace all instances in /etc/passwd with /bin/bash
sed -i 's:/bin/sh:/bin/bash:' /etc/passwd

# Remove ! from /etc/shadow to allow local user to change password
sed -i 's/:!:/::/' /etc/shadow
