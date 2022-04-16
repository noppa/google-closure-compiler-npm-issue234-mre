#!/bin/bash

if ! [ -f /.dockerenv ]; then
  echo "Run this script inside docker container"
	exit 1
fi

rm -rf .git
git config --global init.defaultBranch main
git config --global user.name "Foo Bar"
git config --global user.email "foo.bar@example.com"
git init
echo "node_modules" > .gitignore

versions=$(npm show google-closure-compiler versions | grep -oE "(2022[0-9.]+-nightly)")

for v in $versions
do
	jq ".dependencies.\"google-closure-compiler\" = \"$v\""
	git add .
	git commit -m "$v"
done

git bisect start

echo "npm install --no-audit --no-lockfile -yq" > run.sh
echo "npm run build" >> run.sh
chmod +x run.sh

git bisect run ./run.sh
