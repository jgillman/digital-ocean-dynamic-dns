#!/usr/bin/env bash

[ ! -f ./secrets ] && \
  echo 'secrets file is missing!' && \
  exit 1

source ./secrets

# Exit if the RECORD_IDS array has no elements
[ ${#RECORD_IDS[@]} -eq 0 ] && \
  echo 'RECORD_IDS are missing!' && \
  exit 1

if [[ "${IP_SERVICE}" == "AWS" ]]; then
  public_ip=$(curl -s http://checkip.amazonaws.com/)
elif [[ "${IP_SERVICE}" == "IPINFO" ]]; then
  public_ip=$(curl -s http://ipinfo.io/ip)
fi

for ID in "${RECORD_IDS[@]}"; do
  curl_response=$(
    curl \
    --fail \
    --silent \
    -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    "https://api.digitalocean.com/v2/domains/${DOMAIN}/records/${ID}"
  )
  if ! command -v jq &> /dev/null; then
    local_ip=$(
      echo "${curl_response}" | \
        grep -Eo '"data":".*?"' | \
        grep -Eo '+[0-9]\.[0-9]+\.[0-9]+\.[0-9]+'
    )
  else
    local_ip=$(
      echo "${curl_response}" | \
      jq -r '.domain_record.data'
    )
  fi
  
  # if the IPs are the same just exit
  if [[ "$local_ip" == "$public_ip" ]]; then
    echo "IP is unchanged. Exiting..."
    exit 0
  fi

  echo "Updating DNS with new IP address: ${public_ip} - IP address was: ${local_ip}"

  # --fail silently on server errors
  curl \
    --fail \
    --silent \
    --output /dev/null \
    -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -d "{\"data\": \"${public_ip}\"}" \
    "https://api.digitalocean.com/v2/domains/${DOMAIN}/records/${ID}"

done
