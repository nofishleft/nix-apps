#!/usr/bin/env sh

NIXPKGS_ALLOW_UNFREE=1 nix build --impure .#jammer.fetch-deps
./result $(pwd)/jammer/deps.json
