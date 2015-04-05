#!/bin/bash -e

if [ -z "$TEMP_SERVER_PATH" ] ; then
  echo "Environment variable TEMP_SERVER_PATH must be defined"
  exit 1
fi

if [ -z "$SERVER_PATH" ] ; then
  echo "Environment variable SERVER_PATH must be defined"
  exit 1
fi

if [ -z "$SERVER_OWNER" ] ; then
  echo "Environment variable SERVER_OWNER must be defined"
  exit 1
fi

# Move uploaded server files to where we want them to be

mkdir -p $SERVER_PATH

# Exclude files/directories specified in .gitignore
files_to_transfer=$(ls -1 $TEMP_SERVER_PATH | grep -f $TEMP_SERVER_PATH/.gitignore -v)

for file in $files_to_transfer ; do
  mv $TEMP_SERVER_PATH/$file $SERVER_PATH
done

# Cleanup whatever remains
rm -rf $TEMP_SERVER_PATH

# Install system dependencies
# Fix hash sum mismatch problems that occur when performing apt-get update
rm -r /var/lib/apt/lists/*

apt-get update -yqq

apt-get install -yqq build-essential libssl-dev jq


# Install nvm and node.js
curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash

source ~/.nvm/nvm.sh

# Get exact version of node specified in package.json
node_version=$(jq --raw-output .engines.node $SERVER_PATH/package.json)

nvm install $node_version
nvm alias default $node_version

# Set up handy symlink to node.js
node_executable=$(nvm which default)

ln -s $node_executable /usr/bin/node


# Install server dependencies
cd $SERVER_PATH
npm install --silent


chmod -R 0500 $SERVER_PATH
chown -R $SERVER_OWNER:$SERVER_OWNER $SERVER_PATH


# Run as service
mv /tmp/cdd-webserver.conf /etc/init
