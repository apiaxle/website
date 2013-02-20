#!/usr/bin/env bash

set -e

mkdir -p log

# output the documentation
../apiaxle/api/bin/generate-docs.coffee > api.md

# now commit
git add api.md
git commit -m "Updated documentation via generate-api-docs.bash."

git show HEAD

read -p "Push? (y/n) "
[ "$REPLY" == "y" ] && git push origin gh-pages
