# 🌱 Bloom Scroll

A perspective-driven content aggregator that counters "doom scrolling" by optimizing for **enrichment** and **serendipity** instead of engagement and outrage.

## Vision

Transform the endless scroll into a finite, intentional experience that leaves users feeling more informed and optimistic. The Bloom Scroll synthesizes diverse content sources—from statistical truth to frontier science to visual culture—into a curated daily digest rooted in **epistemic progress** and **constructive perspective**.

## Key Features

### The "Slow Web" Framework
- ✅ **Finite Feeds**: Definitive "End" state after ~20 cards
- ⬆️ **Upward Scrolling**: Users "plant" ideas and scroll "up" to see them bloom
- 📊 **Raw over Cooked**: Render data from source (CSV/JSON) vs static images
- 🎲 **Serendipity over Similarity**: Penalize repetitiveness, prioritize outliers

### Perspective Engine
- 🔍 **Bias Classification**: Detect 18 types of bias including sensationalism
- 👁️ **Blindspot Detection**: Identify under-covered perspectives
- ✅ **Factfulness Check**: Cross-reference claims against statistical datasets

### Content Diversity
Six content types blended into unified "BloomCard" format:
- 📈 Macro-Data (Our World in Data charts)
- 🔬 Science (OpenAlex papers)
- 🎨 Aesthetic (Visual culture from CARI, Aesthetics Wiki)
- 🌐 Indie Web (Neocities sites)
- 📖 Narrative (TVTropes analysis)
- 🎓 Education (Free courses from My-MOOC)

## Project Structure

```
bloom-scroll/
├── docs/                  # North Star documents (BMAD artifacts)
│   ├── brief.md           # Product concept
│   ├── prd.md             # Product Requirements Document
│   └── architecture.md    # Technical specifications
├── backend/               # Python 3.11+ (FastAPI)
│   ├── app/
│   │   ├── ingestion/     # Content scrapers & API clients
│   │   ├── analysis/      # NLP models (BiasBERT, SBERT)
│   │   ├── curation/      # Feed generation algorithm
│   │   └── api/           # REST endpoints
│   └── Dockerfile
├── frontend/              # Flutter (Dart)
│   ├── lib/
│   │   ├── widgets/       # Masonry Grid, Skeleton Screens
│   │   └── services/      # API connectors
│   └── pubspec.yaml
└── infrastructure/        # Docker Compose, DB configurations
    └── docker-compose.yml
```

## Tech Stack

### Backend
- **Language**: Python 3.11+
- **Framework**: FastAPI (async request handling)
- **Task Queue**: Celery (background workers)
- **Databases**:
  - PostgreSQL 15+ (primary data)
  - Milvus/pgvector (embeddings)
  - Redis 7+ (cache/broker)

### Frontend
- **Framework**: Flutter 3.0+
- **State Management**: BLoC pattern
- **Visualization**: fl_chart (interactive charts)
- **Layout**: Staggered grid (masonry)

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **Orchestration**: Kubernetes (production)

## Quick Start

### Prerequisites
- Python 3.11+
- Flutter SDK 3.0+
- Docker & Docker Compose
- Poetry (Python dependency management)

### 1. Start Infrastructure

```bash
cd infrastructure
docker-compose up -d postgres redis milvus etcd minio rss-bridge
```

### 2. Run Backend

```bash
cd backend
poetry install
cp .env.example .env
# Edit .env with your configuration
poetry run alembic upgrade head
poetry run uvicorn app.main:app --reload
```

Visit http://localhost:8000/docs for API documentation.

### 3. Run Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## Development Workflow

### Backend Development

```bash
# Install dependencies
cd backend
poetry install

# Run tests
poetry run pytest

# Code quality
poetry run black .
poetry run ruff check .
poetry run mypy app/

# Database migrations
poetry run alembic revision --autogenerate -m "Description"
poetry run alembic upgrade head

# Start Celery worker
poetry run celery -A app.worker worker --loglevel=info
```

### Frontend Development

```bash
# Install dependencies
cd frontend
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Build
flutter build apk --release
```

## Documentation

- **[Product Brief](docs/brief.md)**: Core concept and differentiators
- **[PRD](docs/prd.md)**: Detailed product requirements
- **[Architecture](docs/architecture.md)**: Technical design and data flow
- **[Backend README](backend/README.md)**: Backend-specific documentation
- **[Frontend README](frontend/README.md)**: Frontend-specific documentation
- **[Infrastructure README](infrastructure/README.md)**: Docker Compose setup

## Development Stories

### ✅ STORY-001: Infrastructure & OWID Ingestion
**Status**: Completed

- [x] Docker Compose setup (PostgreSQL + pgvector, Redis)
- [x] Alembic migrations for `bloom_cards` table
- [x] OWID connector fetching CO2, life expectancy, child mortality data
- [x] REST API endpoints for ingestion
- [x] Automated acceptance tests

**See**: [STORY-001.md](STORY-001.md) for detailed implementation notes

### ✅ STORY-002: Flutter Scaffold & Charting
**Status**: Completed

- [x] Flutter app with Riverpod state management
- [x] Upward scrolling (reverse: true) implementation
- [x] OWID card widget with fl_chart interactive charts
- [x] API service with Dio (iOS/Android/device support)
- [x] Touch interaction with tooltips
- [x] Tufte-style minimalist chart design

**See**: [STORY-002.md](STORY-002.md) for detailed implementation notes

## Roadmap

### Phase 1: The "Seed" (MVP)
- [x] Ingest OWID (Global Stats) ✅ STORY-001
- [x] Flutter app with native chart rendering ✅ STORY-002
- [x] Upward scrolling UX ✅ STORY-002
- [ ] Masonry grid layout
- [ ] Simple keyword-based filtering
- [ ] RSS-Bridge integration (General News)

### Phase 2: The "Sprout" (Alpha)
- [ ] Integrate OpenAlex (Science) and Neocities (Indie Web)
- [ ] Deploy Perspective Engine v1 (BERT bias detection)
- [ ] Implement "Robin Hood" masonry layout
- [ ] Flutter frontend with upward scrolling

### Phase 3: The "Bloom" (Beta)
- [ ] Full "Blindspot" analysis (Clustering)
- [ ] Trope identification (TVTropes integration)
- [ ] "Mini-Bloom" micro-sessions (5 cards, 3 minutes)
- [ ] Public launch

## Core Principles

1. **Finite Feeds**: Respect user time with definitive endpoints
2. **Serendipity**: High-value outliers over echo chambers
3. **Transparency**: Show data provenance and bias scores
4. **Privacy**: No tracking sold to third parties

## Contributing

This is currently a private project. For team members:

1. Create feature branch from `main`
2. Write tests for new functionality
3. Ensure code quality checks pass
4. Submit PR with descriptive commit messages

## License

Proprietary - Bloom Scroll Team

---

**Version**: 0.1.0
**Status**: Initial Development
**Last Updated**: 2025-11-19
