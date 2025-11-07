# GleamCleaning Solutions Booking System

This project is a database booking system for GleamCleaning Solutions, designed to manage bookings, customers, and services efficiently.

## Project Structure

- **db/**: Contains all database-related files.
  - **migrations/**: SQL files for database schema and table creation.
  - **seeds/**: SQL files to populate the database with initial data.
  - **functions/**: SQL functions for booking operations.
  - **views/**: SQL views for summarizing booking information.
  - **queries/**: SQL queries for retrieving data.

- **tools/**: Contains utility scripts for database configuration and migration.
  - **dbconfig.js**: Exports database configuration settings.
  - **migrate.sh**: Shell script to automate database migrations.

- **tests/**: Contains tests for validating the booking system functionality.
  - **pgtap/**: Directory for pgTAP tests.

- **docker/**: Contains files for initializing the database in a Docker container.
  - **init-db/**: SQL file for initializing the database.

- **.env.example**: Example environment variables for the project.

- **.gitignore**: Specifies files and directories to ignore in version control.

- **docker-compose.yml**: Defines services, networks, and volumes for Docker.

- **Makefile**: Automates common tasks like running migrations and tests.

## Setup Instructions

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd gleam-cleaning-booking-db
   ```

2. **Install dependencies** (if applicable).

3. **Configure the database**:
   - Copy `.env.example` to `.env` and update the database connection details.

4. **Run migrations**:
   ```
   ./tools/migrate.sh
   ```

5. **Seed the database** (optional):
   ```
   psql -U <username> -d <database> -f db/seeds/seed_services.sql
   psql -U <username> -d <database> -f db/seeds/seed_sample_data.sql
   ```

6. **Run tests**:
   ```
   psql -U <username> -d <database> -f tests/pgtap/001_booking_tests.sql
   ```

## Usage

- Use the provided SQL functions to create, cancel, and check availability for bookings.
- Query the database using the provided SQL queries to retrieve booking information.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.