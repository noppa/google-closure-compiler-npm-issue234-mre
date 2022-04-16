#!/bin/sh

variant="$1"

if ! [ "$variant" = "ubuntu" ] && ! [ "$variant" = "arch" ]; then
	echo "Usage: $0 [ubuntu|arch]"
	exit 1
fi

img="google-closure-compiler-issue234-$variant"
echo "Building image $img"

scriptdir=$(basename "$0")
cd scriptdir

docker build -t "$img" -f "Dockerfile.$variant" .
docker run -t "$img"
