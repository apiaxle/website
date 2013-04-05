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

git diff --patience HEAD..HEAD~1

read -p "Push? (y/n) "
[ "$REPLY" == "y" ] && git push origin gh-pages
