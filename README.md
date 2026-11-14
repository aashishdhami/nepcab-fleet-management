# NepCab Fleet Management v3

React + Vite fleet and ride management application. Supports local demo mode and authenticated Supabase persistence.

## Run locally

1. Install Node.js 20+.
2. Extract the ZIP and open this folder in VS Code.
3. Open the VS Code terminal in the project folder.
4. Run:

```bash
npm install
npm run dev
```

5. Open the local URL printed by Vite (normally http://localhost:5173).

## Connect Supabase

1. Back up your Supabase project first.
2. Open `supabase/migration_v3.sql` and review it against your current schema. It is additive and retains the existing `public.rides` table and legacy columns; it does not attempt to fuzzy-match historical text-only rides to owners, vehicles or drivers.
3. Run the migration in Supabase SQL Editor.
4. In the project root, copy `.env.example` to `.env.local`.
5. Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` to your project URL and publishable/anon key.
6. Create a staff user in Supabase Authentication (email/password).
7. Restart Vite (`Ctrl+C`, then `npm run dev`) and sign in.

Never put a Supabase `service_role` key in this frontend.

## Important financial policy assumptions

- Proposed NepCab commission: 10% of agreed fare on Online and Offline rides. This remains subject to owner confirmation. The rate can be changed prospectively in Settings; each new ride stores the applied rate and amount.
- Driver commission is calculated from the effective driver compensation agreement and stored on the ride.
- All expenses linked to a vehicle reduce that vehicle owner's calculated earnings. An expense linked to both vehicle and driver is counted once in owner expenses.
- Passenger cash handling is outside the system. The system records calculated ride revenue and payable amounts; it does not claim to reconcile physical cash.
- Driver and owner settlement entries are records of payments made outside the application. Partial settlements are supported.
- Fare difference (App fare minus agreed fare) is not treated as debt or receivable.

## Data safety notes

- Owners, vehicles and drivers are deactivated rather than removed through their master screens.
- Ride deletion is available as requested. A database audit trigger records inserts, updates and deletes in `audit_log`.
- Historical rides from the old table are preserved. Old rides without `vehicle_id`/`driver_id` are not automatically linked; link them only after manual verification.
- Local demo data is stored in browser localStorage. Supabase mode uses authenticated database reads/writes.

## Build

```bash
npm run build
```

This release is a review build. Complete the supplied testing checklist and confirm commission policy with the owner before production use.
