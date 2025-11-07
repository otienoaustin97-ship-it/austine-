-- 001_booking_tests.sql

BEGIN;

-- Test for creating a booking
SELECT plan(1);
SELECT is(
    fn_create_booking('John Doe', '2023-10-01 10:00:00', 1),
    'Booking created successfully',
    'Create booking test'
);
SELECT * FROM finish();

-- Test for checking availability
SELECT plan(1);
SELECT is(
    fn_check_availability('2023-10-01 10:00:00', 1),
    true,
    'Check availability test'
);
SELECT * FROM finish();

-- Test for canceling a booking
SELECT plan(1);
SELECT is(
    fn_cancel_booking(1),
    'Booking canceled successfully',
    'Cancel booking test'
);
SELECT * FROM finish();

ROLLBACK;