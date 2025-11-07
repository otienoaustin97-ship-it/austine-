.PHONY: migrate seed test

migrate:
	@echo "Running database migrations..."
	psql -U $$DB_USER -d $$DB_NAME -f db/migrations/V1__create_schema.sql
	psql -U $$DB_USER -d $$DB_NAME -f db/migrations/V2__create_tables.sql
	psql -U $$DB_USER -d $$DB_NAME -f db/migrations/V3__add_indexes.sql

seed:
	@echo "Seeding the database..."
	psql -U $$DB_USER -d $$DB_NAME -f db/seeds/seed_services.sql
	psql -U $$DB_USER -d $$DB_NAME -f db/seeds/seed_sample_data.sql

test:
	@echo "Running tests..."
	psql -U $$DB_USER -d $$DB_NAME -f tests/pgtap/001_booking_tests.sql