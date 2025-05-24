#!/usr/bin/env sh

nix build --impure .#jammer.fetch-deps
./result $(pwd)/jammer/deps.json
