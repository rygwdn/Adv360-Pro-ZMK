#!/bin/bash

build_name="Build ZMK firmware"

rm -f firmware/*

sha=$(git rev-parse --verify HEAD)
run=$(gh run list -c "$sha" --json databaseId,workflowName -q ".[] | select(.workflowName == \"$build_name\") | .databaseId")

if [[ -z $run ]]; then
  echo "No \"${build_name}\" run for $sha"
  exit 1
fi

if ! gh run download -n firmware -D firmware/ "$run"; then
  exit 1
fi

echo "Fetched build:"
GH_PAGER='' gh run view "$run"
