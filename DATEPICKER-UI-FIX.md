# NepCab v3.3.5 — Shared BS Date Picker UI Fix

This release addresses calendar popup clipping across forms and edit dialogs.

Changes:
- Form panels no longer clip the date picker popup.
- Modal and modal-body overflow constraints no longer cut off calendar rows.
- The modal overlay can scroll vertically on shorter viewports.
- Date picker stacking order is raised so the calendar appears above nearby form controls.

No application logic, BS date conversion, Supabase schema, or ride export behavior was changed.

Please test date pickers in Add/Edit forms across Daily Tracking, Rides, Multi-day Bookings,
Expenses, Driver Compensation, and other forms. Verify the final week is visible and that
the modal remains scrollable on a smaller viewport.
