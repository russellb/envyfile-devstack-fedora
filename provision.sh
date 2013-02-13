#!/bin/bash

# Skip ssh new host check.
cat<<EOF | tee ~/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF

sudo yum update -y
sudo yum install -y git python-netaddr

git clone https://github.com/openstack-dev/devstack.git

cd devstack/

# Disable the qpid notifier in glance until this bug is fixed:
# https://bugs.launchpad.net/glance/+bug/1100317
sed -i -e 's/\(iniset $GLANCE_API_CONF DEFAULT notifier_strategy qpid\)/: # \1/' lib/glance

cat<<EOF | tee localrc
MYSQL_PASSWORD=secret
SERVICE_TOKEN=secret
SERVICE_PASSWORD=secret
ADMIN_PASSWORD=secret

disable_service rabbit
enable_service qpid
EOF

./stack.sh
