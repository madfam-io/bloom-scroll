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


@router.get("/feed")
async def get_feed(
    user_context: Optional[List[str]] = Query(
        None,
        description="IDs of recently viewed cards (for serendipity scoring)"
    ),
    limit: int = Query(20, ge=1, le=50, description="Number of cards to return"),
    db: AsyncSession = Depends(get_db),
) -> Dict[str, Any]:
    """
    Generate a bloom feed session with serendipity scoring.

    Returns a finite feed optimized for:
    - High serendipity score (avoids echo chambers)
    - Source diversity
    - Visual rhythm

    If user_context is provided (IDs of last 5 viewed cards), the algorithm
    will return cards in the "Serendipity Zone": different enough to be novel,
    close enough to be understood.

    Args:
        user_context: Optional list of recently viewed card IDs
        limit: Number of cards to return (default: 20, max: 50)
        db: Database session

    Returns:
        Feed response with cards and metadata
    """
    # Use Bloom Algorithm for serendipity scoring
    bloom = BloomAlgorithm(
        min_distance=0.3,  # Minimum distance to avoid echo chamber
        max_distance=0.8,  # Maximum distance to avoid irrelevance
    )

    cards = await bloom.generate_feed(
        session=db,
        user_context_ids=user_context,
        limit=limit,
    )

    return {
        "message": "Feed generated with serendipity scoring" if user_context else "Feed generated (no context)",
        "session_id": "placeholder",
        "cards": [card.to_dict() for card in cards],
        "count": len(cards),
        "serendipity_enabled": bool(user_context),
    }


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
