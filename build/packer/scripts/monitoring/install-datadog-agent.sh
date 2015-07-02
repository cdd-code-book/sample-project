#!/bin/bash -e

if [ -z "$DD_API_KEY" ] ; then
  echo "Environment variable DD_API_KEY is not defined, skipping agent install"
  exit 0
fi

apt-get update -yqq
apt-get install -yqq curl

curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh
