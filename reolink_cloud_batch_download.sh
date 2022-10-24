#!/bin/bash

USERNAME="***********"
PW="***********"

BEARER=$(curl -s 'https://apis.reolink.com/v1.0/oauth2/token/' \
  -H 'origin: https://my.reolink.com' \
  --data-urlencode "username=$USERNAME" \
  --data-urlencode "password=$PW" \
  --data 'grant_type=password&session_mode=true&client_id=REO-.AJ%2CHO%2FL6_TG44T78KB7&mfa_trusted=false' \
 | jq -r '.access_token')

YESTERDAY=$(date -d "-1 day" +"%Y-%m-%d")
STARTDATE=$(date -d "-1 day" +"%s")
ENDDATE=$(date +"%s")
DESTDIR="/tmp/$YESTERDAY"
mkdir -p "$DESTDIR"

LATEST=$(curl -s "https://apis.reolink.com/v2/videos/?start_at=${STARTDATE}000&end_at=${ENDDATE}514&data_type=create_at&page=1&count=10000" \
  -H "authorization: Bearer $BEARER" \
  -H 'origin: https://cloud.reolink.com' \
  --compressed | jsonlint)

getVideoURL() {
VIDEODOWNLOADURL=$(curl -s "https://apis.reolink.com/v2/videos/$videoid/url?type=download" \
  -H "authorization: Bearer $BEARER" \
  -H 'origin: https://cloud.reolink.com' \
  | jq -r .url)
}

count=$(echo "$LATEST" | jq '.items | length')
for ((i=0; i<"$count"; i++)); do
    videoid=$(echo "$LATEST" | jq -r '.items['$i'].id')
    createdAt=$(echo "$LATEST" | jq -r '.items['$i'].createdAt')
    createdAtCut=$(echo "$createdAt" | rev | cut -c4- | rev)
    coverUrl=$(echo "$LATEST" | jq -r '.items['$i'].coverUrl')
    createdAtHuman=$(date +"%Y-%m-%d-$videoid-%T" -d @"$createdAtCut")
    echo "ID: $videoid  createdAt timestamp: $createdAtHuman"
    wget -O "$DESTDIR"/"$createdAtHuman".jpg "$coverUrl"
    getVideoURL
    echo "$VIDEODOWNLOADURL"
    wget -O "$DESTDIR"/"$createdAtHuman".mp4 "$VIDEODOWNLOADURL"
done
