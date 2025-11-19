"""Main API router combining all endpoint modules."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/feed")
async def get_feed() -> dict[str, str]:
    """
    Generate a new bloom feed session.

    Returns a finite feed of ~20 cards optimized for:
    - High serendipity score
    - Source diversity
    - Visual rhythm
    """
    return {
        "message": "Feed endpoint - Coming soon",
        "session_id": "placeholder",
    }


@router.get("/perspective/{card_id}")
async def get_perspective(card_id: str) -> dict[str, str]:
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
