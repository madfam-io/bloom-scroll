"""Ingestion API endpoints."""

import logging
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.ingestion.owid import OWIDConnector, ingest_all_owid_datasets
from app.schemas.bloom_card import BloomCardResponse

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/ingest", tags=["ingestion"])


@router.post("/owid", response_model=BloomCardResponse)
async def ingest_owid_dataset(
    dataset_key: str = "co2_emissions",
    entity: str = "World",
    years_back: int = 20,
    db: AsyncSession = Depends(get_db),
) -> BloomCardResponse:
    """
    Ingest a single OWID dataset.

    Args:
        dataset_key: Dataset identifier (co2_emissions, life_expectancy, child_mortality)
        entity: Country/region name (default: World)
        years_back: Number of years to fetch (default: 20)

    Returns:
        Created BloomCard

    Example:
        POST /ingest/owid?dataset_key=co2_emissions&entity=World&years_back=20
    """
    connector = OWIDConnector()

    # Check if dataset exists
    if dataset_key not in connector.DATASETS:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown dataset: {dataset_key}. Available: {list(connector.DATASETS.keys())}",
        )

    # Ingest data
    card = await connector.ingest_to_database(db, dataset_key, entity, years_back)

    if not card:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch or process data for {dataset_key}",
        )

    return BloomCardResponse.model_validate(card)


@router.post("/owid/all", response_model=List[BloomCardResponse])
async def ingest_all_owid(
    db: AsyncSession = Depends(get_db),
) -> List[BloomCardResponse]:
    """
    Ingest all available OWID datasets for World entity.

    Returns:
        List of created BloomCards

    Example:
        POST /ingest/owid/all
    """
    cards = await ingest_all_owid_datasets(db)

    if not cards:
        raise HTTPException(
            status_code=500,
            detail="Failed to ingest any OWID datasets",
        )

    return [BloomCardResponse.model_validate(card) for card in cards]


@router.get("/datasets")
async def list_available_datasets() -> dict:
    """
    List all available OWID datasets.

    Returns:
        Dictionary of available datasets with metadata
    """
    connector = OWIDConnector()
    return {
        "datasets": connector.DATASETS,
        "count": len(connector.DATASETS),
    }
