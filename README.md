# NepCab v3.3.9 — Configurable Commission Alignment

## Included
- Reads the complete `commission_rates` history and selects the NepCab commission rate effective on the ride/booking BS date.
- Keeps NepCab commission configurable globally in Settings. New rates are prospective; transaction snapshots preserve the rate and amount already applied.
- Maps persisted multi-day booking commission snapshots back into the application so Driver Payroll and Owner Settlements can include them.
- Percentage-based driver commission is calculated on the full booking gross amount.
- `fixed_per_ride` driver commission is calculated per booking day (`fixed amount × number of days`).
- Existing per-driver salary and commission agreements remain configurable independently.
- No schema change is required.

## Important historical-data note
The app now calculates fixed-per-ride booking commissions per day from the saved agreement snapshot. If you want the stored Supabase `driver_commission_amount` column to match for old multi-day fixed-per-ride bookings, run the optional `supabase/migrations/v3.3.9_commission_alignment.sql` once in the Supabase SQL Editor. It changes only rows with `driver_commission_type = 'fixed_per_ride'` and more than one day.

## Verification checklist
1. Open an existing percentage-based multi-day booking and verify the saved NepCab and driver commission amounts appear in Owner Settlements and Driver Payroll.
2. For a 4-day booking with NPR 6,043 gross, 10% NepCab and 10% driver commission should each be NPR 604.30; owner net before expenses should be NPR 4,834.40.
3. Create a new booking and confirm both commission amounts are stored in `vehicle_bookings`.
4. Change the global NepCab rate in Settings; confirm only transactions dated on/after the new effective date use the new rate.
5. Change an individual driver's salary or commission agreement; confirm other drivers are unaffected.
6. Confirm old rides/bookings retain their saved commission snapshots after a rate change.

Full Vite build must be run locally with `npm install` then `npm run build`.
