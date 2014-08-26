#!/bin/bash

# To download and run
# wget https://raw.githubusercontent.com/masline/scripts/master/install.sh && sudo bash install.sh

# We want the newer packages!
# Add sid to apt sources
echo 'deb http://debian.mirror.frontiernet.net/debian/ sid main contrib non-free' >> /etc/apt/sources.list

# Update package lists
aptitude -q update

# aptitude keeps getting rid of "A"utomatically installed packages...including the kernel!
# Since this is a dev server, just mark them all as manually installed
sudo aptitude unmarkauto '~i'

# Add python3 packages
DEBIAN_FRONTEND=noninteractive aptitude install -y -q python3.4-dev python-imaging python-virtualenv

# sid package `python-pip` tries to remove the kernal! Let's install it differently!
curl -O https://bootstrap.pypa.io/get-pip.py
python3.4 get-pip.py

# Replace python2 with python3 as symlinked python...scratch that, let's not thrash the python name, use `python3`
ln -sf /usr/bin/python3.4 /usr/bin/python3

# Install some newer system packages
aptitude install -y -q build-essential libtext-charwidth-perl libuuid-perl
aptitude install -y -q liblocale-gettext-perl libtext-iconv-perl libxml2-dev
DEBIAN_FRONTEND=noninteractive aptitude install -y -q libssl-dev libjpeg8-dev libpng12-dev libfreetype6-dev
aptitude install -y -q libldap2-dev libmcrypt-dev libxslt-dev
aptitude install -y -q libjpeg8 libjpeg8-dev

# Remove sid
sed -ie '$d' /etc/apt/sources.list

# Lets add in git now
aptitude install -y -q git
