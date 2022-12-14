#!/bin/bash

set -o pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color
WEBHOOK_PORT=6060

# Creating public Ngrok endpoint for webhook URL
echo -n Starting ngrok..
ngrok http $WEBHOOK_PORT >> /dev/null &

until curl -m 1 -q http://127.0.0.1:4040/api/tunnels 2> /dev/null | jq -M -r -e '.tunnels[0].public_url' > /dev/null 2>&1
do
  echo -n "."
  sleep 1
done
NGROK_HOST="$(curl -m 1 -s http://127.0.0.1:4040/api/tunnels 2> /dev/null | jq -M -r '.tunnels[0].public_url' | cut -d'/' -f3)"

export WEBHOOK_URL="https://${NGROK_HOST}"
export DOMAIN_DID="QCZWLa5WntwbqGXnuoLDeX"
export VERITY_URL="https://vas.pps.evernym.com"
export X_API_KEY="HZKr2TH3Vu88fAfS8jYZ7oUMhgDgpm6UwjA33371R8HX:491JHWREyrorph9yqwsEEv9KRXZr6M6j6dD4D5uvc7u86fXAeVsMQArPrKyr71Hh9UY9feSSbv5UVUATRQ2eS1Zm"
export CREDENTIAL_DEFINITION_ID="7MXRWDen2pkBnaMnznEuS4:3:CL:120754:latest"

echo
printf "VERITY_URL: ${GREEN}${VERITY_URL}${NC}\n"
printf "X_API_KEY: ${GREEN}${X_API_KEY}${NC}\n"
printf "DOMAIN_DID: ${GREEN}${DOMAIN_DID}${NC}\n"
printf "WEBHOOK_URL: ${GREEN}${WEBHOOK_URL}${NC}\n"
echo

node main.js
