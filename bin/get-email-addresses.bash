#!/usr/bin/env bash

set -e

# grab it
scp -C test.apiaxle.com:/var/log/nginx/emails.log /tmp/emails.log

cat /tmp/emails.log | \
  perl -MURI::Escape -nle '/email=([^&]+)/ and print uri_unescape($1)' | \
  grep '@' | \
  sort | \
  uniq > addresses.csv
