# Database Initialization Scripts

Place SQL scripts here to be executed when PostgreSQL container starts for the first time.

Scripts are executed in alphabetical order.

## Example

```sql
-- 01_create_extensions.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgvector";
```

## Notes

- Scripts only run on initial database creation
- To re-run, you must remove the PostgreSQL volume
- For migrations, use Alembic instead
