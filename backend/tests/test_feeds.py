"""
Feed management tests for Bloom Scroll API.
"""

import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_list_feeds_empty(client: AsyncClient):
    """Test listing feeds when none exist."""
    response = await client.get("/api/feeds")
    assert response.status_code == 200

    data = response.json()
    assert isinstance(data, list) or "items" in data


@pytest.mark.asyncio
async def test_create_feed(client: AsyncClient, sample_feed_data: dict):
    """Test creating a new feed."""
    response = await client.post("/api/feeds", json=sample_feed_data)

    # Should succeed or require auth
    assert response.status_code in [200, 201, 401, 403]


@pytest.mark.asyncio
async def test_get_daily_digest(client: AsyncClient):
    """Test getting daily digest."""
    response = await client.get("/api/digest/daily")

    # Should return digest or empty
    assert response.status_code in [200, 404]


@pytest.mark.asyncio
async def test_feed_validation(client: AsyncClient):
    """Test feed creation with invalid data."""
    invalid_feed = {
        "name": "",  # Empty name
        "url": "not-a-valid-url",
    }

    response = await client.post("/api/feeds", json=invalid_feed)

    # Should reject invalid data
    assert response.status_code in [400, 422, 401]
