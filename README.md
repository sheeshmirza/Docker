# 🐳 Docker Local Tools

> Some handy Docker scripts to run and keep useful tools locally on your machine. Enjoy! 😜 — Sheesh

A collection of ready-to-use **Docker Compose** setups for spinning up popular services locally with a single command. All services share a common Docker network (`testNet`) and persist data via named volumes.

---

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/) installed
- Create the shared network before starting any service:

```bash
docker network create testNet
```

---

## 🚀 Quick Start

### Start everything at once

```bash
./start-all.sh
```

This script iterates over every service folder and runs its `start.sh`, reporting any failures at the end.

### Start a single service

```bash
cd <ServiceFolder>
./start.sh
```

---

## 🛠️ Services

| Service | Port(s) | Description |
|---|---|---|
| **Cassandra** | `9042` | Wide-column NoSQL database |
| **ElasticSearch** | `9200`, `9300` | Distributed search & analytics engine |
| **Kafka** | `9092` | Distributed event streaming platform (KRaft mode, no ZooKeeper) |
| **MongoDB** | `27017` | Document-oriented NoSQL database |
| **MySQL** | `3306` | Relational database (no root password required) |
| **N8N** | `5678` | Workflow automation tool — UI at `http://localhost:5678` |
| **Neo4j** | `7474` (HTTP), `7687` (Bolt) | Graph database — browser at `http://localhost:7474` |
| **Nginx** | `80` | Web server / reverse proxy |
| **Ollama** | `11434` | Run LLMs locally (auto-pulls `llama3.2:1b` on first start) |
| **OpenSearch** | `9201`, `9600` | Open-source search & analytics (security disabled) |
| **PostgreSQL** | `5432` | Relational database (trust auth, no password) |
| **Qdrant** | `6333` (HTTP), `6334` (gRPC) | Vector database for AI/ML workloads |
| **RabbitMQ** | `5672` (AMQP), `15672` (Management UI) | Message broker — UI at `http://localhost:15672` |
| **Redis** | `6379` | In-memory key-value store & cache |

---

## 📂 Structure

```
Docker/
├── start-all.sh          # Start all services at once
├── Cassandra/
│   ├── docker-compose.yaml
│   └── start.sh
├── ElasticSearch/
│   ├── docker-compose.yaml
│   └── start.sh
├── Kafka/
│   ├── docker-compose.yaml
│   └── start.sh
├── MongoDB/
│   ├── docker-compose.yaml
│   └── start.sh
├── MySQL/
│   ├── docker-compose.yaml
│   └── start.sh
├── N8N/
│   ├── docker-compose.yaml
│   └── start.sh
├── Neo4j/
│   ├── docker-compose.yaml
│   └── start.sh
├── Nginx/
│   ├── default.conf
│   ├── docker-compose.yaml
│   └── start.sh
├── Ollama/
│   ├── docker-compose.yaml
│   └── start.sh
├── OpenSearch/
│   ├── docker-compose.yaml
│   └── start.sh
├── PostgreSQL/
│   ├── docker-compose.yaml
│   └── start.sh
├── Qdrant/
│   ├── docker-compose.yaml
│   └── start.sh
├── RabbitMQ/
│   ├── docker-compose.yaml
│   └── start.sh
└── Redis/
    ├── docker-compose.yaml
    └── start.sh
```

---

## 🔧 Notes

- All services use `restart: unless-stopped` — they will automatically restart after a Docker daemon restart.
- All services attach to the external `testNet` network, so containers can reach each other by their **hostname** (e.g., `cassandra-server`, `kafka-server`, `mongo-server`, etc.).
- Data is persisted in a named Docker volume (`testVol`) local to each service folder, so stopping a container does **not** wipe your data.
- **Ollama** automatically pulls the `llama3.2:1b` model on first startup via a one-shot sidecar container.
- **Kafka** runs in KRaft mode (no ZooKeeper dependency).
- **ElasticSearch** and **OpenSearch** have security disabled for local development convenience.

---

## 🛑 Stopping Services

Stop a single service:

```bash
cd <ServiceFolder>
docker compose down
```

Stop all services:

```bash
for dir in Cassandra ElasticSearch Kafka MongoDB MySQL N8N Neo4j Nginx Ollama OpenSearch PostgreSQL Qdrant RabbitMQ Redis; do
  echo "Stopping $dir..."
  (cd "$dir" && docker compose down)
done
```
