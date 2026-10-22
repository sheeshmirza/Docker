#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
failures=()

compose() {
  if command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    docker compose "$@"
  fi
}

for service_dir in "$script_dir"/*/; do
  [[ -f "${service_dir}docker-compose.yaml" || -f "${service_dir}docker-compose.yml" ]] || continue
  service_name=$(basename "$service_dir")
  echo "Stopping ${service_name}..."
  if (cd "$service_dir" && compose down); then
    echo "Stopped ${service_name}"
  else
    echo "Failed to stop ${service_name}" >&2
    failures+=("$service_name")
  fi
done

if (( ${#failures[@]} > 0 )); then
  echo "Failed services: ${failures[*]}" >&2
  exit 1
fi

echo "All services stopped"
