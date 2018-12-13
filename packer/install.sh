#!/bin/bash

apt-get update || echo "this is for VM images only"
apt-get install -y sudo || echo "this is for VM images only"

sudo apt-get -qq update
sudo apt-get install -y wget software-properties-common lsb-release perl curl

wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz -O /tmp/openjdk-10.0.2_linux-x64_bin.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo tar xfvz /tmp/openjdk-10.0.2_linux-x64_bin.tar.gz --directory /usr/lib/jvm
rm -f /tmp/openjdk-10.0.2_linux-x64_bin.tar.gz

sudo sh -c 'for bin in /usr/lib/jvm/jdk-10.0.2/bin/*; do update-alternatives --install /usr/bin/$(basename $bin) $(basename $bin) $bin 100; done'
sudo sh -c 'for bin in /usr/lib/jvm/jdk-10.0.2/bin/*; do update-alternatives --set $(basename $bin) $bin; done'

DEBIAN_FRONTEND=noninteractive  sudo apt-get install -y --no-install-recommends nmap htop pigz ncdu ca-certificates-java
DEBIAN_FRONTEND=noninteractive  sudo apt-get -y dist-upgrade

# Verify Java version
java -version

# Ubuntu equivalent of https://github.com/elastic/elasticsearch-docker/issues/171

sudo ln -sf /etc/ssl/certs/java/cacerts /usr/lib/jvm/jdk-10.0.2/lib/security/cacerts

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.3.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.3.deb.sha512

shasum -a 512 -c elasticsearch-6.4.3.deb.sha512 
sudo dpkg -i elasticsearch-6.4.3.deb

sudo mkdir /etc/systemd/system/elasticsearch.service.d/
echo "[Service]
LimitMEMLOCK=infinity" | sudo tee /etc/systemd/system/elasticsearch.service.d/override.conf

sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b discovery-gce
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b repository-gcs
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b analysis-icu

sudo rm -Rf /usr/share/elasticsearch/modules/x-pack*