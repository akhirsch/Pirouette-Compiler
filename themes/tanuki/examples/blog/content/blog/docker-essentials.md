+++
title = "Docker Essentials for Developers"
description = "Containers changed how we deploy software. Here's what every developer needs to know about Docker."
date = 2024-12-25
[taxonomies]
tags = ["docker", "devops", "containers"]
+++

# Docker Essentials for Developers

"Works on my machine" used to be a punchline. Docker makes it a guarantee.

## Core Concepts

**Image**: A read-only template with your application and dependencies.

**Container**: A running instance of an image.

**Dockerfile**: Instructions to build an image.

**Registry**: Storage for images (Docker Hub, GitHub Container Registry).

## Your First Dockerfile

For a Node.js application:

```dockerfile
# Start from a base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Expose the port
EXPOSE 3000

# Run the application
CMD ["node", "server.js"]
```

Build and run:

```bash
docker build -t myapp .
docker run -p 3000:3000 myapp
```

## Layer Caching

Docker caches layers. Order matters:

```dockerfile
# Bad: reinstalls deps on any code change
COPY . .
RUN npm install

# Good: deps only reinstall when package.json changes
COPY package*.json ./
RUN npm install
COPY . .
```

## Multi-Stage Builds

Keep production images small:

```dockerfile
# Build stage
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

Result: A fraction of the size.

## Docker Compose

Define multi-container applications:

```yaml
# docker-compose.yml
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://db:5432/myapp
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_PASSWORD=secret
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Run everything:

```bash
docker compose up -d
```

## Essential Commands

```bash
# Images
docker build -t name:tag .
docker images
docker rmi image_name

# Containers
docker run -d -p 8080:80 nginx
docker ps                    # Running containers
docker ps -a                 # All containers
docker stop container_id
docker rm container_id

# Logs and debugging
docker logs container_id
docker logs -f container_id  # Follow logs
docker exec -it container_id sh

# Cleanup
docker system prune          # Remove unused data
docker system prune -a       # Remove everything unused
```

## Volumes: Persistent Data

Data inside containers is ephemeral. Use volumes:

```bash
# Named volume
docker run -v mydata:/app/data myapp

# Bind mount (development)
docker run -v $(pwd):/app myapp
```

In Compose:

```yaml
services:
  app:
    volumes:
      - ./src:/app/src        # Bind mount for hot reload
      - node_modules:/app/node_modules  # Named volume

volumes:
  node_modules:
```

## Environment Variables

```dockerfile
# Default value in Dockerfile
ENV NODE_ENV=production
```

Override at runtime:

```bash
docker run -e NODE_ENV=development myapp
```

Or use `.env` files with Compose:

```yaml
services:
  app:
    env_file:
      - .env
```

## Health Checks

Let Docker know if your app is healthy:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
    CMD curl -f http://localhost:3000/health || exit 1
```

## Security Best Practices

### Don't run as root

```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

### Use specific image tags

```dockerfile
# Bad: unpredictable
FROM node:latest

# Good: reproducible
FROM node:20.10-alpine3.18
```

### Don't store secrets in images

```bash
# Bad
ENV API_KEY=secret123

# Good: pass at runtime
docker run -e API_KEY=$API_KEY myapp
```

## .dockerignore

Keep images lean:

```
node_modules
.git
.env
*.md
Dockerfile
docker-compose.yml
.dockerignore
coverage
.nyc_output
```

## Development Workflow

```yaml
# docker-compose.dev.yml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    command: npm run dev
```

```bash
docker compose -f docker-compose.dev.yml up
```

## Debugging Containers

```bash
# Shell into running container
docker exec -it container_id sh

# Inspect container details
docker inspect container_id

# View resource usage
docker stats
```

## Quick Reference

| Task | Command |
|------|---------|
| Build image | `docker build -t name .` |
| Run container | `docker run -d -p 8080:80 name` |
| View logs | `docker logs -f container` |
| Shell access | `docker exec -it container sh` |
| Stop all | `docker stop $(docker ps -q)` |
| Clean up | `docker system prune -a` |

Docker transforms "it works on my machine" into "it works everywhere."
