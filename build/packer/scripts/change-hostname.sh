#!/bin/bash

if [ -z "$OLD_HOSTNAME" ] ; then
  echo "Environment variable OLD_HOSTNAME must be defined"
  exit 1
fi

if [ -z "$NEW_HOSTNAME" ] ; then
  echo "Environment variable NEW_HOSTNAME must be defined"
  exit 1
fi

set -ex

sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname
