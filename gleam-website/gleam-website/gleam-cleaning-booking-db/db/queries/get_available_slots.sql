SELECT time_slot
FROM available_slots
WHERE service_id = $1
AND date = $2
AND time_slot NOT IN (
    SELECT time_slot
    FROM bookings
    WHERE service_id = $1
    AND date = $2
);