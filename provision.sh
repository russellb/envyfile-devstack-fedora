#!/bin/bash

# Skip ssh new host check.
cat<<EOF | tee ~/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF

sudo yum update -y
sudo yum install -y git python-netaddr vim-enhanced

git clone https://github.com/openstack-dev/devstack.git

cd devstack/

cat<<EOF | tee localrc
MYSQL_PASSWORD=secret
SERVICE_TOKEN=secret
SERVICE_PASSWORD=secret
ADMIN_PASSWORD=secret

disable_service rabbit
enable_service qpid
EOF

./stack.sh
