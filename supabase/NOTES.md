# Supabase setup notes

1. Back up the live project.
2. Run `inspect_live_schema.sql` first and review the current `rides` columns and RLS policies.
3. Review `migration_v3.sql` against those results before executing it. The migration is additive and intentionally preserves the existing `rides` table and its legacy columns.
4. Configure `.env.local` with the project URL and publishable/anon key.
5. Create an authenticated staff account in Supabase Auth.
6. Do not use the service-role key in a browser application.

Historical rides that have only text `driver_name` and `vehicle_number` values are deliberately not auto-matched. Verify and link them to master records manually before including them in owner or driver statements.
