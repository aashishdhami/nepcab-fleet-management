# NepCab v3.4.3 — Financial report exports

## Changes
- Added section-level CSV exports to the driver earnings report: monthly earnings history, ride and booking commission details, and payment history.
- Added section-level CSV exports to the owner financial report: vehicle-wise breakdown, ride and booking transactions, vehicle expense records, and owner settlement payments.
- The existing report-level export remains available. The owner report-level export now exports a compact selected-month financial summary.
- Report month selectors remain BS month selectors; selecting a month refreshes the report sections.
- Payment-history tables and their exports use the actual BS payment date for the selected month and retain the related payroll/settlement period as a separate column.
- No database schema or financial calculation changes.

## Notes
Install dependencies with `npm install`, configure the existing `.env` values, then run `npm run dev` or `npm run build`.
