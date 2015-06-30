#!/bin/bash

echo "export LOGGLY_TOKEN=$LOGGLY_TOKEN" > /etc/default/cdd-webserver
echo "export LOGGLY_SUBDOMAIN=$LOGGLY_SUBDOMAIN" >> /etc/default/cdd-webserver
