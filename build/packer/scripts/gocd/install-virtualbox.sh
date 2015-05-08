#!/bin/bash

set -ex

apt-get update -qq
apt-get install -qq -y wget

echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" >> /etc/apt/sources.list

wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

apt-get update -qq
apt-get install -qq -y virtualbox-4.3 dkms

/etc/init.d/vboxdrv setup
