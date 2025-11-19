# Bloom Scroll Infrastructure

Docker Compose configuration for running the complete Bloom Scroll stack locally.

## Services

### Core Services
- **PostgreSQL 15**: Primary database for user data, feed history, source metadata
- **Redis 7**: Cache and message broker for Celery
- **Milvus**: Vector database for semantic search and embeddings

### Supporting Services
- **etcd**: Distributed configuration for Milvus
- **MinIO**: S3-compatible object storage for Milvus
- **RSS-Bridge**: Generate feeds for sites without native RSS

### Application Services
- **Backend**: FastAPI application
- **Celery Worker**: Background task processor
- **Celery Beat**: Scheduled task scheduler

## Quick Start

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Remove volumes (destructive!)
docker-compose down -v
```

## Service Endpoints

| Service | Port | URL |
|---------|------|-----|
| Backend API | 8000 | http://localhost:8000 |
| API Docs | 8000 | http://localhost:8000/docs |
| PostgreSQL | 5432 | postgresql://postgres:postgres@localhost:5432/bloom_scroll |
| Redis | 6379 | redis://localhost:6379 |
| Milvus | 19530 | localhost:19530 |
| MinIO Console | 9001 | http://localhost:9001 |
| RSS-Bridge | 3000 | http://localhost:3000 |

## Development Workflow

### Initial Setup

```bash
# Start infrastructure services only
docker-compose up -d postgres redis milvus etcd minio rss-bridge

# Wait for services to be healthy
docker-compose ps

# Run migrations
cd ../backend
poetry run alembic upgrade head
```

### Running Backend Locally

```bash
# Start only infrastructure
docker-compose up -d postgres redis milvus etcd minio

# Run backend on host
cd ../backend
poetry run uvicorn app.main:app --reload
```

### Running Full Stack

```bash
# Start everything
docker-compose up -d

# Check health
curl http://localhost:8000/health
```

## Database Management

### PostgreSQL

```bash
# Connect to database
docker-compose exec postgres psql -U postgres -d bloom_scroll

# Backup
docker-compose exec postgres pg_dump -U postgres bloom_scroll > backup.sql

# Restore
cat backup.sql | docker-compose exec -T postgres psql -U postgres -d bloom_scroll
```

### Redis

```bash
# Connect to Redis CLI
docker-compose exec redis redis-cli

# Monitor commands
docker-compose exec redis redis-cli monitor

# Flush all data (destructive!)
docker-compose exec redis redis-cli FLUSHALL
```

### Milvus

```bash
# Check Milvus status
curl http://localhost:9091/healthz

# View collections
# Use Python client or milvus CLI
```

## Environment Variables

Create `.env` file in this directory:

```bash
# PostgreSQL
POSTGRES_DB=bloom_scroll
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your-secure-password

# MinIO
MINIO_ROOT_USER=your-minio-user
MINIO_ROOT_PASSWORD=your-minio-password

# Application
DEBUG=true
LOG_LEVEL=INFO
```

## Resource Limits

Default resource allocation:

| Service | CPU | Memory |
|---------|-----|--------|
| PostgreSQL | 1 | 512MB |
| Redis | 0.5 | 256MB |
| Milvus | 2 | 2GB |
| Backend | 1 | 512MB |

Adjust in `docker-compose.yml` based on your system.

## Monitoring

### Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100 backend
```

### Health Checks

```bash
# Check all service health
docker-compose ps

# Backend health
curl http://localhost:8000/health

# PostgreSQL
docker-compose exec postgres pg_isready -U postgres
```

## Troubleshooting

### Services won't start

```bash
# Check ports not in use
lsof -i :8000
lsof -i :5432

# Check logs
docker-compose logs

# Restart specific service
docker-compose restart backend
```

### Database connection issues

```bash
# Verify PostgreSQL is healthy
docker-compose ps postgres

# Check connection from backend
docker-compose exec backend python -c "import asyncpg; print('OK')"
```

### Milvus connection issues

```bash
# Check etcd is running
docker-compose ps etcd

# Check MinIO is accessible
curl http://localhost:9000/minio/health/live

# Restart Milvus
docker-compose restart milvus
```

## Production Considerations

For production deployment:

1. **Use Kubernetes** instead of Docker Compose
2. **Managed Databases**: Use cloud provider's managed PostgreSQL
3. **Redis Cluster**: Deploy Redis in cluster mode
4. **Secrets Management**: Use Vault or cloud provider secrets
5. **SSL/TLS**: Enable encryption in transit
6. **Monitoring**: Add Prometheus + Grafana stack
7. **Backups**: Automated backup strategy

See `kubernetes/` directory for K8s manifests (coming soon).

## Cleanup

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (destroys data!)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

---

**Last Updated**: 2025-11-19
