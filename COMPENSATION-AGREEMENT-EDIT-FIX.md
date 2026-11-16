# v3.3.3 — Compensation agreement edit-selection fix

## Fixed
- The Vehicles & Drivers editor now identifies the agreement row to edit using its `created_at` record timestamp, with effective date as a fallback.
- This prevents an older agreement whose effective date is later chronologically from overriding a more recently created retroactive correction when reopening the editor.
- The selected agreement UUID is carried through the form; saving uses an UPDATE against that UUID, rather than inserting another agreement.
- The Drivers master edit flow uses the same record-selection rule.
- Historical agreement rows are preserved. No schema migration is required.

## Important existing-data note
This change does not delete or merge existing rows. If earlier versions created duplicate agreement rows, inspect them before any manual cleanup. Do not delete legitimate historical agreements.

## Verification status
The ZIP archive integrity was checked. Dependency installation timed out in this environment, so `npm run build` could not be completed here. Run `npm ci` (or `npm install`) and `npm run build` locally before deployment.

## Suggested regression test
1. Open an existing vehicle/driver with more than one agreement row.
2. Edit the agreement date from `2083-07-01` to `2083-06-15`.
3. Save, then reopen the same vehicle/driver.
4. Confirm the editor shows `2083-06-15`.
5. Check Supabase: the selected agreement UUID should have its `effective_from_bs` updated; no extra row should be inserted by this edit.
6. Confirm older legitimate agreement rows remain available for rides/payroll dated in their effective periods.
