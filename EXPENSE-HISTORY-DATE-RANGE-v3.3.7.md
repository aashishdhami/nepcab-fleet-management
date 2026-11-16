# NepCab v3.3.7 — Expense History Date-Range Export

## Change
Expense History now mirrors Ride History's date-range export controls.

- Retains BS month filtering (including All Months) and expense search.
- Adds BS Export start date and Export end date fields.
- Adds Use selected month to populate the range from the selected month; when All Months is selected, it uses the current BS month.
- Export CSV exports expenses whose saved BS date falls inclusively within the selected start/end dates.
- Rejects missing dates and start dates later than end dates.
- CSV includes date, type, category, vehicle, associated driver, description and amount.
- Existing table filtering, edit/delete, form behavior and Supabase schema are unchanged.

No database migration is required.
