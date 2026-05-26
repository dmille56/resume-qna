#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec nix run "$ROOT_DIR#install" -- "$@"
