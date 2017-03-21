#!/usr/bin/env bash
set -ex

# This script will automatically install nomad, put it in /usr/local/bin, and create /etc/nomad.d directory
NOMAD_VER=0.5.5
HOSTNAME=`hostname`
LOCAL_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
DATACENTER=`curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_linux_amd64.zip -o /tmp/nomad.zip
HASHI_SOURCE_SHA256SUM=`curl https://releases.hashicorp.com/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_SHA256SUMS | grep nomad_${NOMAD_VER}_linux_amd64.zip | awk -F' ' '{print $1}'`
DOWNLOAD_SHA256SUM=`sha256sum /tmp/nomad.zip | awk -F' ' '{print $1}'`

if [[ "${DOWNLOAD_SHA256SUM}" != "${HASHI_SOURCE_SHA256SUM}" ]]
then
  echo "The SHA256 for your download does not match the source-provided checksum. Exiting."
  exit 1
fi
unzip -d /tmp /tmp/nomad.zip
chmod 755 /tmp/nomad
mv /tmp/nomad /usr/local/bin/
if [ ! -d /opt/nomad ]
then
  mkdir -p /opt/nomad/config && mkdir /opt/nomad/data
fi

#######################
# Nomad Server Config #
#######################

touch /opt/nomad/config/server.hcl
cat > /opt/nomad/config/server.hcl <<EOF
bind_addr = "0.0.0.0"

log_level = "DEBUG"

data_dir = "/opt/nomad"

name = "$HOSTNAME"

server {
  enabled = true
  bootstrap_expect = 3
}
advertise {
  http = "$LOCAL_IP"
  rpc = "$LOCAL_IP"
  serf = "$LOCAL_IP"
}
consul {
  # The address to the Consul agent.
  address = "127.0.0.1:8500"

  # The service name to register the server with Consul.
  server_service_name = "nomad"

  # Enables automatically registering the services.
  auto_advertise = true

  # Enabling the server to bootstrap using Consul.
  server_auto_join = true
}
EOF

tee /etc/init/nomad.conf > /dev/null <<EOF
description "Nomad"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
console log
script
  if [ -f "/etc/service/nomad" ]; then
    . /etc/service/nomad
  fi
  exec /usr/local/bin/nomad agent \
    -config="/opt/nomad/config/server.hcl" \
    >>/var/log/nomad.log 2>&1
end script
EOF

#######################################
# START SERVICES
#######################################

service nomad start
