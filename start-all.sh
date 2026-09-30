#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
failures=()

if ! docker network inspect testNet >/dev/null 2>&1; then
  docker network create testNet >/dev/null
fi

for service_dir in "$script_dir"/*/; do
  [[ -f "${service_dir}start.sh" ]] || continue
  service_name=$(basename "$service_dir")
  echo "Starting ${service_name}..."
  if (cd "$service_dir" && bash ./start.sh); then
    echo "Started ${service_name}"
  else
    echo "Failed ${service_name}" >&2
    failures+=("$service_name")
  fi
done

if (( ${#failures[@]} > 0 )); then
  echo "Failed services: ${failures[*]}" >&2
  exit 1
fi

echo "All services started"