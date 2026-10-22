# 🐳 Docker Local Tools

> Some handy Docker scripts to run and keep useful tools locally on your machine. Enjoy! 😜 — Sheesh

A collection of ready-to-use **Docker Compose** setups for spinning up popular services locally with a single command. All services share a common Docker network (`testNet`) and a single shared Docker volume (`testVol`).

---

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/) installed and running.
- The shared network (`testNet`) and shared volume (`testVol`) are **automatically created** with proper permissions by any start script if they do not exist. You can also manually create them beforehand if desired:

```bash
docker network create testNet
docker volume create testVol
```

---

## 🚀 Quick Start

### Start everything at once

```bash
./start-all.sh
```

This script iterates over every service folder, verifies prerequisites, and launches each service's `start.sh`, reporting any failures at the end.

### Start a single service

You can run `start.sh` directly from the root directory or from inside the service directory:

```bash
# Option 1: from repository root
./PostgreSQL/start.sh

# Option 2: from within the service folder
cd PostgreSQL
./start.sh
```

---

## 🛠️ Services

| Service | Port(s) | Description | Default Credentials / Web UI |
|---|---|---|---|
| **Cassandra** | `9042` | Wide-column NoSQL database | Default Cassandra port |
| **ElasticSearch** | `9200`, `9300` | Distributed search & analytics engine | `http://localhost:9200` (security disabled) |
| **Kafka** | `9092` | Distributed event streaming platform | KRaft mode (no ZooKeeper dependency) |
| **MongoDB** | `27017` | Document-oriented NoSQL database | Standard MongoDB port |
| **MySQL** | `3306` | Relational database | Root user with empty password allowed |
| **N8N** | `5678` | Workflow automation tool | UI at `http://localhost:5678` |
| **Neo4j** | `7474` (HTTP), `7687` (Bolt) | Graph database | Browser UI at `http://localhost:7474` (auth disabled) |
| **Nginx** | `80` | Web server / reverse proxy | Web root at `http://localhost:80` |
| **Ollama** | `11434` | Local LLM runner | API at `http://localhost:11434` (auto-pulls `llama3.2:1b`) |
| **OpenSearch** | `9201`, `9600` | Open-source search & analytics | `http://localhost:9201` (security disabled) |
| **PostgreSQL** | `5432` | Relational database | User `postgres` (trust authentication, no password) |
| **Qdrant** | `6333` (HTTP), `6334` (gRPC) | Vector database for AI/ML workloads | Web dashboard at `http://localhost:6333/dashboard` |
| **RabbitMQ** | `5672` (AMQP), `15672` (Management UI) | Message broker | UI at `http://localhost:15672` (`guest` / `guest`) |
| **Redis** | `6379` | In-memory key-value store & cache | Standard Redis port |

---

## 📂 Structure

```
Docker/
├── reset-all.sh          # Reset all volume data and recreate containers
├── start-all.sh          # Start all services at once
├── stop-all.sh           # Stop all services at once
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

- **Network**: All services attach to the external `testNet` bridge network and can communicate with each other using their container hostnames (e.g. `cassandra-server`, `kafka-server`, `mongo-server`, `postgres-server`, etc.).
- **Volume**: All services share a single external Docker volume (`testVol`). Startup scripts automatically ensure proper multi-user permissions (`chmod 777`) so services with different container UIDs can share the volume cleanly.
- **Images**: All services use `:latest` image tags (with `rabbitmq:management` for the management dashboard, and official Elasticsearch `9.5.5` multi-arch release).
- **Service Isolation**:
  - **ElasticSearch & OpenSearch**: Use dedicated subpaths (`path.data`) inside `testVol` so their node locks, cluster states, and shard files never collide.
  - **MySQL**: Uses `--datadir=/var/lib/mysql/mysql_data` inside `testVol` to isolate its database files from other service files.
  - **N8N**: Runs with `user: root` and stores state in `N8N_USER_FOLDER: /home/node/.n8n/n8n_data`.
  - **Neo4j**: Uses `SECURE_FILE_PERMISSIONS: "yes"` to avoid recursive chowning of sibling data inside `testVol`.
  - **PostgreSQL**: Stores database clusters in `PGDATA: /var/lib/postgresql/pgdata`.
  - **Redis**: Uses `SKIP_FIX_PERMS: "1"` to preserve shared volume permissions.
  - **Ollama**: Automatically pulls the `llama3.2:1b` model on startup via a one-shot helper container that exits cleanly once the model is cached.
  - **Kafka**: Operates in KRaft mode with no external ZooKeeper dependency.

---

## 🛑 Stopping Services

Stop a single service:

```bash
cd <ServiceFolder>
docker compose down
```

Stop all services:

```bash
./stop-all.sh
```

---

## 🔄 Resetting Services

Stop all services, delete the shared volume (`testVol`) data, and recreate containers with fresh state:

```bash
./reset-all.sh
```
