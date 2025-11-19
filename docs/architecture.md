# Bloom Scroll: Technical Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                       Flutter Client                         │
│  (iOS/Android - Masonry Grid, Skeleton Screens, Charts)    │
└─────────────────┬───────────────────────────────────────────┘
                  │ REST API
┌─────────────────▼───────────────────────────────────────────┐
│                    FastAPI Backend                           │
│  ┌──────────────┬──────────────┬──────────────┬──────────┐ │
│  │  Ingestion   │   Analysis   │  Curation    │   API    │ │
│  │  Service     │   Service    │  Service     │ Endpoints│ │
│  └──────────────┴──────────────┴──────────────┴──────────┘ │
└─────────────────┬───────────────────────────────────────────┘
                  │
    ┌─────────────┼─────────────┬─────────────────┐
    │             │             │                 │
┌───▼────┐  ┌────▼─────┐  ┌────▼────┐      ┌────▼─────┐
│PostGres│  │  Milvus  │  │  Redis  │      │ External │
│  SQL   │  │ (Vector) │  │ (Cache) │      │   APIs   │
└────────┘  └──────────┘  └─────────┘      └──────────┘
```

## Technology Stack

### Backend
- **Language**: Python 3.11+
- **Framework**: FastAPI (async request handling)
- **Task Queue**: Celery (background workers for scraping)
- **Containerization**: Docker + Docker Compose
- **Orchestration**: Kubernetes (production scaling)

### Data Layer
- **Primary DB**: PostgreSQL 15+
  - User profiles, feed history, source metadata
  - JSONB columns for flexible BloomCard storage
- **Vector DB**: Milvus (or pgvector extension)
  - SBERT embeddings for semantic clustering
  - Serendipity score calculations
- **Cache**: Redis 7+
  - "Hot Feeds" caching
  - Celery message broker
  - Rate limit tracking

### Frontend
- **Framework**: Flutter (Dart)
- **Key Libraries**:
  - `fl_chart` - Interactive data visualization
  - `flutter_staggered_grid_view` - Masonry layout
  - `dio` - HTTP client with interceptors
  - `hive` - Local storage for offline mode

## Core Services

### 1. Ingestion Service (`backend/app/ingestion/`)
**Purpose**: Fetch and normalize content from diverse sources

**Components**:
- `owid_spider.py` - Our World in Data CSV/JSON fetcher
- `openalex_client.py` - Science paper API client (polite pool)
- `aesthetics_scraper.py` - MediaWiki REST API + Are.na
- `neocities_crawler.py` - Webring traversal logic
- `rss_bridge_adapter.py` - Wrapper for self-hosted RSS-Bridge

**Data Flow**:
```
External Source → Spider/Client → Validator → BloomCard Schema → PostgreSQL
```

### 2. Analysis Service (`backend/app/analysis/`)
**Purpose**: Score content quality and detect bias

**Components**:
- `bias_classifier.py` - PoliticalBiasBERT implementation
- `clustering.py` - HDBSCAN for blindspot detection
- `embedder.py` - Sentence-BERT vectorization
- `factcheck.py` - Cross-reference with OWID datasets

**Models**:
- `sentence-transformers/all-MiniLM-L6-v2` (embeddings)
- `bucketresearch/politicalBiasBERT` (bias detection)

### 3. Curation Service (`backend/app/curation/`)
**Purpose**: Generate personalized yet diverse feeds

**Components**:
- `bloom_algorithm.py` - Metropolis-Hastings sampling
- `serendipity_scorer.py` - Calculate S = Relevance × (1 - Similarity)
- `layout_engine.py` - "Robin Hood" visual balancing

**Key Function**:
```python
def generate_bloom_feed(user_id: str, session_length: int = 20) -> List[BloomCard]:
    """
    Returns a finite feed optimized for:
    1. High serendipity score
    2. Source diversity
    3. Visual rhythm (mix of rich/text content)
    """
```

### 4. API Service (`backend/app/api/`)
**Purpose**: Expose endpoints for client consumption

**Endpoints**:
- `GET /feed` - Generate new bloom session
- `GET /feed/{session_id}` - Resume session
- `POST /card/{id}/interact` - Track read/skip/save
- `GET /perspective/{card_id}` - Fetch bias/blindspot overlay
- `GET /health` - Service status

## Data Models

### BloomCard (Unified Content Schema)
```python
class BloomCard(BaseModel):
    id: UUID
    type: Literal["data", "science", "aesthetic", "web", "narrative", "education"]
    source: str  # e.g., "ourworldindata.org"
    title: str
    content: Dict  # Polymorphic: chart_config | abstract | image_url | etc.
    metadata: Dict  # tags, publish_date, author, etc.
    embeddings: List[float]  # 384-dim SBERT vector
    scores: Dict[str, float]  # {"bias": 0.2, "serendipity": 0.85}
    created_at: datetime
```

### User Interaction
```python
class Interaction(BaseModel):
    user_id: UUID
    card_id: UUID
    action: Literal["view", "read", "skip", "save"]
    dwell_time: int  # seconds
    timestamp: datetime
```

## Infrastructure

### Docker Compose Services (`infrastructure/docker-compose.yml`)
```yaml
services:
  backend:
    build: ./backend
    depends_on: [postgres, redis, milvus]

  celery_worker:
    build: ./backend
    command: celery -A app.worker worker

  postgres:
    image: postgres:15-alpine
    volumes: [./data/postgres:/var/lib/postgresql/data]

  milvus:
    image: milvusdb/milvus:latest

  redis:
    image: redis:7-alpine

  rss_bridge:
    image: rssbridge/rss-bridge:latest
```

### Environment Configuration
- `.env.development` - Local dev settings
- `.env.production` - K8s secrets integration
- Feature flags for gradual rollout (e.g., `ENABLE_TVTROPES_INTEGRATION`)

## Security & Privacy

### Data Handling
- No tracking of reading patterns sold to third parties
- User embeddings stored anonymously (UUID-based)
- GDPR-compliant data export API

### Rate Limiting
- OpenAlex: Polite pool (10 req/s with email)
- OWID: Direct access (no limits, but cached)
- Neocities: 1 req/s (respectful crawling)

## Scalability Considerations

### Phase 1 (MVP)
- Single Docker Compose stack on VPS
- ~1000 daily users
- Daily batch processing (nightly scraping)

### Phase 2 (Growth)
- Kubernetes on cloud provider (GKE/EKS)
- Horizontal scaling of ingestion workers
- Real-time feed updates (WebSocket for new cards)

### Phase 3 (Scale)
- CDN for static assets (Cloudflare)
- Multi-region deployment
- GraphQL API for advanced clients

## Monitoring & Observability
- **Logs**: Structured JSON logs → Loki/ElasticSearch
- **Metrics**: Prometheus + Grafana dashboards
- **Tracing**: OpenTelemetry for request flows
- **Alerts**: PagerDuty for service degradation

## Development Workflow

### Local Setup
```bash
# Clone repo
git clone https://github.com/madfam-io/bloom-scroll

# Start services
cd infrastructure
docker-compose up -d

# Run backend
cd ../backend
poetry install
uvicorn app.main:app --reload

# Run frontend
cd ../frontend
flutter pub get
flutter run
```

### Testing Strategy
- **Unit**: pytest for Python services
- **Integration**: Testcontainers for DB interactions
- **E2E**: Flutter integration tests
- **Load**: Locust for API stress testing

---

**Version**: 1.0
**Last Updated**: 2025-11-19
**Owner**: Engineering Team
