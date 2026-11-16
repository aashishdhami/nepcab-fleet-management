-- NepCab Fleet Management v3.1 additive migration
-- BACK UP the Supabase project before applying. This migration preserves existing records.

-- One fixed driver per vehicle; a driver can be assigned to only one vehicle.
alter table public.vehicles
  add column if not exists assigned_driver_id uuid references public.drivers(id);
create unique index if not exists vehicles_assigned_driver_unique
  on public.vehicles(assigned_driver_id)
  where assigned_driver_id is not null;

-- Multi-day bookings are stored separately from individual rides.
create table if not exists public.vehicle_bookings (
  id uuid primary key default gen_random_uuid(),
  booking_date date not null,
  number_of_days integer not null check (number_of_days > 0),
  vehicle_id uuid not null references public.vehicles(id),
  driver_id uuid not null references public.drivers(id),
  owner_id uuid not null references public.owners(id),
  passenger_phone text,
  total_amount numeric(12,2) not null check (total_amount >= 0),
  status text not null default 'Booked' check (status in ('Booked','Completed','Cancelled')),
  nepcab_commission_rate numeric(7,4) not null default 10,
  nepcab_commission_amount numeric(12,2) not null default 0,
  driver_agreement_id uuid references public.driver_compensation_agreements(id),
  driver_commission_type text not null default 'none',
  driver_commission_value numeric(12,2) not null default 0,
  driver_commission_amount numeric(12,2) not null default 0,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.vehicle_bookings enable row level security;
drop policy if exists "nepcab authenticated full access" on public.vehicle_bookings;
create policy "nepcab authenticated full access" on public.vehicle_bookings
  for all to authenticated using (true) with check (true);

-- Audit booking changes using the existing audit function, when installed.
do $$ begin
  if to_regprocedure('public.nepcab_audit_row()') is not null then
    drop trigger if exists nepcab_audit on public.vehicle_bookings;
    create trigger nepcab_audit after insert or update or delete on public.vehicle_bookings
      for each row execute function public.nepcab_audit_row();
  end if;
end $$;
