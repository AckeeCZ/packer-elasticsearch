#!/bin/bash

set -ue -o pipefail

apt-get -y autoremove
apt-get clean

