#!/bin/bash

printf "🛫 Let's get you flying with concourse.\n\n"

set -eux
cd "$(dirname "$0")"

sudo apt-get update
sudo apt-get -y install postgresql postgresql-contrib linux-generic-lts-vivid
sudo update-rc.d postgresql enable
set +e
sudo -u postgres createuser -d --superuser ubuntu
createuser --superuser root
createdb atc
set -e
cat <<EOF | sudo tee /etc/postgresql/9.3/main/pg_hba.conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             all                                     peer
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
EOF

wget https://github.com/concourse/concourse/releases/download/v1.1.0/concourse_linux_amd64
sudo install --owner=root --group=root --mode=744 concourse_linux_amd64 /usr/local/sbin/concourse
sudo install --owner=root --group=root --mode=744 ciab /usr/local/sbin/ciab

set +x

printf "\n🛩 Ready to go! Reboot and run 'sudo ciab' to start concourse.\n\n"
