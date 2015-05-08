#!/bin/bash

INSTALL_DIR=/usr/local/packer
SHASUM=8fab291c8cc988bd0004195677924ab6846aee5800b6c8696d71d33456701ef6

set -ex

apt-get update -qq
apt-get install -qq -y wget

mkdir -p $INSTALL_DIR

wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip -O packer.zip

echo "Verifying download integrity..."
sha256sum packer.zip | grep -q "$SHASUM  packer.zip"

unzip packer.zip -d $INSTALL_DIR
