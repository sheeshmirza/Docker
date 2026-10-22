#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "Stopping all services..."
"$script_dir/stop-all.sh"

echo "Resetting volume data..."
if docker volume inspect testVol >/dev/null 2>&1; then
  echo "Removing volume testVol..."
  docker volume rm testVol >/dev/null
fi

legacy_vols=$(docker volume ls -q --filter name='_testVol$' 2>/dev/null || true)
if [[ -n "$legacy_vols" ]]; then
  echo "Removing legacy local volumes..."
  docker volume rm $legacy_vols >/dev/null 2>&1 || true
fi

echo "Recreating and starting all services..."
"$script_dir/start-all.sh"

echo "All services reset and recreated"
