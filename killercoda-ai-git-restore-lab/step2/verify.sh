#!/bin/bash
set -euo pipefail

WORKDIR="/root/lab/workspace"

test -d "$WORKDIR/.git"
test ! -e "$WORKDIR/.git_disabled"

status="$(git -C "$WORKDIR" status --short)"
if [ -n "$status" ]; then
  echo "Working tree is not clean."
  echo "$status"
  exit 1
fi

git -C "$WORKDIR" rev-parse --is-inside-work-tree >/dev/null
echo "Verification passed."
