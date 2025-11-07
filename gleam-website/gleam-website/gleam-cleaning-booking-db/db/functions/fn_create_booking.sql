CREATE OR REPLACE FUNCTION fn_create_booking(
    p_customer_id INT,
    p_service_id INT,
    p_booking_date TIMESTAMP,
    p_notes TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO bookings (customer_id, service_id, booking_date, notes)
    VALUES (p_customer_id, p_service_id, p_booking_date, p_notes);
END;
$$ LANGUAGE plpgsql;