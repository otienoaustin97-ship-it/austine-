#!/bin/bash

# Run database migrations in order
echo "Starting database migrations..."

for migration in $(ls ../db/migrations/*.sql | sort); do
    echo "Executing $migration..."
    psql -U your_username -d your_database -f $migration
done

echo "Database migrations completed."