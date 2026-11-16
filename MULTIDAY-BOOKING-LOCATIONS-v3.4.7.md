# NepCab v3.4.7 — Multi-day booking locations

- Added optional From (pickup location) and To (destination) fields to multi-day booking entry and edit forms.
- Locations are stored on `vehicle_bookings` as `pickup_location` and `dropoff_location`.
- Multi-day Booking History displays both fields.
- Multi-day booking CSV exports include both fields.
- These are informational fields only; they do not affect fare, commission, payroll, or owner settlement calculations.

## Database migration required

Run `supabase/migrations/v3.4.7_booking_locations.sql` once in the Supabase SQL Editor before using v3.4.7. Existing bookings remain valid; their location fields will be blank until edited.
