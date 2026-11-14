# NepCab v3.0.4 — Rides driver-agreement relationship fix

## Root cause
The Rides module selected the compensation agreement effective on the ride date, but if none existed it incorrectly fell back to the driver master record. The ride then submitted the driver's UUID as `driver_agreement_id`. That UUID belongs to `drivers`, not `driver_compensation_agreements`, so PostgreSQL correctly rejected it with `rides_driver_agreement_id_fkey`.

## Fix
- Only return an actual `driver_compensation_agreements` record as the agreement for a ride.
- Never substitute a driver master-record ID for a compensation-agreement ID.
- If no agreement is effective on the ride date, show a clear validation message and do not submit the ride with an incorrect foreign key or silently calculate zero commission.
- No SQL migration or changes to existing database records are required.

## Test
1. Run `npm install` and `npm run dev`.
2. Open Drivers and check the selected driver's agreement effective-from/effective-to dates.
3. On Rides, select a ride date within that agreement's effective period.
4. Select a vehicle and driver from the actual dropdown results (not just type into the search box).
5. Save the ride and verify it appears in `public.rides` with a `driver_agreement_id` that matches a row in `public.driver_compensation_agreements`.
6. Try a date before the agreement's effective-from date. The app should show the clear validation message instead of a PostgreSQL foreign-key error.

Do not weaken or remove the foreign-key constraint.
