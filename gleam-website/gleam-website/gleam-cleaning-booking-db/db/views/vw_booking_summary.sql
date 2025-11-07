CREATE VIEW vw_booking_summary AS
SELECT 
    b.id AS booking_id,
    c.name AS customer_name,
    s.service_name,
    b.booking_date,
    b.start_time,
    b.end_time,
    b.status
FROM 
    bookings b
JOIN 
    customers c ON b.customer_id = c.id
JOIN 
    services s ON b.service_id = s.id;