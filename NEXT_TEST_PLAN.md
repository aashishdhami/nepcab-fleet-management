# NepCab v3 testing checklist

## A. Before Supabase migration
- [ ] Back up the Supabase project.
- [ ] Run `supabase/inspect_live_schema.sql` and review current columns and RLS policies.
- [ ] Confirm the existing `public.rides` schema matches the assumptions documented in `migration_v3.sql`.
- [ ] Do not run the migration if required legacy columns or constraints differ; adjust it first.

## B. Local run
- [ ] `npm install`
- [ ] `npm run dev`
- [ ] Confirm all 11 navigation sections render.
- [ ] Confirm local demo data survives a browser refresh.

## C. Supabase connection
- [ ] Run the reviewed `supabase/migration_v3.sql`.
- [ ] Copy `.env.example` to `.env.local` and enter Supabase URL + publishable/anon key.
- [ ] Create an Auth email/password staff user.
- [ ] Restart Vite and sign in.
- [ ] Add a test owner, vehicle and driver; refresh and verify persistence.

## D. Core workflows
- [ ] Owner validation, edit, deactivate and reactivate.
- [ ] Vehicle registration accepts free text; owner selector shows name and phone; edit vehicle.
- [ ] Driver validation, optional zero salary, compensation agreement effective date.
- [ ] Daily reading: searchable selectors, duplicate prevention, edit, delete, historical interval calculations.
- [ ] Ride: required fields, generated unique ID, same-fare checkbox, commission stored, edit, delete, date filters, sorting, CSV.
- [ ] Expense: custom category, vehicle-only, driver-only and both-linked expense; reject neither-linked; vehicle/driver history totals.
- [ ] Driver payroll: salary + saved ride commission, partial payment, carry-forward balance, settlement history.
- [ ] Owner settlement: fleet and per-vehicle breakdown, vehicle expense deductions, partial payment, carry-forward balance, history.
- [ ] Reports and dashboard totals reconcile with the underlying module records.

## E. Financial test scenario
Create one test owner, one vehicle and one driver. Add rides and expenses with known amounts. Verify:
- NepCab commission = stored effective rate × agreed fare.
- Driver commission follows the driver's effective agreement.
- Owner net = gross agreed fares − NepCab commission − driver ride commission − all expenses linked to the owner's vehicles.
- Driver and owner partial payments reduce balances only once.
- A change to a future commission rate does not rewrite existing ride commission amounts.

Do not use real payroll or owner settlement values until these tests pass and the owner confirms the proposed 10% commission policy.
