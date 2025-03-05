#!/bin/bash

rm firmware/*
sha=$(git rev-parse --verify HEAD)
run=$(gh run list -c "$sha" --json databaseId -q '.[0].databaseId')
gh run download -n firmware -D firmware/ "$run"
