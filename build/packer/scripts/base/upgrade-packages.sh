#!/bin/bash

# Fix hash sum mismatch problems that occur when performing apt-get update
rm -r /var/lib/apt/lists/*

apt-get update -yqq
apt-get upgrade -yqq
