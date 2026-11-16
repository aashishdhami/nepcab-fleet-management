-- NepCab Fleet Management v3.2.0 — CLEAN PRE-PRODUCTION SCHEMA
-- Use only in a NEW Supabase project. This script intentionally creates the complete schema.
-- All business-calendar values are canonical BS TEXT (YYYY-MM-DD / YYYY-MM).
-- PostgreSQL DATE is Gregorian and must not be used for BS business dates.
-- Audit timestamps remain timestamptz. Frontend uses anon/publishable key only.

create extension if not exists pgcrypto;

create table public.owners (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  address text not null,
  category text not null check (category in ('Local','Remote')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.drivers (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text not null,
  address text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.vehicles (
  id uuid primary key default gen_random_uuid(),
  registration_number text not null unique,
  owner_id uuid not null references public.owners(id),
  assigned_driver_id uuid not null unique references public.drivers(id),
  vehicle_type text not null default 'EV',
  initial_odometer numeric(12,1) not null default 0 check (initial_odometer >= 0),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.driver_compensation_agreements (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.drivers(id),
  effective_from_bs text not null check (effective_from_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  effective_to_bs text check (effective_to_bs is null or effective_to_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  monthly_salary numeric(12,2) not null default 0 check (monthly_salary >= 0),
  commission_type text not null default 'none' check (commission_type in ('none','percentage','fixed_per_ride')),
  commission_value numeric(12,2) not null default 0 check (commission_value >= 0),
  notes text,
  created_at timestamptz not null default now(),
  check (effective_to_bs is null or effective_to_bs >= effective_from_bs)
);
create index driver_agreements_driver_dates_idx on public.driver_compensation_agreements(driver_id,effective_from_bs desc);

create table public.commission_rates (
  id uuid primary key default gen_random_uuid(),
  rate numeric(7,4) not null check (rate between 0 and 100),
  basis text not null default 'final_fare',
  applies_to text not null default 'both',
  effective_from_bs text not null check (effective_from_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  created_at timestamptz not null default now()
);
insert into public.commission_rates(rate,basis,applies_to,effective_from_bs) values (10,'final_fare','both','2000-01-01');

create table public.daily_vehicle_readings (
  id uuid primary key default gen_random_uuid(),
  reading_date_bs text not null check (reading_date_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  vehicle_id uuid not null references public.vehicles(id),
  driver_id uuid not null references public.drivers(id),
  opening_odometer numeric(12,1) not null check (opening_odometer >= 0),
  starting_battery_percent numeric(5,2) check (starting_battery_percent between 0 and 100),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(vehicle_id,reading_date_bs)
);

create table public.rides (
  id uuid primary key default gen_random_uuid(),
  ride_id text not null unique,
  ride_date_bs text not null check (ride_date_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  ride_time time not null,
  booking_type text not null check (booking_type in ('Online','Offline')),
  passenger_phone text,
  vehicle_id uuid not null references public.vehicles(id),
  owner_id uuid not null references public.owners(id),
  driver_id uuid not null references public.drivers(id),
  pickup_location text not null,
  dropoff_location text not null,
  final_fare numeric(12,2) not null check (final_fare >= 0),
  nepcab_commission_rate numeric(7,4) not null default 10,
  nepcab_commission_basis text not null default 'final_fare',
  nepcab_commission_amount numeric(12,2) not null default 0,
  driver_agreement_id uuid references public.driver_compensation_agreements(id),
  driver_commission_type text not null default 'none' check (driver_commission_type in ('none','percentage','fixed_per_ride')),
  driver_commission_value numeric(12,2) not null default 0,
  driver_commission_amount numeric(12,2) not null default 0,
  notes text,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index rides_date_idx on public.rides(ride_date_bs desc,ride_time desc);
create index rides_vehicle_idx on public.rides(vehicle_id);
create index rides_driver_idx on public.rides(driver_id);

create table public.vehicle_bookings (
  id uuid primary key default gen_random_uuid(),
  booking_date_bs text not null check (booking_date_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  number_of_days integer not null check (number_of_days > 0),
  vehicle_id uuid not null references public.vehicles(id),
  driver_id uuid not null references public.drivers(id),
  owner_id uuid not null references public.owners(id),
  passenger_phone text,
  pickup_location text,
  dropoff_location text,
  total_amount numeric(12,2) not null check (total_amount >= 0),
  status text not null default 'Booked' check (status in ('Booked','Completed','Cancelled')),
  nepcab_commission_rate numeric(7,4) not null default 10,
  nepcab_commission_amount numeric(12,2) not null default 0,
  driver_agreement_id uuid references public.driver_compensation_agreements(id),
  driver_commission_type text not null default 'none' check (driver_commission_type in ('none','percentage','fixed_per_ride')),
  driver_commission_value numeric(12,2) not null default 0,
  driver_commission_amount numeric(12,2) not null default 0,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index vehicle_bookings_date_idx on public.vehicle_bookings(booking_date_bs desc);
create index vehicle_bookings_vehicle_idx on public.vehicle_bookings(vehicle_id);

create table public.expense_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique(name)
);
insert into public.expense_categories(name) values
 ('Vehicle charging'),('Vehicle maintenance'),('Driver food'),('Driver allowance'),('Vehicle cleaning'),('Other expenses');

create table public.expenses (
  id uuid primary key default gen_random_uuid(),
  expense_date_bs text not null check (expense_date_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  expense_type text not null check (expense_type in ('Vehicle','Driver')),
  category_id uuid references public.expense_categories(id),
  vehicle_id uuid references public.vehicles(id),
  driver_id uuid references public.drivers(id),
  amount numeric(12,2) not null check (amount > 0),
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((expense_type='Vehicle' and vehicle_id is not null and driver_id is null)
      or (expense_type='Driver' and driver_id is not null and vehicle_id is null))
);

create table public.driver_payments (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.drivers(id),
  period_bs text not null check (period_bs ~ '^\d{4}-(0[1-9]|1[0-2])$'),
  paid_date_bs text not null check (paid_date_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  amount numeric(12,2) not null check (amount > 0),
  paid_at timestamptz not null default now(),
  notes text,
  created_at timestamptz not null default now()
);
create table public.owner_payments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.owners(id),
  period_bs text not null check (period_bs ~ '^\d{4}-(0[1-9]|1[0-2])$'),
  paid_date_bs text not null check (paid_date_bs ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-2])$'),
  amount numeric(12,2) not null check (amount > 0),
  paid_at timestamptz not null default now(),
  statement_snapshot jsonb not null default '{}'::jsonb,
  notes text,
  created_at timestamptz not null default now()
);

create table public.company_settings (
  id uuid primary key default gen_random_uuid(),
  setting_key text not null unique,
  setting_value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table public.audit_log (
  id bigint generated always as identity primary key,
  table_name text not null,
  record_id text not null,
  action text not null,
  changed_at timestamptz not null default now(),
  changed_by uuid references auth.users(id),
  old_data jsonb,
  new_data jsonb
);

create or replace function public.nepcab_audit_row() returns trigger
language plpgsql security definer set search_path=public as $$
begin
  if tg_op='DELETE' then
    insert into public.audit_log(table_name,record_id,action,changed_by,old_data)
    values(tg_table_name,old.id::text,'DELETE',auth.uid(),to_jsonb(old)); return old;
  elsif tg_op='UPDATE' then
    insert into public.audit_log(table_name,record_id,action,changed_by,old_data,new_data)
    values(tg_table_name,new.id::text,'UPDATE',auth.uid(),to_jsonb(old),to_jsonb(new)); return new;
  else
    insert into public.audit_log(table_name,record_id,action,changed_by,new_data)
    values(tg_table_name,new.id::text,'INSERT',auth.uid(),to_jsonb(new)); return new;
  end if;
end $$;

do $$
declare t text;
begin
  foreach t in array array['owners','drivers','vehicles','driver_compensation_agreements','commission_rates','daily_vehicle_readings','rides','vehicle_bookings','expense_categories','expenses','driver_payments','owner_payments','company_settings'] loop
    execute format('create trigger nepcab_audit after insert or update or delete on public.%I for each row execute function public.nepcab_audit_row()',t);
  end loop;
end $$;

do $$
declare t text;
begin
  foreach t in array array['owners','drivers','vehicles','driver_compensation_agreements','commission_rates','daily_vehicle_readings','rides','vehicle_bookings','expense_categories','expenses','driver_payments','owner_payments','company_settings','audit_log'] loop
    execute format('alter table public.%I enable row level security',t);
    execute format('create policy "nepcab authenticated full access" on public.%I for all to authenticated using (true) with check (true)',t);
  end loop;
end $$;
