# 🗺️ Bloom Scroll: Development Roadmap

**The Work** - Story tracking and implementation status

---

## Overview

This roadmap tracks the 7 core implementation stories for Bloom Scroll, generated through the BMAD (Breakthrough Method for Agile Development) protocol. Each story represents a vertical slice of functionality from backend to frontend.

---

## Story Tracking Table

| ID | Story Title | Epic | Priority | Status | Docs |
|----|-------------|------|----------|--------|------|
| **STORY-001** | Infrastructure & OWID Ingestion (The Roots) | The Roots | 🔴 Critical | ✅ **Done** | [Details](#story-001-the-roots) |
| **STORY-002** | Mobile Charts & Upward Scroll (The Stem) | The Stem | 🔴 Critical | ✅ **Done** | [Details](#story-002-the-stem) |
| **STORY-003** | Aesthetics & Masonry Grid (The Flower) | The Flower | 🟡 High | ✅ **Done** | [Details](#story-003-the-flower) |
| **STORY-004** | Vector Serendipity & Bias Engine (The Brain) | The Lens | 🔴 Critical | ✅ **Done** | [Implementation](STORY-004-IMPLEMENTATION.md) |
| **STORY-005** | Poison Pill & Stability Tests (The Immunity) | Quality | 🟡 High | 🚧 **In Progress** | [Details](#story-005-the-immunity) |
| **STORY-006** | Perspective Overlay & Flip Animation (The Soul) | The Lens | 🟢 Medium | ✅ **Done** | [Implementation](STORY-006-IMPLEMENTATION.md) |
| **STORY-007** | Finite Feed & Completion Widget (The Boundary) | The Scroll | 🔴 Critical | ✅ **Done** | [Implementation](STORY-007-IMPLEMENTATION.md) |

**Legend**:
- 🔴 Critical - Core functionality, blocking
- 🟡 High - Important for MVP
- 🟢 Medium - Enhancement, non-blocking

---

## Story Details

### STORY-001: The Roots
**Infrastructure & OWID Ingestion**

**Epic**: The Roots (Data Foundation)
**Status**: ✅ Done
**Priority**: Critical

#### Objectives
- Set up Docker Compose infrastructure (PostgreSQL + pgvector, Redis)
- Implement Alembic migrations for `bloom_cards` table
- Build OWID connector to fetch CSV/JSON data
- Create REST API endpoints for ingestion
- Write automated acceptance tests

#### Acceptance Criteria
- [x] Docker Compose spins up all services
- [x] PostgreSQL has pgvector extension installed
- [x] Alembic migrations create schema correctly
- [x] OWID connector fetches 3+ datasets (CO2, life expectancy, child mortality)
- [x] `/ingest/owid` endpoint works with query params
- [x] `/feed` endpoint returns ingested cards
- [x] All tests pass

#### Files Changed
- `infrastructure/docker-compose.yml`
- `backend/alembic/versions/001_initial_schema.py`
- `backend/app/models/bloom_card.py`
- `backend/app/ingestion/owid_connector.py`
- `backend/app/api/routes.py`

**Documentation**: See `/STORY-001.md` for implementation details.

---

### STORY-002: The Stem
**Mobile Charts & Upward Scroll**

**Epic**: The Stem (UI Foundation)
**Status**: ✅ Done
**Priority**: Critical

#### Objectives
- Initialize Flutter project with Riverpod state management
- Implement upward scrolling (`reverse: true`) UX
- Build OWID card widget with fl_chart rendering
- Create API service with Dio (iOS/Android/device support)
- Add touch interaction with tooltips
- Apply Tufte-style minimalist chart design

#### Acceptance Criteria
- [x] Flutter app builds and runs on iOS Simulator
- [x] Feed scrolls upward (newest at bottom)
- [x] OWID cards render line charts from JSON data
- [x] Charts have no grids, no borders (Tufte-style)
- [x] Touch shows red circle tooltip with value
- [x] API service connects to localhost:8000 (iOS) or 10.0.2.2:8000 (Android)
- [x] Paper & Ink design tokens applied

#### Files Changed
- `frontend/lib/main.dart`
- `frontend/lib/screens/feed_screen.dart`
- `frontend/lib/widgets/owid_card.dart`
- `frontend/lib/services/api_service.dart`
- `frontend/lib/providers/api_provider.dart`
- `frontend/pubspec.yaml`

**Documentation**: See `/STORY-002.md` for implementation details.

---

### STORY-003: The Flower
**Aesthetics & Masonry Grid**

**Epic**: The Flower (Visual Diversity)
**Status**: ✅ Done
**Priority**: High

#### Objectives
- Build Are.na API connector for aesthetic images
- Pre-calculate aspect ratios (prevent layout shifts)
- Implement masonry grid layout (2-column staggered)
- Create aesthetic card widget with Hero animation
- Build full-screen image viewer with pinch-to-zoom
- Mix OWID charts + aesthetic images in unified feed

#### Acceptance Criteria
- [x] Are.na connector fetches images from public channels
- [x] Aspect ratios calculated on backend, stored in `data_payload`
- [x] Masonry grid uses `flutter_staggered_grid_view`
- [x] Aesthetic cards have correct aspect ratio (no layout shifts)
- [x] Tap image → Hero animation to full-screen viewer
- [x] Full-screen viewer supports pinch-to-zoom
- [x] Feed mixes OWID + aesthetic cards

#### Files Changed
- `backend/app/ingestion/cari_connector.py`
- `frontend/lib/widgets/aesthetic_card.dart`
- `frontend/lib/screens/image_viewer.dart`
- `frontend/lib/models/bloom_card.dart`

**Documentation**: See `/STORY-003.md` for implementation details.

---

### STORY-004: The Brain
**Vector Serendipity & Bias Engine**

**Epic**: The Lens (Perspective Analysis)
**Status**: ✅ Done
**Priority**: Critical

#### Objectives
- Integrate Sentence-BERT (all-MiniLM-L6-v2) for embeddings
- Implement cosine distance serendipity scoring
- Build Bloom algorithm with "Serendipity Zone" (0.3-0.8)
- Add reason tag generation (BLINDSPOT_BREAKER, DEEP_DIVE, etc.)
- Create `/feed` endpoint with user context parameter
- Implement vector similarity search with pgvector

#### Acceptance Criteria
- [x] Sentence-BERT generates 384-dim embeddings
- [x] Embeddings stored in pgvector column
- [x] Cosine distance calculated correctly
- [x] Feed filters cards to 0.3-0.8 distance range
- [x] Reason tags generated based on distance thresholds
- [x] `/feed?user_context=id1,id2` returns serendipitous cards
- [x] Source diversity enforced (mix of OWID + aesthetic)

#### Files Changed
- `backend/app/curation/bloom_algorithm.py`
- `backend/app/analysis/nlp_service.py`
- `backend/app/api/routes.py`
- `backend/requirements.txt` (sentence-transformers)

**Documentation**: See [STORY-004-IMPLEMENTATION.md](STORY-004-IMPLEMENTATION.md) for detailed implementation.

---

### STORY-005: The Immunity
**Poison Pill & Stability Tests**

**Epic**: Quality Assurance
**Status**: 🚧 In Progress
**Priority**: High

#### Objectives
- Create "poison pill" test fixtures (malformed data)
- Build backend ingestion gauntlet tests
- Implement frontend visual stress tests
- Test skeleton loading states
- Test aspect ratio edge cases
- Ensure graceful degradation

#### Acceptance Criteria
- [ ] Backend handles malformed OWID CSV gracefully
- [ ] Backend handles invalid image URLs without crashing
- [ ] Frontend shows skeleton screens during load
- [ ] Frontend handles missing metadata fields
- [ ] Aspect ratio breakers don't cause layout shifts
- [ ] Error boundaries catch widget failures
- [ ] All edge case tests pass

#### Files To Create
- `backend/tests/fixtures/poison_pills/`
- `backend/tests/test_ingestion_gauntlet.py`
- `frontend/test/widget_stress_test.dart`

**Status**: Backend tests initialized, frontend tests pending.

---

### STORY-006: The Soul
**Perspective Overlay & Flip Animation**

**Epic**: The Lens (Perspective Analysis)
**Status**: ✅ Done
**Priority**: Medium

#### Objectives
- Add perspective metadata to backend (`bias_score`, `constructiveness_score`, `blindspot_tags`)
- Build 3D flip animation with Matrix4 transform
- Create FlippableCard wrapper widget
- Implement BiasCompass (political spectrum visualization)
- Implement ConstructivenessRing (radial gauge)
- Implement SerendipityTag (reason display)
- Integrate into OWID + Aesthetic cards

#### Acceptance Criteria
- [x] Backend returns `meta` field in feed response
- [x] Flip animation completes in <300ms
- [x] Info icon (ⓘ) triggers flip
- [x] BiasCompass shows position on political spectrum
- [x] Labels: "Left-Leaning", "Center", "Right-Leaning" (NO party names)
- [x] ConstructivenessRing shows radial gauge with score
- [x] SerendipityTag shows icon + reason text
- [x] Back of card uses Paper & Ink styling
- [x] Close button flips back to front

#### Files Changed
- `backend/app/models/bloom_card.py` - Added `to_dict(include_meta=True)`
- `backend/app/curation/bloom_algorithm.py` - Added `calculate_reason_tag()`
- `backend/app/api/routes.py` - Enhanced feed endpoint
- `frontend/lib/models/bloom_card.dart` - Added `PerspectiveMeta` class
- `frontend/lib/widgets/perspective/flippable_card.dart` - New
- `frontend/lib/widgets/perspective/perspective_overlay.dart` - New
- `frontend/lib/widgets/perspective/bias_compass.dart` - New
- `frontend/lib/widgets/perspective/constructiveness_ring.dart` - New
- `frontend/lib/widgets/perspective/serendipity_tag.dart` - New

**Documentation**: See [STORY-006-IMPLEMENTATION.md](STORY-006-IMPLEMENTATION.md) for detailed implementation.

---

### STORY-007: The Boundary
**Finite Feed & Completion Widget**

**Epic**: The Scroll (Finite Experience)
**Status**: ✅ Done
**Priority**: Critical

#### Objectives
- Implement hard daily limit of 20 cards
- Add pagination to `/feed` endpoint
- Build completion object in API response
- Create CompletionWidget with animated flower
- Implement FeedController with Riverpod state management
- Add local storage for read state tracking (daily reset)
- Show progress indicator in AppBar
- Prevent infinite scrolling

#### Acceptance Criteria
- [x] Backend enforces `DAILY_LIMIT = 20`
- [x] `/feed` endpoint accepts `page`, `read_count`, `limit` params
- [x] Completion object returned when limit reached
- [x] CompletionWidget shows "The Garden is Watered" message
- [x] Animated flower icon (scale + rotate)
- [x] FeedController manages pagination state
- [x] StorageService persists read count with daily reset
- [x] AppBar shows "10/20" progress counter
- [x] Linear progress bar shows completion percentage
- [x] No "Load More" button (scroll-based pagination)

#### Files Changed
- `backend/app/api/routes.py` - Added pagination, DAILY_LIMIT, completion logic
- `frontend/lib/models/bloom_card.dart` - Added `PaginationMeta`, `CompletionData`
- `frontend/lib/services/api_service.dart` - Updated `getFeed()` with pagination
- `frontend/lib/services/storage_service.dart` - New (read state tracking)
- `frontend/lib/providers/feed_controller.dart` - New (StateNotifier)
- `frontend/lib/widgets/completion_widget.dart` - New (completion celebration)
- `frontend/lib/screens/feed_screen.dart` - Updated with pagination, completion
- `frontend/pubspec.yaml` - Added `shared_preferences`

**Documentation**: See [STORY-007-IMPLEMENTATION.md](STORY-007-IMPLEMENTATION.md) for detailed implementation.

---

## Epic Breakdown

### The Roots (Data Foundation)
- STORY-001: Infrastructure & OWID Ingestion ✅

### The Stem (UI Foundation)
- STORY-002: Mobile Charts & Upward Scroll ✅

### The Flower (Visual Diversity)
- STORY-003: Aesthetics & Masonry Grid ✅

### The Lens (Perspective Analysis)
- STORY-004: Vector Serendipity & Bias Engine ✅
- STORY-006: Perspective Overlay & Flip Animation ✅

### The Scroll (Finite Experience)
- STORY-007: Finite Feed & Completion Widget ✅

### Quality Assurance
- STORY-005: Poison Pill & Stability Tests 🚧

---

## Milestone Progress

### Phase 1: MVP Foundation ✅
**Goal**: Core infrastructure + basic feed experience
**Status**: Complete

- [x] Docker infrastructure
- [x] OWID ingestion
- [x] Flutter app with upward scroll
- [x] Chart rendering
- [x] Aesthetic images
- [x] Masonry grid

### Phase 2: Intelligence Layer ✅
**Goal**: Serendipity algorithm + perspective analysis
**Status**: Complete

- [x] Sentence-BERT embeddings
- [x] Vector similarity search
- [x] Bloom algorithm (0.3-0.8 zone)
- [x] Reason tag generation
- [x] Perspective overlay UI
- [x] 3D flip animation

### Phase 3: Finite Experience ✅
**Goal**: Daily limits + completion celebration
**Status**: Complete

- [x] Backend pagination
- [x] Daily limit enforcement (20 cards)
- [x] Completion object
- [x] CompletionWidget
- [x] Read state tracking
- [x] Progress indicators

### Phase 4: Polish & Testing 🚧
**Goal**: Edge case handling + stability
**Status**: In Progress

- [x] Design system documentation
- [ ] Poison pill tests
- [ ] Error boundary testing
- [ ] Performance optimization
- [ ] Production deployment

---

## Next Steps

### Immediate (Week 1)
1. ✅ Complete STORY-007 implementation
2. ✅ Update all documentation
3. 🚧 Finish STORY-005 (poison pill tests)
4. 🔜 Run end-to-end testing

### Short Term (Weeks 2-4)
- [ ] Complete STORY-005 acceptance criteria
- [ ] Add more OWID datasets (renewable energy, poverty, education)
- [ ] Expand Are.na channels for aesthetic diversity
- [ ] Performance profiling (Flutter DevTools)
- [ ] Production deployment preparation

### Medium Term (Months 2-3)
- [ ] Integrate OpenAlex (science papers)
- [ ] Real bias detection with PoliticalBiasBERT
- [ ] Constructiveness scoring model
- [ ] User authentication & profiles
- [ ] Reading history analytics

### Long Term (Months 4-6)
- [ ] Neocities integration (indie web)
- [ ] TVTropes integration (narrative analysis)
- [ ] My-MOOC integration (education)
- [ ] Blindspot clustering algorithm
- [ ] Public beta launch

---

## Risk Log

| Risk | Impact | Mitigation | Status |
|------|--------|------------|--------|
| pgvector performance degrades with scale | High | Benchmark with 100k+ vectors, optimize indexes | ✅ Addressed (IVFFlat index) |
| OWID API rate limits | Medium | Cache datasets, batch fetch overnight | ✅ No limits observed |
| Are.na API instability | Low | Fallback to local cache, graceful degradation | ⏳ To monitor |
| Flutter performance on low-end devices | Medium | Profile on older Android devices, optimize | 🔜 Planned |
| Daily limit feels too restrictive | Medium | A/B test 20 vs 30, add user setting | ⏳ To validate |

---

## Metrics & KPIs

### Development Velocity
- **Stories completed**: 6/7 (86%)
- **Average story duration**: ~2 days
- **Blocker rate**: 0 (no major blockers)

### Code Quality
- **Test coverage**: Backend ~60%, Frontend ~40% (target: 80%)
- **Linter compliance**: 100% (Ruff for Python, Dart analyzer for Flutter)
- **Documentation**: All major features documented

### Technical Debt
- [ ] Refactor OWID connector for modularity
- [ ] Extract chart config into shared theme
- [ ] Add integration tests for feed pagination
- [ ] Implement proper error logging (Sentry)

---

## Team Responsibilities

### Backend (Python/FastAPI)
- **Owner**: Backend Team
- **Focus**: Ingestion, analysis, curation services
- **Stories**: 001, 004, 006 (backend), 007 (backend)

### Frontend (Flutter/Dart)
- **Owner**: Mobile Team
- **Focus**: UI/UX, state management, animations
- **Stories**: 002, 003, 006 (frontend), 007 (frontend)

### QA (Testing)
- **Owner**: QA Team
- **Focus**: Edge cases, performance, stability
- **Stories**: 005

---

**Version**: 1.0
**Last Updated**: 2025-11-19
**Maintained by**: Project Management Team
