# NepCab v3.3.6 — Expenses improvements

- Added BS month filtering to Expense History, including All Months and months with saved records.
- Kept search working together with the month filter.
- Added Edit action for each expense; updates the existing record by ID.
- Expense history now resolves the assigned driver for vehicle expenses and the assigned vehicle for driver expenses where available.
- Expense form resets to a fresh entry after a successful save or update.
- CSV export exports the currently filtered expense history and includes linked vehicle/driver names.
- No Supabase schema migration required.

The shared `period` state is not changed; the Expenses module keeps its own month filter.
