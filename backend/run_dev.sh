#!/bin/bash
# Development startup script for STORY-001

set -e

echo "🌱 Bloom Scroll Backend - Development Setup"
echo "=========================================="

# Check if Poetry is installed
if ! command -v poetry &> /dev/null; then
    echo "❌ Poetry not found. Please install Poetry first."
    echo "   Visit: https://python-poetry.org/docs/#installation"
    exit 1
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
poetry install

# Wait for PostgreSQL
echo ""
echo "🔍 Waiting for PostgreSQL..."
until PGPASSWORD=postgres psql -h localhost -U postgres -d bloom_scroll -c '\q' 2>/dev/null; do
  echo "   Postgres is unavailable - sleeping"
  sleep 2
done
echo "   ✓ PostgreSQL is ready"

# Run migrations
echo ""
echo "🗄️  Running database migrations..."
poetry run alembic upgrade head

# Start the server
echo ""
echo "🚀 Starting FastAPI server..."
echo "   API Docs: http://localhost:8000/docs"
echo "   Health: http://localhost:8000/health"
echo ""
poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
