# v3.3.8 — Owner Settlement History

- Added BS payment-month filter with All Months to the settlement history table.
- Added owner-name/phone search to settlement history (uses the existing owner search field).
- Added custom BS start/end date CSV export for settlement payments.
- Added Use Selected Month shortcut and visible settlement count.
- Filters and export use the actual payment date; the payroll/settlement period remains a separate displayed field.
- Existing owner earnings, balance, payment recording, and Supabase schema are unchanged.
- No database migration required.
