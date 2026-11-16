# NepCab Fleet Management v3.3.0 — BS-Only Edition

## Calendar contract
- Business dates use fixed-width Bikram Sambat strings: `YYYY-MM-DD`.
- Business month/period keys use `YYYY-MM`.
- The UI uses English digits and English-transliterated BS month names.
- Ride date and ride time are separate values (`ride_date_bs`, `ride_time`).
- Payment business date (`paid_date_bs`) and settlement period (`period_bs`) are distinct from audit timestamp (`paid_at`).
- `created_at` and `updated_at` remain PostgreSQL `timestamptz` audit fields.
- PostgreSQL `DATE` is intentionally not used for BS values because it represents Gregorian dates.

## Changed database columns
- `driver_compensation_agreements.effective_from_bs`, `effective_to_bs`
- `commission_rates.effective_from_bs`
- `daily_vehicle_readings.reading_date_bs`
- `rides.ride_date_bs`, `ride_time`
- `vehicle_bookings.booking_date_bs`
- `expenses.expense_date_bs`
- `driver_payments.period_bs`, `paid_date_bs`
- `owner_payments.period_bs`, `paid_date_bs`

## Installation warning
`supabase/schema.sql` is a **fresh schema** intended for the empty development database. It is not a migration for an existing database. Do not run it over a database containing records. The SQL enforces canonical string shape and broad month/day limits; the calendar library validates real BS dates and month lengths at selection time.

## Build status
A production build has not been certified in this environment: dependency installation timed out. Run `npm install` (to resolve the new calendar dependencies and refresh the lockfile), then `npm run build` locally before deploying. Then verify date save/reload, BS month filters, BS effective-date comparisons, payroll, owner settlements, and CSV exports.
