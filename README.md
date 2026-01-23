
# Forum Project - Infrastructure & Orchestration

This repository acts as the central hub for the **Forum Project**. It contains the `docker-compose` configuration required to spin up the entire microservices ecosystem (Frontend, Backend Services, Databases, and Message Queues) locally.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

* **Docker Desktop** (Make sure it is running)
* **Git**
* **VS Code** (Recommended for multi-root workspace management)

---

## Getting Started

### 1. Directory Structure Setup (Crucial)

To ensure that Docker Compose can find all the service Dockerfiles, **it is strictly required** that all repositories are cloned into the same parent directory (e.g., `ForumProject`).

The final folder structure on your local machine should look like this:

```text
ForumProject/
├── infrastructure/       <-- You are here (contains docker-compose.yaml)
├── frontend/
├── gateway/
├── auth-service/
├── user-service/
├── post-reply-service/
├── history-service/
├── message-service/
├── file-service/
├── email-service/
```

### 2. One-Time Installation

Open your terminal (Terminal, Git Bash, or PowerShell), create a parent folder, and run the following commands to clone all repositories:

```bash
# 1. Create a parent directory
mkdir ForumProject
cd ForumProject

# 2. Clone the Infrastructure repo (this repo)
git clone https://github.com/pynode-forum-project/infrastructure.git

# 3. Clone the Frontend
git clone https://github.com/pynode-forum-project/frontend.git

# 4. Clone the Gateway & Backend Microservices
git clone https://github.com/pynode-forum-project/gateway.git
git clone https://github.com/pynode-forum-project/auth-service.git
git clone https://github.com/pynode-forum-project/user-service.git
git clone https://github.com/pynode-forum-project/post-reply-service.git
git clone https://github.com/pynode-forum-project/history-service.git
git clone https://github.com/pynode-forum-project/message-service.git
git clone https://github.com/pynode-forum-project/file-service.git
git clone https://github.com/pynode-forum-project/email-service.git
```

> **Note:** If you are using SSH keys, please replace `https://github.com/...` with `git@github.com:...`.

### 3. Running the Application

Once all repositories are cloned, navigate into the infrastructure folder and start the services:

```bash
cd infrastructure

# Start all services in the background (first time or after code changes)
docker-compose up -d --build

# Start services without rebuilding (faster, use when no code changes)
docker-compose up -d

# View real-time logs for all services
docker-compose logs -f

# View logs for a specific service
docker-compose logs -f frontend
docker-compose logs -f auth-service

# Restart a specific service (after code changes)
docker-compose restart user-service

# Check service status
docker-compose ps
```

* The `--build` flag ensures that Docker rebuilds the images if you have changed any code in the Python/Node services.
* The first launch may take a few minutes to download MySQL/MongoDB images and install dependencies.
* Services with health checks (MySQL, RabbitMQ) will wait until healthy before dependent services start.

To stop the services, run:
```bash
# Stop and remove containers (data volumes preserved)
docker-compose down

# Stop and remove containers AND volumes (fresh start, deletes all data)
docker-compose down -v
```

---

## Service Architecture

```text
┌─────────────────────────────────────────────────────────────────┐
│                        Frontend (React)                         │
│                      http://localhost:3000                      │
└─────────────────────────────┬───────────────────────────────────┘
                              │ /api/*
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Gateway (Node/Express)                       │
│                      http://localhost:8080                      │
└───┬─────────┬─────────┬─────────┬─────────┬─────────┬───────────┘
    │         │         │         │         │         │
    ▼         ▼         ▼         ▼         ▼         ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│ Auth  │ │ User  │ │ Post  │ │History│ │Message│ │ File  │
│ :5000 │ │ :5001 │ │ :5002 │ │ :5003 │ │ :5004 │ │ :5005 │
└───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘ └───────┘
    │         │         │         │         │
    ▼         ▼         │         ▼         ▼
┌─────────────────┐     │    ┌─────────────────┐
│     MySQL       │     │    │    RabbitMQ     │
│     :3306       │     │    │  :5672/:15672   │
└─────────────────┘     │    └────────┬────────┘
                        ▼             │
                 ┌───────────┐        ▼
                 │  MongoDB  │  ┌───────────┐
                 │  :27017   │  │   Email   │
                 └───────────┘  │  Service  │
                                └───────────┘
```

---

## Service Port Mapping

Once the system is up, you can access the services at the following local ports:

