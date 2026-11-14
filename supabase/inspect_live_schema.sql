-- READ-ONLY: inspect the existing Supabase schema before applying migration_v3.sql.
select table_name, column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema='public'
  and table_name in ('rides','owners','vehicles','drivers','daily_vehicle_readings','expenses','driver_payment_records','owner_settlement_archives','owner_settlement_records','expense_categories','commission_rate_history','driver_compensation_agreements')
order by table_name, ordinal_position;

select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
from pg_policies
where schemaname='public'
  and tablename in ('rides','owners','vehicles','drivers','daily_vehicle_readings','expenses','driver_payment_records','owner_settlement_archives','owner_settlement_records','expense_categories','commission_rate_history','driver_compensation_agreements')
order by tablename, policyname;

-- Inspect a small sample of existing ride rows. Do not expose passenger phone numbers in screenshots.
select id, ride_id, ride_datetime, booking_type, driver_name, vehicle_number,
       reference_fare, agreed_fare, created_at
from public.rides
order by created_at desc
limit 10;
