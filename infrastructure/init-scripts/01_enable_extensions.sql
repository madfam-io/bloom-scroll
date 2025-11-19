-- Enable required PostgreSQL extensions for Bloom Scroll

-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- pgvector for embeddings
CREATE EXTENSION IF NOT EXISTS vector;

-- Useful for JSONB operations
CREATE EXTENSION IF NOT EXISTS btree_gin;
