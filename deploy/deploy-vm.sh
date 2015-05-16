#!/bin/bash

# Quick and dirty deployment script
# No hot swapping, there will be downtime

if [ -z "$VM_NAME" ] ; then
  echo "Environment variable VM_NAME must be defined"
  exit 1
fi

if [ -z "$VM_DIRECTORY" ] ; then
  echo "Environment variable VM_DIRECTORY must be defined"
  exit 1
fi

set -ex

# Clean if it already exists, ignore if it doesn't
VBoxManage unregistervm --delete $VM_NAME 2> /dev/null || true

VBoxManage import $VM_DIRECTORY/$VM_NAME.ovf

VBoxManage startvm $VM_NAME
