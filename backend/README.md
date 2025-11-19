# Bloom Scroll Backend

FastAPI-based backend service for the Bloom Scroll content aggregator.

## Tech Stack

- **Python**: 3.11+
- **Framework**: FastAPI (async)
- **Database**: PostgreSQL + pgvector/Milvus
- **Cache/Queue**: Redis + Celery
- **ML**: Sentence-BERT, PoliticalBiasBERT

## Project Structure

```
backend/
├── app/
│   ├── ingestion/     # Content scrapers and API clients
│   ├── analysis/      # NLP models for bias detection & clustering
│   ├── curation/      # Feed generation algorithm
│   ├── api/           # FastAPI endpoints
│   ├── models/        # SQLAlchemy models
│   ├── schemas/       # Pydantic schemas
│   ├── core/          # Config, security, dependencies
│   └── main.py        # Application entry point
├── tests/             # Test suite
├── alembic/           # Database migrations
├── Dockerfile
├── pyproject.toml     # Poetry dependencies
└── README.md
```

## Quick Start

### Prerequisites
- Python 3.11+
- Poetry
- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+

### Installation

```bash
# Install dependencies
poetry install

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Run database migrations
poetry run alembic upgrade head

# Start development server
poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Running with Docker

```bash
# Build image
docker build -t bloom-scroll-backend .

# Run container (requires docker-compose services)
cd ../infrastructure
docker-compose up -d
```

## Development

### Running Tests
```bash
poetry run pytest
poetry run pytest --cov=app  # with coverage
```

### Code Quality
```bash
poetry run black .           # Format code
poetry run ruff check .      # Lint code
poetry run mypy app/         # Type checking
```

### Database Migrations
```bash
# Create new migration
poetry run alembic revision --autogenerate -m "Description"

# Apply migrations
poetry run alembic upgrade head

# Rollback
poetry run alembic downgrade -1
```

## API Documentation

Once running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Environment Variables

Required variables in `.env`:

```bash
# Database
DATABASE_URL=postgresql+asyncpg://user:pass@localhost:5432/bloom_scroll
DATABASE_POOL_SIZE=20

# Redis
REDIS_URL=redis://localhost:6379/0

# Milvus
MILVUS_HOST=localhost
MILVUS_PORT=19530

# API Keys (optional, for external services)
OPENALEX_EMAIL=your-email@example.com

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

## Services

### Ingestion Service
Fetches content from multiple sources:
- Our World in Data (OWID)
- OpenAlex (Science papers)
- Aesthetics Wiki / CARI Institute
- Neocities (Indie Web)
- RSS-Bridge (General news)

### Analysis Service
Processes content through:
- Bias classification (PoliticalBiasBERT)
- Semantic embeddings (Sentence-BERT)
- Clustering for blindspot detection (HDBSCAN)
- Factfulness cross-referencing

### Curation Service
Generates personalized feeds using:
- Metropolis-Hastings sampling
- Serendipity scoring
- "Robin Hood" layout balancing

### API Service
Exposes REST endpoints for:
- Feed generation
- Card interactions
- Perspective overlays
- User management

## Background Tasks

Celery workers handle:
- Scheduled scraping jobs
- Batch embedding generation
- Feed pre-computation
- Data cleanup

Start worker:
```bash
poetry run celery -A app.worker worker --loglevel=info
```

Start beat scheduler:
```bash
poetry run celery -A app.worker beat --loglevel=info
```

## Contributing

1. Create feature branch
2. Write tests
3. Ensure code quality checks pass
4. Submit PR

## License

Proprietary - Bloom Scroll Team
