CREATE OR REPLACE FUNCTION fn_check_availability(service_id INT, check_date DATE, check_time TIME)
RETURNS BOOLEAN AS $$
DECLARE
    booking_count INT;
BEGIN
    SELECT COUNT(*)
    INTO booking_count
    FROM bookings
    WHERE service_id = fn_check_availability.service_id
      AND booking_date = fn_check_availability.check_date
      AND booking_time = fn_check_availability.check_time;

    RETURN booking_count = 0;
END;
$$ LANGUAGE plpgsql;