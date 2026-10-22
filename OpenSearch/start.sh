#!/usr/bin/env bash

set -euo pipefail

if ! docker network inspect testNet >/dev/null 2>&1; then
  docker network create testNet >/dev/null
fi

if ! docker volume inspect testVol >/dev/null 2>&1; then
  docker volume create testVol >/dev/null
fi

compose() {
  if command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    docker compose "$@"
  fi
}

compose down --remove-orphans
compose up --build -d
