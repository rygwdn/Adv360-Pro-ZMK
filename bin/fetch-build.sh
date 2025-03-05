#!/bin/bash

set -e

build_name="Build ZMK firmware"

rm -f firmware/*

sha=$(git rev-parse --verify HEAD)
run=$(gh run list -c "$sha" --json databaseId,workflowName -q ".[] | select(.workflowName == \"$build_name\") | .databaseId")

if [[ -z $run ]]; then
  echo "No \"${build_name}\" run for $sha"
  exit 1
fi

gh run watch "$run" --exit-status

echo "Fetching build:"
GH_PAGER='' gh run view "$run" --exit-status

gh run download -n firmware -D firmware/ "$run"

echo
echo "Downloaded"
ls -1 firmware/ | sed 's/^/  - /'
