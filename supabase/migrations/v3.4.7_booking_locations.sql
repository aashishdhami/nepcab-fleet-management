-- NepCab v3.4.7: add informational pickup and destination fields to multi-day bookings.
-- Run this once in Supabase SQL Editor before using v3.4.7.
alter table public.vehicle_bookings
  add column if not exists pickup_location text,
  add column if not exists dropoff_location text;
