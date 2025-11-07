CREATE OR REPLACE FUNCTION fn_cancel_booking(booking_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM bookings
    WHERE id = booking_id;

    RAISE NOTICE 'Booking with ID % has been canceled.', booking_id;
END;
$$ LANGUAGE plpgsql;