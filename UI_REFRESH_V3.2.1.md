# NepCab Fleet Management v3.2.1 — UI refresh

This release is a visual-only refresh based on the v3.2.0 foundation.

## Visual updates
- More polished navy sidebar and clearer active navigation state.
- Warmer, calmer page background and consistent card surfaces.
- More readable page headings and descriptions.
- Larger, clearer form labels and input controls with accessible focus states.
- More refined tables with uppercase column headings, improved spacing, and row hover states.
- Improved summary cards, report navigation cards, settings panels, modal dialogs, and login screen.
- Responsive spacing refinements for smaller screens.
- Updated displayed application version to v3.2.1.

## Scope boundary
No business logic, database schema, Supabase queries, calculations, or workflows were intentionally changed in this UI-only release. Existing functionality and any existing database issues remain to be tested in a later step.

## Build status
A production build could not be verified in this environment because `npm ci` did not complete before the package installation timeout. Run locally:

```bash
npm ci
npm run build
npm run dev
```

Review all screens visually before deploying. This is a development preview, not a production release.
