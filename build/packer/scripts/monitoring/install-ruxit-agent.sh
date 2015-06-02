#!/bin/bash -e

if [ -z "$RUXIT_AGENT_DOWNLOAD_URI" ] ; then
  echo "Environment variable RUXIT_AGENT_DOWNLOAD_URI must be defined"
  exit 1
fi

apt-get update -yqq
apt-get install -yqq wget

installer_file=ruxit-agent.sh

wget -O $installer_file $RUXIT_AGENT_DOWNLOAD_URI

chmod +x $installer_file
./$installer_file
rm $installer_file
