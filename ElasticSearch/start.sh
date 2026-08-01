#!/usr/bin/env bash

set -euo pipefail

compose() {
  if command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    docker compose "$@"
  fi
}

compose down --remove-orphans
compose up --build -d
