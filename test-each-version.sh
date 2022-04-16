#!/bin/bash

if ! [ -f /.dockerenv ]; then
  echo "Run this script inside docker container"
	exit 1
fi

rm -rf .git
git config --global init.defaultBranch main
git config --global user.name "Foo Bar"
git config --global user.email "foo.bar@example.com"
git init -q

echo "node_modules" > .gitignore
echo "run.sh" >> .gitignore

git add .
git commit -qm "Init"

mirror_date="2022-03-01"
end="2022-04-16"

while ! [[ "$mirror_date" > "$end" ]]; do
  echo "Server=https://archive.archlinux.org/repos/$(echo "$mirror_date" | sed 's/-/\//g')/\$repo/os/\$arch" \
		> mirrorlist
	git add .
	git commit -qm "$mirror_date"
	mirror_date=$(date -d "$mirror_date + 1 day" +%F)
done

git bisect start

cat <<"EOT" > run.sh
#!/bin/bash

the_date=$(git --no-pager show -s --format=%s)
cp ./mirrorlist /etc/pacman.d/mirrorlist
pacman -Suuyy --noconfirm
npx google-closure-compiler index.js
if [ $? -eq 0 ]; then
  echo "$the_date looks fine"
	exit 0
else
	echo "$the_date is broken"
	exit 1
fi
EOT
chmod +x run.sh

git bisect start
git bisect bad HEAD
git bisect good $(git rev-list --max-parents=0 HEAD)
git bisect run ./run.sh
echo "First broken date:"
git --no-pager show -s --format=%s
