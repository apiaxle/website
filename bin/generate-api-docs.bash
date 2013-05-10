#!/usr/bin/env bash

set -e

mkdir -p log

here="$(pwd)"

pushd ../apiaxle/api
(
  echo "---"
  echo "layout: apidocs"
  echo "title: Api documentation"
  echo "---"

  ./bin/generate-docs.coffee
) > "${here}/api.html"
popd

# now commit
git add api.html
git commit -m "Updated documentation via generate-api-docs.bash."

git diff --patience HEAD~1..HEAD

read -p "Push? (y/n) "
[ "$REPLY" == "y" ] && git push origin gh-pages
