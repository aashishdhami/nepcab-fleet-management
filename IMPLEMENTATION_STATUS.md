# v3.2.0 implementation status

## Prepared in this baseline
- Fresh Supabase schema aligned to the current React application's table and column names.
- Strict unique vehicle-to-driver assignment enforced by `vehicles.assigned_driver_id NOT NULL UNIQUE`.
- Daily reading records store the assigned `driver_id`, not a user-selected morning driver.
- Separate multi-day `vehicle_bookings` table with booking date, number of days, vehicle, driver, owner, passenger phone, total amount, status, and commission snapshots.
- Unified expenses table with a check constraint requiring exactly one vehicle or driver association.
- RLS policies for authenticated staff and audit logging.
- Frontend mappings updated for the new `driver_id` daily-reading field and `expense_type` field.
- Project version set to 3.2.0.

## Still required before release
- Integrate and test a BS calendar component across every date field, date display, date/month filter, and report.
- Review and correct all date-dependent logic so the BS display maps to the correct AD database date.
- Verify all module queries and calculations against this clean schema.
- Run `npm install` and `npm run build` in the user's environment; package registry access was unavailable in this workspace.
- Test with a new Supabase project and sample records.
- Verify payroll and owner settlement calculations, especially the commission treatment for multi-day bookings.
- Perform a full owner acceptance test before production deployment.

## Do not deploy yet
This is a development baseline, not a production-ready release. Keep the existing deployed app and existing Supabase project untouched until the new version passes all checks.
