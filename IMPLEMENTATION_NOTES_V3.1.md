# NepCab Fleet Management v3.1 — Development Notes

This is a development update based on v3.0.4. Do not deploy to production until the migration and build/test checklist below is complete.

## Implemented in this draft
- Combined `Vehicles & Drivers` page and joint registration/edit form.
- Existing drivers can be selected while pairing existing fleet records; new drivers can be created in the same form.
- Vehicle records store `assigned_driver_id`; one driver can only be assigned to one vehicle (unique index).
- Daily Tracking derives the driver from the selected vehicle and removes the Morning Driver selector.
- Individual rides select a vehicle and derive its assigned driver; Passenger Name is removed from the form; Passenger Phone remains; one Final Fare field is used.
- Added a separate multi-day booking workflow with booking date, number of days, vehicle, auto-filled driver, passenger phone, and one total amount for the entire booking.
- Booking commission values are snapshotted at save time and included in payroll, owner settlements, dashboard and report totals.
- Expenses now use one entry form and one unified history with an explicit Vehicle/Driver type and exactly one linked entity.
- Improved form/table readability and spacing.

## Required Supabase migration
Run `supabase/migration_v3_1.sql` in the Supabase SQL Editor before testing the new application. Back up the project first. The migration is additive and does not delete existing records.

After migration, open Vehicles & Drivers and pair each existing vehicle with its existing driver. Existing vehicle/driver rows are not automatically paired because guessing relationships could corrupt historical financial records.

## Important compatibility notes
- Existing ride database columns `passenger_name`, `app_fare`, and `agreed_fare` are retained for compatibility with the current schema. The UI removes passenger name and exposes only Final Fare; the final fare is written to both legacy fare columns so existing reports and calculations continue to work.
- Existing reading and transaction dates remain stored as Gregorian dates.
- The Bikram Sambat date-picker/display integration is not yet included in this draft. It must be completed across date inputs, table displays, and month/period filters before production deployment. Do not treat this draft as the final BS-calendar release.
- The booking is stored as one record, not split into daily rides. Its driver commission is calculated once using the driver's effective compensation agreement on the booking date; percentage commission uses the total booking amount and fixed-per-ride commission is applied once per booking.

## Validation still required
1. Install dependencies and run `npm run build`.
2. Apply migration in a Supabase backup/test environment.
3. Pair every existing vehicle with the correct existing driver.
4. Test vehicle-driver uniqueness and edit behavior.
5. Test daily tracking, individual rides, and driver auto-fill.
6. Test booking creation/editing and verify payroll/owner settlement/report amounts.
7. Test unified vehicle/driver expense entry and owner deduction rules.
8. Complete BS calendar integration before production.
