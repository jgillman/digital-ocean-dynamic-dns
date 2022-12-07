#!/usr/bin/env bash

source ./secrets

response=$(curl \
  --silent \
  -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://api.digitalocean.com/v2/domains/$DOMAIN/records")

if ! command -v jq &> /dev/null; then
    echo $response | grep -Eo '"id":\d*|"type":"\w*"|"data":".*?"'
else
    echo $response | jq .domain_records
fi
