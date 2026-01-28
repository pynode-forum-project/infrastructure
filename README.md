# Forum Project — Infrastructure

Orchestration and shared configuration for the Forum microservices stack: Docker Compose, database init scripts, and Postman collection.

## Overview

This repository contains:

- **docker-compose.yaml** — Runs MySQL, MongoDB, RabbitMQ, Gateway, all backend services, Email worker, Mailhog, and Frontend.
- **init-scripts/** — Database initialization (MySQL: `user_db`, `message_db`; MongoDB: optional Mongo init).
- **postman/** — `Forum_Project.postman_collection.json` for API testing against the Gateway (`http://localhost:8080/api`).

All client requests go through the **Gateway** on port **8080** (base path `/api`). The frontend is served on port **3000**.

## Prerequisites

- Docker and Docker Compose
- (Optional) AWS credentials and S3 bucket for file uploads; otherwise file-service may fail on upload

## Quick Start

1. **Clone sibling repositories** (same parent directory as this repo):

   ```bash
   # From the parent of infrastructure/
   git clone https://github.com/pynode-forum-project/infrastructure.git
   git clone https://github.com/pynode-forum-project/frontend.git
   git clone https://github.com/pynode-forum-project/gateway.git
   git clone https://github.com/pynode-forum-project/auth-service.git
   git clone https://github.com/pynode-forum-project/user-service.git
   git clone https://github.com/pynode-forum-project/post-reply-service.git
   git clone https://github.com/pynode-forum-project/history-service.git
   git clone https://github.com/pynode-forum-project/message-service.git
   git clone https://github.com/pynode-forum-project/file-service.git
   git clone https://github.com/pynode-forum-project/email-service.git
   ```

2. **Configure environment**

   ```bash
   cd infrastructure
   cp .env.example .env
   # Edit .env if needed (ports, AWS keys, mail settings)
   ```

3. **Start all services**

   ```bash
   docker-compose up -d --build
   ```

4. **Access**

   | Resource    | URL                      |
   |------------|---------------------------|
   | Frontend   | http://localhost:3000     |
   | Gateway API| http://localhost:8080/api |
   | RabbitMQ Mgmt | http://localhost:15672  |
   | Mailhog UI | http://localhost:8025     |

## Environment Variables

See **.env.example** for all options. Important ones:

| Variable | Default | Description |
|----------|---------|-------------|
| `COMPOSE_PROJECT_NAME` | forum | Prefix for container/network/volume names |
| `GATEWAY_PORT` | 8080 | Gateway (and API) port |
| `FRONTEND_PORT` | 3000 | Frontend port |
| `MYSQL_PORT` | 3306 | MySQL port (host) |
| `MONGODB_PORT` | 27018 | MongoDB port (host; 27018 to avoid conflict with local 27017) |
| `RABBITMQ_PORT` / `RABBITMQ_MGMT_PORT` | 5672 / 15672 | RabbitMQ AMQP and management UI |
| `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `S3_BUCKET_NAME` | — | Required for file-service S3 uploads |
| `MAIL_*` | Mailhog | SMTP for email-service (Mailhog for dev) |

## Services and Ports

| Service | Container Port | Description |
|---------|----------------|-------------|
| mysql | 3306 | MySQL 8.0 — `user_db`, `message_db` |
| mongodb | 27017 | MongoDB 6.0 — `post_db`, `history_db` (by services) |
| rabbitmq | 5672, 15672 | AMQP + management UI |
| gateway | 8080 | API Gateway (Express) |
| auth-service | 5000 | Auth & JWT (Flask) |
| user-service | 5001 | User management (Flask) |
| post-service | 5002 | Posts & replies (Node.js) |
| history-service | 5003 | View history (Node.js) |
| message-service | 5004 | Contact messages (Flask) |
| file-service | 5005 | File upload/S3 (Flask) |
| email-service | — | Email worker (no HTTP port) |
| mailhog | 1025, 8025 | SMTP + Web UI (dev mail) |
| frontend | 3000 | React (Vite) |

## Init Scripts

- **init-scripts/mysql/** — Run in order by MySQL on first start:
  - `01-init.sql` — Creates `user_db`, `message_db`, tables, super admin user.
  - `02-add-pending-email.sql` — Optional migrations (e.g. pending email fields).
- **init-scripts/mongo/** — Optional MongoDB init (e.g. `01-init.js`).

## Postman Collection

- **postman/Forum_Project.postman_collection.json** — Import into Postman.
- Collection variable **base_url**: `http://localhost:8080/api`.
- Run **Auth → Login** to set **token**; protected requests use `Authorization: Bearer {{token}}`.

## Stopping and Cleanup

```bash
docker-compose down
# Remove volumes (resets DBs):
docker-compose down -v
```

## License

See project root LICENSE.
