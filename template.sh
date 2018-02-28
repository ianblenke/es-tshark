#!/bin/bash

ES_HOST=${ES_HOST:-localhost:9200}
CREDS=${CREDS:--u ${ES_USER}:${ES_PASSWORD}}

if [ -n "$DELETE_EXISTING_TEMPLATE" ]; then
  curl -sXDELETE ${CREDS} 'http://'$ES_HOST'/_template/pcap-template'
fi

if [ -n "$DELETE_ALL_INDEXES" ]; then
  curl -sXGET ${CREDS} 'http://'$ES_HOST'/_cat/indices?v' | grep pcap | while read line; do
    index="$(echo $line | awk '{print $3}')"
    curl -sXDELETE ${CREDS} 'http://'$ES_HOST'/'$index
  done
fi

exec curl -H "Content-Type: application/json" -sXPUT ${CREDS} 'http://'$ES_HOST'/_template/pcap-template' --data-binary '{
    "template": "pcap-*",
    "index.mapping.total_fields.limit" : "5000",
    "index.highlight.max_analyzed_offset": 100000
}'
