INSERT INTO customers (first_name, last_name, email, phone, created_at) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', NOW()),
('Jane', 'Smith', 'jane.smith@example.com', '098-765-4321', NOW()),
('Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567', NOW()),
('Bob', 'Brown', 'bob.brown@example.com', '555-987-6543', NOW());

INSERT INTO bookings (customer_id, service_id, booking_date, booking_time, status, created_at) VALUES
(1, 1, '2023-10-01', '10:00:00', 'confirmed', NOW()),
(2, 2, '2023-10-02', '11:00:00', 'confirmed', NOW()),
(3, 1, '2023-10-03', '12:00:00', 'pending', NOW()),
(4, 3, '2023-10-04', '13:00:00', 'canceled', NOW());

INSERT INTO services (service_name, description, price, created_at) VALUES
('Standard Cleaning', 'Basic cleaning service for homes.', 100.00, NOW()),
('Deep Cleaning', 'Thorough cleaning service for homes.', 200.00, NOW()),
('Move In/Out Cleaning', 'Cleaning service for moving in or out.', 250.00, NOW());