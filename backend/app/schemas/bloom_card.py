"""Pydantic schemas for BloomCard."""

from datetime import datetime
from typing import Any, Dict, List, Optional
from uuid import UUID

from pydantic import BaseModel, Field, HttpUrl


class BloomCardBase(BaseModel):
    """Base schema for BloomCard."""

    source_type: str = Field(..., description="OWID, OPENALEX, CARI, NEOCITIES, etc.")
    title: str = Field(..., min_length=1, max_length=500)
    summary: Optional[str] = Field(None, description="LLM-generated summary")
    original_url: str = Field(..., description="Source URL")
    data_payload: Dict[str, Any] = Field(..., description="Polymorphic content data")


class BloomCardCreate(BloomCardBase):
    """Schema for creating a new BloomCard."""

    bias_score: Optional[float] = Field(None, ge=0.0, le=1.0)
    constructiveness_score: Optional[float] = Field(None, ge=0.0, le=100.0)
    blindspot_tags: Optional[List[str]] = None
    embedding: Optional[List[float]] = Field(
        None,
        description="384-dimensional SBERT embedding",
    )


class BloomCardResponse(BloomCardBase):
    """Schema for BloomCard API responses."""

    id: UUID
    bias_score: Optional[float] = None
    constructiveness_score: Optional[float] = None
    blindspot_tags: Optional[List[str]] = None
    created_at: datetime

    class Config:
        from_attributes = True


class OWIDDataPayload(BaseModel):
    """OWID-specific data payload structure."""

    chart_type: str = Field(default="line", description="line, bar, scatter, etc.")
    years: List[int] = Field(..., description="X-axis data")
    values: List[float] = Field(..., description="Y-axis data")
    unit: str = Field(..., description="Unit of measurement")
    indicator: str = Field(..., description="What is being measured")
    entity: str = Field(default="World", description="Country/region name")
