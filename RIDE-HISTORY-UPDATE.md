# v3.3.4 — Ride History month filter and date-range export

- Added a BS month selector to Individual Ride History, defaulting to the current BS month.
- Added an All Months option and automatically includes months represented in saved ride records.
- Kept text search active alongside the month filter.
- Added BS start/end date fields and CSV export for all saved rides within the inclusive date range.
- CSV includes ride ID, BS date/time, booking type, vehicle, owner, driver, passenger phone, pickup/drop-off, fare, NepCab commission, driver commission, and notes.
- Added date-range validation and an export row count.
- No database schema or ride-entry logic changes.
