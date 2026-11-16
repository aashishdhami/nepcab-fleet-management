# NepCab Fleet Management v3.3.3

This update fixes selection of the compensation agreement shown when editing a vehicle/driver. It uses the agreement record's creation timestamp to identify the most recently created agreement, rather than choosing solely by effective date. The selected agreement ID is retained for updates.

No Supabase SQL migration is required. Keep your existing `.env.local` and Supabase data. Do not rerun `schema.sql` or migration scripts for this UI/code correction.

## Run locally
```bash
npm ci
npm run build
npm run dev
```

See `COMPENSATION-AGREEMENT-EDIT-FIX.md` for the regression test and verification limitation.
