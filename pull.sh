#!/bin/bash

set -e

if [ $# -ne 1 ]; then
  echo "usage: pull.sh images.txt"
  exit 1
fi

while IFS='' read -r image || [[ -n "$image" ]]; do
  target=lixinio/$(basename $image)
  echo "Pulling $image ..."
  docker pull $image
  docker tag $image $target
  docker push $target
done < "$1"