| Service | Technology | Port | Status | Description |
| :--- | :--- | :--- | :---: | :--- |
| **Frontend** | React/Vite | `http://localhost:3000` | ✅ | Main User Interface |
| **Gateway** | Node/Express | `http://localhost:8080` | ✅ | **API Entry Point** (All requests go here) |
| **Auth Service** | Flask | `5000` | ✅ | Login & Registration Logic |
| **User Service** | Flask | `5001` | ✅ | User Data Management |
| **Post Service** | Node/Express | `5002` | ⏳ | Posts & Replies (TODO) |
| **History Service** | Flask | `5003` | ⏳ | Browsing History (TODO) |
| **Message Service** | Flask | `5004` | ⏳ | Contact Admin Messages (TODO) |
| **File Service** | Flask | `5005` | ⏳ | File Upload (S3) (TODO) |
| **Email Service** | Flask | N/A | ⏳ | Background Worker (TODO) |
| **MySQL** | Database | `3306` | ✅ | User, History, Message DBs (Root Pass: `root`) |
| **MongoDB** | Database | `27017` | ✅ | Post & Reply DB |
| **RabbitMQ** | Queue | `5672` / `15672` | ✅ | Message Queue / Management Console (guest/guest) |

> **Legend:** ✅ = Configured in docker-compose | ⏳ = Pending implementation

> **Important:** The Frontend should only communicate with the **Gateway (8080)**. Do not make direct calls to ports 5000-5005 from the browser.

---

## Troubleshooting

**1. "Service not found" or "Build context failed"**
* **Cause:** You likely cloned the repositories into different folders or the structure is incorrect.
* **Fix:** Ensure `infrastructure` and `user-service` (and others) are siblings in the same parent folder. Check `docker-compose.yaml` relative paths (e.g., `build: ../user-service`).

**2. Database Connection Refused**
* **Cause:** The database containers might still be initializing when the backend services try to connect.
* **Fix:** Wait a few seconds and the services usually auto-retry. Health checks are configured for MySQL and RabbitMQ. If issues persist, restart the specific service: `docker-compose restart user-service`.

**3. Port Already in Use**
* **Cause:** You have another instance of MySQL (3306) or Mongo (27017) running locally on your machine.
* **Fix:** Stop your local database services or kill the process occupying the port.
```bash
# Find process using a port (macOS/Linux)
lsof -i :3306

# Kill the process
kill -9 <PID>
```

**4. Frontend API calls failing (CORS or connection errors)**
* **Cause:** Gateway or backend services are not running, or CORS is misconfigured.
* **Fix:** 
  1. Check if all services are running: `docker-compose ps`
  2. Check gateway logs: `docker-compose logs gateway`
  3. Ensure frontend is calling `http://localhost:8080/api/*` (not direct service ports)

**5. Container keeps restarting**
* **Cause:** Application error or missing environment variables.
* **Fix:** Check the logs for the specific service:
```bash
docker-compose logs auth-service
```

**6. Need a fresh start (reset everything)**
```bash
# Stop all containers and remove volumes
docker-compose down -v

# Remove all built images (optional, forces full rebuild)
docker-compose down --rmi all

# Start fresh
docker-compose up -d --build
```

---

## Development Workflow (VS Code)

1.  Open the parent `ForumProject` folder in **VS Code**.
2.  VS Code will detect all Git repositories (Frontend, Gateway, etc.) automatically.
3.  Make changes to the code in the respective folders.
4.  If you changed **backend code** (Python/Node):
    * Restart the specific container to apply changes: `docker-compose restart user-service`
5.  If you changed **frontend code**:
    * Changes usually hot-reload automatically at `localhost:3000`.


## Collaboration Workflow

To ensure our code links automatically to Jira tickets, please follow these rules strictly.

### 1. Git Commit Format
Every commit message **MUST** start with the Jira Ticket ID.

**Format:**
`[Ticket-ID]: <Description>`

**Examples:**
* `FP-2: Implemented Seeding Script for User Table`

**Why?**
This allows Jira to automatically track our progress and attach code changes to the board.

### 2. Branch Naming (Optional but Recommended)
When starting a new task, create a branch using the ticket ID:
* `feature/FP-2-seeding`
* `fix/FP-13-JWT`


## API Testing (Postman)

We maintain a shared API collection to ensure everyone tests with the same data.

### Location
File path: `./postman/collections/Forum_Project.postman_collection.json`

### Setup (Import)
1.  **Get the latest file:**
    ```bash
    git pull origin main
    ```
2.  Open **Postman** -> Click **Import** (Top Left).
3.  Drag and drop the `postman/collections/Forum_Project.postman_collection.json` file into Postman.
4.  (Optional) Set `base_url` variable to `http://localhost:8080` in your environment.

### Workflow: How to Share Updates
When you add a new API endpoint (e.g., `/login`) in Postman:

1.  **Export:** Right-click Collection -> **Export** -> **JSON v2.1**.
2.  **Overwrite:** Save it to `infrastructure/postman/collections/Forum_Project.postman_collection.json` (Replace the old file).
3.  **Push:** Run these commands to share with the team:

```bash
# 1. Enter the infrastructure folder
cd infrastructure

# 2. Stage ONLY the documentation file
git add postman/collections/Forum_Project.postman_collection.json

# 3. Commit with Ticket ID
git commit -m "[your-task-id]: Updated Postman collection with [your-task] endpoints"

# 4. Push
git push origin main
```