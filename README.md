
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
git clone [https://github.com/pynode-forum-project/infrastructure.git](https://github.com/pynode-forum-project/infrastructure.git)

# 3. Clone the Frontend
git clone [https://github.com/pynode-forum-project/frontend.git](https://github.com/pynode-forum-project/frontend.git)

# 4. Clone the Gateway & Backend Microservices
git clone [https://github.com/pynode-forum-project/gateway.git](https://github.com/pynode-forum-project/gateway.git)
git clone [https://github.com/pynode-forum-project/auth-service.git](https://github.com/pynode-forum-project/auth-service.git)
git clone [https://github.com/pynode-forum-project/user-service.git](https://github.com/pynode-forum-project/user-service.git)
git clone [https://github.com/pynode-forum-project/post-reply-service.git](https://github.com/pynode-forum-project/post-reply-service.git)
git clone [https://github.com/pynode-forum-project/history-service.git](https://github.com/pynode-forum-project/history-service.git)
git clone [https://github.com/pynode-forum-project/message-service.git](https://github.com/pynode-forum-project/message-service.git)
git clone [https://github.com/pynode-forum-project/file-service.git](https://github.com/pynode-forum-project/file-service.git)
git clone [https://github.com/pynode-forum-project/email-service.git](https://github.com/pynode-forum-project/email-service.git)
```

> **Note:** If you are using SSH keys, please replace `https://github.com/...` with `git@github.com:...`.

### 3. Running the Application

Once all repositories are cloned, navigate into the infrastructure folder and start the services:

```bash
cd infrastructure

# Start databases and services in the background
docker-compose up -d --build
```

* The `--build` flag ensures that Docker rebuilds the images if you have changed any code in the Python/Node services.
* The first launch may take a few minutes to download MySQL/MongoDB images and install dependencies.

To stop the services, run:
```bash
docker-compose down
```

---

## Service Port Mapping

Once the system is up, you can access the services at the following local ports:

| Service | Technology | Port | Description |
| :--- | :--- | :--- | :--- |
| **Frontend** | React | `http://localhost:3000` | Main User Interface |
| **Gateway** | Node/Express | `http://localhost:8080` | **API Entry Point** (All requests go here) |
| **Auth Service** | Flask | `5000` (Internal) | Login & Registration Logic |
| **User Service** | Flask | `5001` (Internal) | User Data Management |
| **Post Service** | Node/Express | `5002` (Internal) | Posts & Replies |
| **History Service** | Flask | `5003` (Internal) | Browsing History |
| **Message Service** | Flask | `5004` (Internal) | Contact Admin Messages |
| **File Service** | Flask | `5005` (Internal) | File Upload (S3) |
| **Email Service** | Flask | N/A | Background Worker (RabbitMQ Listener) |
| **MySQL** | Database | `3306` | User, History, Message DBs (Root Pass: `root`) |
| **MongoDB** | Database | `27017` | Post & Reply DB |
| **RabbitMQ** | Queue | `15672` | Management Console |

> **Important:** The Frontend should only communicate with the **Gateway (8080)**. Do not make direct calls to ports 5000-5005 from the browser.

---

## Troubleshooting

**1. "Service not found" or "Build context failed"**
* **Cause:** You likely cloned the repositories into different folders or the structure is incorrect.
* **Fix:** Ensure `infrastructure` and `user-service` (and others) are siblings in the same parent folder. Check `docker-compose.yaml` relative paths (e.g., `build: ../user-service`).

**2. Database Connection Refused**
* **Cause:** The database containers might still be initializing when the backend services try to connect.
* **Fix:** Wait a few seconds and the services usually auto-retry. If not, restart the specific service: `docker-compose restart user-service`.

**3. Port Already in Use**
* **Cause:** You have another instance of MySQL (3306) or Mongo (27017) running locally on your machine.
* **Fix:** Stop your local database services or kill the process occupying the port.

---

## Development Workflow (VS Code)

1.  Open the parent `ForumProject` folder in **VS Code**.
2.  VS Code will detect all Git repositories (Frontend, Gateway, etc.) automatically.
3.  Make changes to the code in the respective folders.
4.  If you changed **backend code** (Python/Node):
    * Restart the specific container to apply changes: `docker-compose restart user-service`
5.  If you changed **frontend code**:
    * Changes usually hot-reload automatically at `localhost:3000`.
