-- This SQL script initializes the database for the GleamCleaning Solutions booking system.

-- Create the initial schema
CREATE SCHEMA IF NOT EXISTS booking;

-- Run migrations to create tables
\i /db/migrations/V1__create_schema.sql;
\i /db/migrations/V2__create_tables.sql;
\i /db/migrations/V3__add_indexes.sql;

-- Seed the database with initial data
\i /db/seeds/seed_services.sql;
\i /db/seeds/seed_sample_data.sql;