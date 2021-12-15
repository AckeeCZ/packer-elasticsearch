#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "deb https://packages.cloud.google.com/apt google-cloud-ops-agent-$(lsb_release -sc)-all main" > /etc/apt/sources.list.d/google-cloud-op-agent.list
curl --connect-timeout 5 -s -f "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | apt-key add -
apt-get -qq update
apt-get -y -q install google-cloud-ops-agent=2.7.0~ubuntu18.04

echo <<EOF
logging:
  receivers:
    elasticsearch:
      type: files

      include_paths: [/var/log/elasticsearch/*.log]
      exclude_paths: [/var/log/elasticsearch/gc.log]
  processors:
    elasticsearch:
      type: parse_regex
      field:       message
      regex:       "^(\[?<time>[^\]]*)\]\[(?<severity>[^\]]*)\](?<msg>.*)$"
      time_key:    time
      time_format: "%Y-%m-%dT%H:%M:%S,%SSS"
  service:
    pipelines:
      default_pipeline:
        receivers:
          - syslog
          - elasticsearch
        processors:
          - elasticsearch
EOF
>> /etc/google-cloud-ops-agent/config.yaml
rm -Rf /var/lib/apt/lists/*
