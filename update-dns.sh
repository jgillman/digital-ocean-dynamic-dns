#!/usr/bin/env bash

[ ! -f ./secrets ] && \
  echo 'secrets file is missing!' && \
  exit 1

source ./secrets

# Exit if the RECORD_IDS array has no elements
[ ${#RECORD_IDS[@]} -eq 0 ] && \
  echo 'RECORD_IDS are missing!' && \
  exit 1

# Function to check if the ACCESS_TOKEN is valid
check_credentials() {
  response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer ${ACCESS_TOKEN}" "https://api.digitalocean.com/v2/account")
  if [ "$response" != "200" ]; then
    echo "Invalid credentials. Please check your ACCESS_TOKEN."
    exit 1
  fi
}

# Check credentials before proceeding
check_credentials


public_ip=$(curl -s http://checkip.amazonaws.com/)

for ID in "${RECORD_IDS[@]}"; do
  local_ip=$(
    curl \
      --fail \
      --silent \
      -X GET \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${ACCESS_TOKEN}" \
      "https://api.digitalocean.com/v2/domains/${DOMAIN}/records/${ID}" | \
      grep -Eo '"data":".*?"' | \
      grep -Eo '+[0-9]\.[0-9]+\.[0-9]+\.[0-9]+'
  )

  # if the IPs are the same just exit
  [ "$local_ip" == "$public_ip" ] && exit 0

  echo "Updating DNS with new IP address: ${public_ip}"

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
