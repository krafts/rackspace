#!/bin/bash

export RACKSPACE_API_TOKEN=$(curl -s -H "Accept: application/json" -H "Content-Type: application/json"  --data "{\"auth\":{\"RAX-KSKEY:apiKeyCredentials\":{\"username\": \"$(grep username ~/.rackspace_cloud_credentials | sed 's/username = //g')\",\"apiKey\": \"$(grep api_key ~/.rackspace_cloud_credentials | sed 's/api_key = //g')\"}}}" https://identity.api.rackspacecloud.com/v2.0/tokens | python -m json.tool | grep -C3 APIKEY | grep id | sed 's/,//g' | sed 's/"//g' | sed 's/id: //g' | sed 's/ //g') && echo "export RACKSPACE_API_TOKEN=$RACKSPACE_API_TOKEN"
