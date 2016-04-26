#!/bin/bash

. ~/scripts/get_rackspace_api_token.sh

typeset rackspace_account=$(grep OS_PROJECT_ID ~/.rackspace_project_creds  | awk -F'=' '{print $2}')

curl -s -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: $RACKSPACE_API_TOKEN" -H "Content-Length: 0" "https://dns.api.rackspacecloud.com/v1.0/$rackspace_account/domains" | python -m json.tool | grep id | awk '{print $2}' | sed 's/,//g'| while read domain; do file=~/dns_entries_$domain.txt; rm -vf "$file"; touch "$file"; i=0; while true; do offset=$(($i*100)); echo "$domain: fetching for offset $offset, total entries $totalEntries"; totalEntries=$(curl -s -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: $RACKSPACE_API_TOKEN" -H "Content-Length: 0" "https://dns.api.rackspacecloud.com/v1.0/$rackspace_account/domains/$domain/records?limit=100&offset=$offset" | python -m json.tool | tee -a "$file" | grep totalEntries | sed 's/    "totalEntries": //g'); if [ $offset -gt $totalEntries ]; then break; fi;  i=$(($i+1)); sleep 6; done; done;

