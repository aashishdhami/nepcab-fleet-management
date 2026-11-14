# v3 implementation status

## Included in this review build
- Owner, vehicle and driver master records with edit/deactivate/reactivate flows.
- Searchable vehicle and driver selectors.
- Daily odometer/battery entry and per-vehicle reading history; duplicate vehicle/date prevention; consecutive available-reading interval display.
- Ride entry with generated unique ride ID, app/agreed fares, same-fare checkbox, searchable selectors, saved NepCab and driver commissions, CSV export, edit and delete.
- Expense categories stored as records; vehicle/driver optional individually but at least one required; expense histories by vehicle/driver and period.
- Driver payroll and owner settlements with period calculations, partial external payment records and histories.
- Dashboard, central reports, prospective commission settings.
- Supabase Auth and CRUD integration for the listed tables, plus local demo fallback.
- Additive SQL migration and database audit trigger.

## Must be tested against the actual Supabase project
- Existing `public.rides` column constraints and historical rows; migration compatibility must be verified before execution.
- Existing RLS policies and any existing policies with overlapping effects.
- Mapping of legacy rides with no master-record foreign keys. No automatic fuzzy mapping is performed.
- Effective-dated compensation history, salary proration, and any retroactive corrections.
- Owner settlement snapshots and correction/reversal workflow after a payment is recorded.
- Data import and reconciliation before switching from local demo storage.

## Known limitations in this review build
- Custom date-range filters are not yet implemented consistently; payroll and settlements currently use month selectors.
- Editing/deleting expense, payment, and reading records is not yet exposed in every table.
- Driver salary is treated as the monthly fixed amount for the selected month; mid-month proration/attendance rules are not defined.
- Driver commission history is captured when new agreements are saved, but existing historical agreement data must be checked/imported before live payroll.
- Owner settlement totals assume all ride agreed fares are attributable in the internal calculation model; actual cash movement is intentionally out of scope.
- Existing rides that are not linked to a vehicle cannot appear in vehicle-owner settlements until manually linked.
- The proposed 10% commission rule remains pending owner confirmation.

Do not treat this build as production-ready until the Supabase migration, historical data, RLS, and financial test cases are verified.


## Supabase compatibility patch v3.0.1
- Corrected application table references to match the fresh schema (`driver_payments`, `owner_payments`, `commission_rates`).
- Added field adapters for master records, agreements, readings, rides, expenses and settlement records.
- Added ride display-name enrichment from vehicle/driver master records.
- This is a compatibility patch, not a claim of complete end-to-end verification. Test each workflow before production use.


## v3.0.3 driver compensation schema correction
- Corrected agreement writes to use the live `monthly_salary` column, not `fixed_monthly_salary`.
- Commission type values are serialized to the database constraint values `none`, `percentage`, and `fixed_per_ride`.
- No database migration required. Live save still needs user verification.


## v3.0.4 Rides agreement reference fix
- Corrected fallback logic that could pass a driver UUID as `driver_agreement_id`.
- Ride submission now requires a compensation agreement effective on the ride date and gives a clear validation message when none exists.
- No database migration required.
