#!/bin/bash

INSTALL_DIR=/usr/local/packer
SHASUM=6a6ee79d51909f04f734c15a0e12ebcaba3f2cf4d449906f6a186490774262f9

set -ex

apt-get update -qq
apt-get install -qq -y wget unzip

mkdir -p $INSTALL_DIR

wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_386.zip -O packer.zip

echo "Verifying download integrity..."
sha256sum packer.zip | grep -q "$SHASUM  packer.zip"

unzip packer.zip -d $INSTALL_DIR
