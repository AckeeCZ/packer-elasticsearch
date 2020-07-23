#!/bin/bash

set -ue -o pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y --no-install-recommends nmap htop pigz ncdu apt-transport-https
sudo apt-get -y dist-upgrade
ES_VERSION=7.8.0

wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION-amd64.deb
wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION-amd64.deb.sha512
shasum -a 512 -c elasticsearch-$ES_VERSION-amd64.deb.sha512
sudo dpkg -i elasticsearch-$ES_VERSION-amd64.deb

sudo mkdir /etc/systemd/system/elasticsearch.service.d/
echo "[Service]
LimitMEMLOCK=infinity" | sudo tee /etc/systemd/system/elasticsearch.service.d/override.conf

sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b discovery-gce
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b repository-gcs
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b analysis-icu
