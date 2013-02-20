#!/usr/bin/env bash

set -e

mkdir -p log

here="$(pwd)"

pushd ../apiaxle/api
./bin/generate-docs.coffee > "${here}/api.md"
popd

# now commit
git add api.md
git commit -m "Updated documentation via generate-api-docs.bash."

git show HEAD

read -p "Push? (y/n) "
[ "$REPLY" == "y" ] && git push origin gh-pages
