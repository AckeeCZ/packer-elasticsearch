#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "deb https://packages.cloud.google.com/apt google-cloud-ops-agent-$(lsb_release -sc)-all main" > /etc/apt/sources.list.d/google-cloud-ops-agent.list
curl --connect-timeout 5 -s -f "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | apt-key add -
apt-get -qq update
apt-get -y -q install google-cloud-ops-agent=2.21.0~ubuntu20.04

sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
logging:
  receivers:
    elasticsearch_json:
      type: elasticsearch_json
    elasticsearch_gc:
      type: elasticsearch_gc
  service:
    pipelines:
      elasticsearch:
        receivers:
          - elasticsearch_json
          - elasticsearch_gc
metrics:
  receivers:
    elasticsearch:
      type: elasticsearch
  service:
    pipelines:
      elasticsearch:
        receivers:
          - elasticsearch
EOF

rm -Rf /var/lib/apt/lists/*
