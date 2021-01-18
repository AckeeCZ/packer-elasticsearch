#!/bin/bash

set -ue -o pipefail

export DEBIAN_FRONTEND=noninteractive

# Wait for cloud-init to deply local mirror in /etc/apt/sources.list
# https://github.com/hashicorp/packer/issues/41#issuecomment-21288589
until grep -q "gce" /etc/apt/sources.list; do
  echo "searching for gce string in apt sources"
  sleep 5
done

apt-get update
apt-get install -y --no-install-recommends nmap htop pigz ncdu apt-transport-https
apt-get -y dist-upgrade

wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION-amd64.deb
wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION-amd64.deb.sha512
shasum -a 512 -c elasticsearch-$ES_VERSION-amd64.deb.sha512
dpkg -i elasticsearch-$ES_VERSION-amd64.deb

mkdir /etc/systemd/system/elasticsearch.service.d/
echo "[Service]
LimitMEMLOCK=infinity" > /etc/systemd/system/elasticsearch.service.d/override.conf

/usr/share/elasticsearch/bin/elasticsearch-plugin install -b discovery-gce
/usr/share/elasticsearch/bin/elasticsearch-plugin install -b repository-gcs
/usr/share/elasticsearch/bin/elasticsearch-plugin install -b analysis-icu

mv /tmp/cleanup.sh /etc/cron.daily/
