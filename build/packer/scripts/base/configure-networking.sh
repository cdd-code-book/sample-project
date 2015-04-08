#/bin/bash -eux

# Required in order for VM networking to work
#
# Borrowed from: https://github.com/chef/bento/blob/master/packer/scripts/ubuntu/networking.sh
#
# Copyright 2012-2014, Chef Software, Inc. (<legal@chef.io>)
# Copyright 2011-2012, Tim Dysinger (<tim@dysinger.net>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Subject to Apache 2.0 license: https://github.com/chef/bento/blob/master/LICENSE
#
# See for more information: https://github.com/chef/bento

rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /dev/.udev/ /var/lib/dhcp/*
echo "pre-up sleep 2" >> /etc/network/interfaces
