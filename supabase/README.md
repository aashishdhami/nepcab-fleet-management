# Supabase clean install

Run `schema.sql` only in a newly created, empty Supabase project. It is intentionally a full schema script and is not a migration for the current test database.

The application expects authenticated users. Create staff accounts in Supabase Auth. RLS grants authenticated users full access to the operational tables; refine staff roles/permissions if the business later requires role-based access.
