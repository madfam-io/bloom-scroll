"""Main API router combining all endpoint modules."""

from typing import Any, Dict, List, Optional

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.api import ingestion, interactions
from app.core.database import get_db
from app.models.bloom_card import BloomCard
from app.curation.bloom_algorithm import BloomAlgorithm

router = APIRouter()

# Include sub-routers
router.include_router(ingestion.router)
router.include_router(interactions.router)

# STORY-007: The Finite Feed
# Hard-coded daily limit to prevent infinite scrolling
DAILY_LIMIT = 20


@router.get("/feed")
async def get_feed(
    user_context: Optional[List[str]] = Query(
        None,
        description="IDs of recently viewed cards (for serendipity scoring)"
    ),
    page: int = Query(1, ge=1, description="Page number (1-indexed)"),
    read_count: int = Query(0, ge=0, description="Number of cards already read today"),
    limit: int = Query(10, ge=1, le=20, description="Cards per page (max 20)"),
    db: AsyncSession = Depends(get_db),
) -> Dict[str, Any]:
    """
    Generate a bloom feed session with serendipity scoring and finite pagination.

    STORY-007: The Finite Feed
    - Daily limit of 20 cards to prevent infinite scrolling
    - Returns completion object when limit reached
    - Pagination enforces "The End" as the product

    Returns a finite feed optimized for:
    - High serendipity score (avoids echo chambers)
    - Source diversity
    - Visual rhythm

    If user_context is provided (IDs of last 5 viewed cards), the algorithm
    will return cards in the "Serendipity Zone": different enough to be novel,
    close enough to be understood.

    Args:
        user_context: Optional list of recently viewed card IDs
        page: Page number (1-indexed)
        read_count: Number of cards already read today (for limit enforcement)
        limit: Cards per page (default: 10, max: 20)
        db: Database session

    Returns:
        Feed response with cards, pagination metadata, and optional completion object
    """
    # Enforce daily limit
    remaining_cards = DAILY_LIMIT - read_count

    # If already at or over limit, return completion immediately
    if remaining_cards <= 0:
        return {
            "cards": [],
            "pagination": {
                "page": page,
                "limit": limit,
                "has_next_page": False,
                "total_read_today": read_count,
                "daily_limit": DAILY_LIMIT,
            },
            "completion": {
                "type": "COMPLETION",
                "message": "The Garden is Watered.",
                "subtitle": "You've reached today's limit. Return tomorrow for fresh blooms.",
                "stats": {
                    "read_count": read_count,
                    "daily_limit": DAILY_LIMIT,
                },
            },
        }

    # Adjust limit to not exceed daily cap
    effective_limit = min(limit, remaining_cards)

    # Use Bloom Algorithm for serendipity scoring
    bloom = BloomAlgorithm(
        min_distance=0.3,  # Minimum distance to avoid echo chamber
        max_distance=0.8,  # Maximum distance to avoid irrelevance
    )

    cards = await bloom.generate_feed(
        session=db,
        user_context_ids=user_context,
        limit=effective_limit,
    )

    # Calculate context vector for reason tag generation
    context_vector = None
    if user_context:
        context_vector = await bloom._calculate_user_context(db, user_context)

    # Convert cards to dict with perspective metadata
    cards_data = []
    for card in cards:
        # Calculate reason tag based on serendipity context
        reason_tag = bloom.calculate_reason_tag(card, context_vector)
        cards_data.append(card.to_dict(include_meta=True, reason_tag=reason_tag))

    # Calculate new read count
    new_read_count = read_count + len(cards_data)
    has_next_page = new_read_count < DAILY_LIMIT

    response: Dict[str, Any] = {
        "cards": cards_data,
        "pagination": {
            "page": page,
            "limit": effective_limit,
            "has_next_page": has_next_page,
            "total_read_today": new_read_count,
            "daily_limit": DAILY_LIMIT,
        },
        "serendipity_enabled": bool(user_context),
    }

    # Add completion object if we've reached the limit
    if not has_next_page:
        response["completion"] = {
            "type": "COMPLETION",
            "message": "The Garden is Watered.",
            "subtitle": "You've reached today's limit. Return tomorrow for fresh blooms.",
            "stats": {
                "read_count": new_read_count,
                "daily_limit": DAILY_LIMIT,
            },
        }

    return response


@router.get("/perspective/{card_id}")
async def get_perspective(card_id: str) -> Dict[str, str]:
    """
    Get perspective overlay for a specific card.

    Includes:
    - Bias classification scores
    - Blindspot detection
    - Related data context
    """
    return {
        "message": f"Perspective for card {card_id} - Coming soon",
    }
