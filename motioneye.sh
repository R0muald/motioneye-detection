#!/bin/bash

####
# Configure Raspberry pi with motioneye from a raspbian instance
####

# Update system
apt-get update
apt-get upgrade -y

# Install motioneye
apt-get install ffmpeg libmariadb3 libpq5 libmicrohttpd12 -y
wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
apt-get install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev -y
pip install motioneye
mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
mkdir -p /var/lib/motioneye
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye

# Install npm
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
apt-get install -y nodejs gcc g++ make

# Configure Samba to access video from the network (This will prompt a message to validate)

apt-get install samba samba-common-bin

cat >> /etc/samba/smb.conf <<EOF
[pimylifeupshare]
path = /home/pi/shared
writeable=yes
create mask=0777
directory mask=0777
public=yes
EOF

systemctl restart smbd

# TensorFlow preparation

# apt-get install openjdk-8-jdk automake autoconf -y
# apt-get install curl zip unzip libtool swig libpng-dev zlib1g-dev pkg-config git g++ wget xz-utils -y

# # For python2.7
# apt-get install python-numpy python-dev python-pip python-mock -y

# # if using a virtual environment, omit the --user argument
# pip install -U --user keras_applications==1.0.5 --no-deps
# pip install -U --user keras_preprocessing==1.0.3 --no-deps

# # Make you sure added arm architecture, see how to adds in debian flavors:

# dpkg --add-architecture armhf
# echo "deb [arch=armhf] http://httpredir.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list

# apt-get install libpython-all-dev:armhf

# Configure wifi as bridge
