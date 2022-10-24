#!/bin/bash

USERNAME="***********"
PW="***********"

BEARER=$(curl -s 'https://apis.reolink.com/v1.0/oauth2/token/' \
  -H 'origin: https://my.reolink.com' \
  --data-urlencode "username=$USERNAME" \
  --data-urlencode "password=$PW" \
  --data 'grant_type=password&session_mode=true&client_id=REO-.AJ%2CHO%2FL6_TG44T78KB7&mfa_trusted=false' \
 | jq -r '.access_token')

STARTDATE=$(date -d "-1 day" +"%s")
ENDDATE=$(date +"%s")

LATEST=$(curl -s "https://apis.reolink.com/v2/videos/?start_at=${STARTDATE}000&end_at=${ENDDATE}514&data_type=create_at&page=1&count=1" \
  -H "authorization: Bearer $BEARER" \
  -H 'origin: https://cloud.reolink.com' \
  | jq .items[])

id=$(echo "$LATEST" | jq -r '.id')
createdAt=$(echo "$LATEST" | jq -r '.createdAt')
coverUrl=$(echo "$LATEST" | jq -r '.coverUrl')
createdAtCut=$(echo "$createdAt" | rev | cut -c4- | rev)
createdAtHuman=$(date +"%Y-%m-%d-$id-%T" -d @"$createdAtCut")

export LATEST BEARER id createdAt coverUrl createdAtCut createdAtHuman

wget -q -O /tmp/"$createdAtHuman".jpg "$coverUrl"
