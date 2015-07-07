#!/bin/bash -e

SHASUM=c820160e728188cb915a8248707128f83efa1668c66c8b275d7240bcc1a60f5f

if [ -z "$DD_API_KEY" ] ; then
  echo "Environment variable DD_API_KEY is not defined, skipping agent install"
  exit 0
fi

set -ex

apt-get update -yqq
apt-get install -yqq wget

wget https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh -O install_dd_agent.sh

echo "Verifying download integrity..."
sha256sum install_dd_agent.sh | grep -q "$SHASUM  install_dd_agent.sh"

chmod +x install_dd_agent.sh
./install_dd_agent.sh
rm install_dd_agent.sh
