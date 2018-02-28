#!/bin/bash
set -exo pipefail
tshark -i ${NETWORK_INTERFACE:-eth0} -T ek $@ | su logstash -c /usr/local/bin/docker-entrypoint
