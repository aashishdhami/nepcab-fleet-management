# NepCab Fleet Management v3.3.0 — BS-only handover candidate

## Fresh setup
1. Create a NEW Supabase project.
2. Open Supabase SQL Editor and run `supabase/schema.sql` in one go.
3. Copy `.env.example` to `.env` and fill in the Project URL and publishable/anon key.
4. Never put the `service_role` or secret key in the frontend.
5. Install and run:
   ```bash
   npm ci
   npm run build
   npm run dev
   ```
6. Open the localhost URL printed by Vite.

## Important release status
This package is a handover candidate, not a production-certified release. Dependency installation/build could not be completed in the preparation environment. Run the commands above and resolve any build/runtime errors before deployment.

## BS date storage
Business dates use text fields in canonical Bikram Sambat format (`YYYY-MM-DD`); BS periods use `YYYY-MM`. PostgreSQL `DATE` is Gregorian and is deliberately not used for business dates. Audit timestamps (`created_at`, `updated_at`, `paid_at`) remain `timestamptz`.

The SQL format checks validate shape and broad day bounds; they do not independently validate each month’s actual BS day count. The UI date picker validates selectable dates. For stronger database-side protection, add an authoritative BS calendar table and a validation function before production.

## Security and operations
- Enable Supabase Auth and create the authorized staff login(s).
- The schema grants full table access only to `authenticated`; unauthenticated users do not receive data policies.
- Review staff access requirements before inviting users.
- Configure backups and verify RLS policies before production.
- Do not deploy until the build, CRUD flows, payroll, settlements, and reports have been tested with disposable data.

## First smoke test
Create an owner, driver, and vehicle; create one daily reading and one ride dated `2083-07-15`; reload the app; verify the displayed date and database values remain `2083-07-15`. Then test edit/delete and BS month filtering.
