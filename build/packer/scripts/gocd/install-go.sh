#!/bin/bash

if [ -z "$GO_SERVER_PACKAGE_URL" ] ; then
  echo "Environment variable GO_SERVER_PACKAGE_URL must be defined"
  exit 1
fi

if [ -z "$GO_AGENT_PACKAGE_URL" ] ; then
  echo "Environment variable GO_AGENT_PACKAGE_URL must be defined"
  exit 1
fi

set -ex

# Prerequisites
apt-get install -qq -y git make unzip openjdk-6-jre

# Install server and agent packages
echo "deb http://dl.bintray.com/gocd/gocd-deb/ /" >> /etc/apt/sources.list

# Ignore Go package authentication errors - bit of a hack and not exactly secure!
apt-get update -qq || true
apt-get install -qq --allow-unauthenticated --force-yes go-server=14.4.0-1356 go-agent=14.4.0-1356

# Add packer to the go-agent PATH
echo 'export PATH=/usr/local/packer:$PATH' >> /etc/default/go-agent
