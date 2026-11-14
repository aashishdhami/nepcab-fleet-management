-- NEPCAB FLEET MANAGEMENT V3 — ADDITIVE MIGRATION
-- BACK UP your Supabase project and inspect existing public.rides before running.
-- This script does not drop tables or remove legacy ride columns/data.
create extension if not exists pgcrypto;

create table if not exists public.owners (
 id uuid primary key default gen_random_uuid(), name text not null, phone text, address text,
 category text check (category in ('Local','Remote')), active boolean not null default true,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.vehicles (
 id uuid primary key default gen_random_uuid(), registration text not null unique,
 owner_id uuid references public.owners(id), vehicle_type text not null default 'EV',
 initial_odometer numeric(12,1) not null default 0, status text default 'Active', active boolean not null default true,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.drivers (
 id uuid primary key default gen_random_uuid(), name text not null, phone text, address text,
 salary numeric(12,2) not null default 0, commission_type text not null default 'None'
   check (commission_type in ('None','Percentage','Fixed per ride')),
 commission_value numeric(12,2) not null default 0, effective_from date,
 active boolean not null default true, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
-- Add new columns safely if the tables existed in an earlier version.
alter table public.owners add column if not exists active boolean not null default true;
alter table public.vehicles add column if not exists status text default 'Active';
alter table public.vehicles add column if not exists initial_odometer numeric(12,1) not null default 0;
alter table public.drivers add column if not exists salary numeric(12,2) not null default 0;
alter table public.drivers add column if not exists commission_type text not null default 'None';
alter table public.drivers add column if not exists commission_value numeric(12,2) not null default 0;
alter table public.drivers add column if not exists effective_from date;
alter table public.drivers add column if not exists active boolean not null default true;

create table if not exists public.daily_vehicle_readings (
 id uuid primary key default gen_random_uuid(), reading_date date not null,
 vehicle_id uuid not null references public.vehicles(id), driver_id uuid references public.drivers(id),
 odometer numeric(12,1) not null check(odometer>=0), battery_percent numeric(5,2) check(battery_percent between 0 and 100),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(vehicle_id,reading_date)
);

-- Preserve all legacy rides. New columns support linked master records and saved financial calculations.
alter table public.rides add column if not exists vehicle_id uuid references public.vehicles(id);
alter table public.rides add column if not exists driver_id uuid references public.drivers(id);
alter table public.rides add column if not exists owner_id uuid references public.owners(id);
alter table public.rides add column if not exists ride_date date;
alter table public.rides add column if not exists ride_time time;
alter table public.rides add column if not exists app_fare numeric(12,2);
alter table public.rides add column if not exists commission_rate_applied numeric(7,4);
alter table public.rides add column if not exists nepcab_commission numeric(12,2);
alter table public.rides add column if not exists driver_commission numeric(12,2);
alter table public.rides add column if not exists same_fare boolean not null default false;
alter table public.rides add column if not exists ride_notes text;
-- Existing reference_fare, agreed_fare, ride_datetime, ride_id and legacy columns remain untouched.

create table if not exists public.expenses (
 id uuid primary key default gen_random_uuid(), expense_date date not null, category text not null,
 vehicle_id uuid references public.vehicles(id), driver_id uuid references public.drivers(id), owner_id uuid references public.owners(id),
 amount numeric(12,2) not null check(amount>0), description text,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 check(vehicle_id is not null or driver_id is not null)
);
create table if not exists public.expense_categories (
 id uuid primary key default gen_random_uuid(), name text not null unique, active boolean not null default true,
 created_at timestamptz not null default now()
);
insert into public.expense_categories(name) values
 ('Vehicle charging'),('Vehicle maintenance'),('Driver food'),('Driver allowance'),('Vehicle cleaning'),('Other expenses')
on conflict(name) do nothing;

create table if not exists public.driver_payment_records (
 id uuid primary key default gen_random_uuid(), driver_id uuid not null references public.drivers(id),
 period_month date not null, amount numeric(12,2) not null check(amount>0),
 payment_date date not null default current_date, note text, created_at timestamptz not null default now()
);
create table if not exists public.owner_settlement_records (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references public.owners(id),
 period_month date not null, amount numeric(12,2) not null check(amount>0),
 payment_date date not null default current_date, breakdown jsonb not null default '{}'::jsonb,
 note text, created_at timestamptz not null default now()
);
create table if not exists public.commission_rate_history (
 id uuid primary key default gen_random_uuid(), rate_percent numeric(7,4) not null check(rate_percent between 0 and 100),
 effective_from date not null, created_at timestamptz not null default now()
);
insert into public.commission_rate_history(rate_percent,effective_from)
select 10,date '2000-01-01' where not exists(select 1 from public.commission_rate_history);
create table if not exists public.driver_compensation_agreements (
 id uuid primary key default gen_random_uuid(), driver_id uuid not null references public.drivers(id),
 fixed_monthly_salary numeric(12,2) not null default 0 check(fixed_monthly_salary>=0),
 commission_type text not null default 'None' check(commission_type in ('None','Percentage','Fixed per ride')),
 commission_value numeric(12,2) not null default 0 check(commission_value>=0),
 effective_from date not null, effective_to date,
 created_at timestamptz not null default now(), check(effective_to is null or effective_to>=effective_from)
);

create table if not exists public.audit_log (
 id bigint generated always as identity primary key, table_name text not null, record_id text not null,
 action text not null, changed_at timestamptz not null default now(), changed_by uuid references auth.users(id),
 old_data jsonb, new_data jsonb
);

create or replace function public.nepcab_audit_row() returns trigger language plpgsql security definer set search_path=public as $$
begin
 if tg_op='DELETE' then
  insert into public.audit_log(table_name,record_id,action,changed_by,old_data) values(tg_table_name,old.id::text,'DELETE',auth.uid(),to_jsonb(old)); return old;
 elsif tg_op='UPDATE' then
  insert into public.audit_log(table_name,record_id,action,changed_by,old_data,new_data) values(tg_table_name,new.id::text,'UPDATE',auth.uid(),to_jsonb(old),to_jsonb(new)); return new;
 else
  insert into public.audit_log(table_name,record_id,action,changed_by,new_data) values(tg_table_name,new.id::text,'INSERT',auth.uid(),to_jsonb(new)); return new;
 end if;
end $$;
do $$ declare t text; begin
 foreach t in array array['owners','vehicles','drivers','driver_compensation_agreements','daily_vehicle_readings','rides','expenses','driver_payment_records','owner_settlement_records'] loop
  execute format('drop trigger if exists nepcab_audit on public.%I',t);
  execute format('create trigger nepcab_audit after insert or update or delete on public.%I for each row execute function public.nepcab_audit_row()',t);
 end loop;
end $$;

-- Authenticated staff access. This initial setup uses one shared staff role/account if desired.
-- For individual accountability, create separate auth users; never expose service_role in frontend.
do $$ declare t text; begin
 foreach t in array array['owners','vehicles','drivers','driver_compensation_agreements','daily_vehicle_readings','rides','expenses','expense_categories','driver_payment_records','owner_settlement_records','commission_rate_history','audit_log'] loop
  execute format('alter table public.%I enable row level security',t);
  execute format('drop policy if exists "nepcab authenticated full access" on public.%I',t);
  execute format('create policy "nepcab authenticated full access" on public.%I for all to authenticated using (true) with check (true)',t);
 end loop;
end $$;

