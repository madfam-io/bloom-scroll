"""Main API router combining all endpoint modules."""

from typing import Any, Dict

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.api import ingestion
from app.core.database import get_db
from app.models.bloom_card import BloomCard

router = APIRouter()

# Include sub-routers
router.include_router(ingestion.router)


@router.get("/feed")
async def get_feed(db: AsyncSession = Depends(get_db)) -> Dict[str, Any]:
    """
    Generate a new bloom feed session.

    Returns a finite feed of ~20 cards optimized for:
    - High serendipity score
    - Source diversity
    - Visual rhythm
    """
    # For now, just return all cards
    result = await db.execute(select(BloomCard).order_by(BloomCard.created_at.desc()).limit(20))
    cards = result.scalars().all()

    return {
        "message": "Feed endpoint - Basic implementation",
        "session_id": "placeholder",
        "cards": [card.to_dict() for card in cards],
        "count": len(cards),
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
