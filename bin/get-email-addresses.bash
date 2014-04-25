#!/usr/bin/env bash

set -e

tmp=$(mktemp -d)

pushd "${tmp}"

# grab em
scp -C test.apiaxle.com:/var/log/nginx/emails* .

for f in *.gz; do
  gunzip "${f}"
done

cat * | \
  perl -MURI::Escape -nle '/email=([^&]+)/ and print uri_unescape($1)' | \
  grep '@' | \
  sort | \
  uniq > addresses.csv

echo "${tmp}/addresses.csv"
