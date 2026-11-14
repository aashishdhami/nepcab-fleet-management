# NepCab v3.0.3 — Driver compensation schema alignment

This patch aligns the driver compensation agreement adapter with the live Supabase table definition confirmed on 2026-11-13.

## Confirmed live columns
- `driver_id`
- `effective_from` (required)
- `effective_to` (nullable)
- `monthly_salary` (numeric, default 0)
- `commission_type` (`none`, `percentage`, `fixed_per_ride`)
- `commission_value` (numeric, default 0)
- `notes` (nullable)

## Application mapping
- UI `fixedMonthlySalary` / `salary` -> database `monthly_salary`
- UI `None` -> `none`
- UI `Percentage` -> `percentage`
- UI `Fixed per ride` -> `fixed_per_ride`
- Database commission values are converted back to the UI labels when loaded.

No SQL changes are required for this patch. Preserve your existing `.env` file when replacing the local project.
