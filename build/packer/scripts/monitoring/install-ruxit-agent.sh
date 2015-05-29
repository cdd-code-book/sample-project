#!/bin/bash -e

apt-get update -yqq
apt-get install -yqq wget

installer_file=ruxit-Agent-Linux-1.69.120.sh

wget -O $installer_file https://znb76824.live.ruxit.com/installer/agent/unix/latest/V4PdQR3avp0QfJ1t

chmod +x $installer_file
./$installer_file
rm $installer_file
