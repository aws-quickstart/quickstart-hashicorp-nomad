#!/usr/bin/env bash
set -ex

# This script will automatically install nomad, put it in /usr/local/bin, and create /etc/nomad.d directory
NOMAD_VER=0.8.4
HOSTNAME=`hostname`
LOCAL_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
DATACENTER=`curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F'"' '{print $4}'`
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_linux_amd64.zip -o /tmp/nomad.zip
HASHI_SOURCE_SHA256SUM=`curl https://releases.hashicorp.com/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_SHA256SUMS | grep nomad_${NOMAD_VER}_linux_amd64.zip | awk -F' ' '{print $1}'`
DOWNLOAD_SHA256SUM=`sha256sum /tmp/nomad.zip | awk -F' ' '{print $1}'`

if [[ "${DOWNLOAD_SHA256SUM}" != "${HASHI_SOURCE_SHA256SUM}" ]]
then
  echo "The SHA256 for your download does not match the source-provided checksum. Exiting."
  exit 1
fi
unzip -d /tmp /tmp/nomad.zip
mv /tmp/nomad /usr/local/bin/
chmod 0755 /usr/local/bin/nomad && chown root:root /usr/local/bin/nomad
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
EOF

tee /etc/systemd/system/nomad.service > /dev/null <<EOF
[Unit]
Description=Nomad
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/nomad agent -config="/opt/nomad/config"
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

#######################################
# START SERVICES
#######################################

systemctl start nomad
