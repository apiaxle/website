#!/usr/bin/env bash

set -e

# grab it
scp -C test.apiaxle.com:/var/log/email-collector.log /tmp/email-collector.log
scp -C test.apiaxle.com:/var/log/email-collector-ssl.log /tmp/email-collector-ssl.log

cat /tmp/email-collector.log /tmp/email-collector-ssl.log | \
  perl -MURI::Escape -nle '/email=([^&]+)/ and print uri_unescape($1)' | \
  grep '@' | \
  sort | \
  uniq > addresses.csv
