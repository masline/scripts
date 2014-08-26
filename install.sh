#!/bin/bash

# To download and run
# wget https://raw.githubusercontent.com/masline/scripts/master/install.sh && sudo bash install.sh

# We want the newer packages!
# Add sid to apt sources
echo 'deb http://debian.mirror.frontiernet.net/debian/ sid main contrib non-free' >> /etc/apt/sources.list

# Update package lists
aptitude -q update

# Add python3 packages
aptitude install -y -q python3.4-dev python-pip python-imaging

# Replace python2 with python3 as symlinked python
ln -sf /usr/bin/python3.4 /usr/bin/python

# Install some newer system packages
aptitude install -y -q build-essential libtext-charwidth-perl libuuid-perl 
aptitude install -y -q liblocale-gettext-perl libtext-iconv-perl libxml2-dev 
aptitude install -y -q libssl-dev libjpeg8-dev libpng12-dev libfreetype6-dev 
aptitude install -y -q libldap2-dev libmcrypt-dev libxslt-dev
aptitude install -y -q libjpeg8 libjpeg8-dev build-dep 

# Remove sid
sed -ie '$d' /etc/apt/sources.list

# Lets add in git now
aptitude install -y -q git
