-- Create necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create enum types
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'refunded');
CREATE TYPE staff_role AS ENUM ('cleaner', 'supervisor', 'manager', 'admin');

-- Create tables with enhanced features
CREATE TABLE service_areas (
    area_id SERIAL PRIMARY KEY,
    area_name VARCHAR(100) NOT NULL,
    geometry geometry(POLYGON, 4326),
    active BOOLEAN DEFAULT true
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT NOT NULL,
    location geometry(POINT, 4326),
    loyalty_points INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE service_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES service_categories(category_id),
    service_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    duration_hours INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role staff_role NOT NULL,
    hire_date DATE NOT NULL,
    termination_date DATE,
    hourly_rate DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE staff_skills (
    staff_id INTEGER REFERENCES staff(staff_id),
    service_id INTEGER REFERENCES services(service_id),
    skill_level INTEGER CHECK (skill_level BETWEEN 1 AND 5),
    PRIMARY KEY (staff_id, service_id)
);

CREATE TABLE availability (
    availability_id SERIAL PRIMARY KEY,
    staff_id INTEGER REFERENCES staff(staff_id),
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    CONSTRAINT valid_time_range CHECK (end_time > start_time)
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4(),
    customer_id INTEGER REFERENCES customers(customer_id),
    service_id INTEGER REFERENCES services(service_id),
    staff_id INTEGER REFERENCES staff(staff_id),
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    status booking_status DEFAULT 'pending',
    total_price DECIMAL(10,2) NOT NULL,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id),
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    status payment_status DEFAULT 'pending',
    transaction_id VARCHAR(100)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_published BOOLEAN DEFAULT true
);

CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    max_uses INTEGER,
    current_uses INTEGER DEFAULT 0
);

-- Create indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_bookings_date ON bookings(booking_date);
CREATE INDEX idx_staff_active ON staff(is_active);
CREATE INDEX idx_services_active ON services(is_active);
CREATE INDEX idx_payments_status ON payments(status);