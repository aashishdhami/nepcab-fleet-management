-- NepCab v3.3.9 commission calculation alignment
-- Run once in Supabase SQL Editor if you have existing multi-day bookings
-- created under the old fixed_per_ride calculation.
-- Percentage-based booking commissions are not changed.
update public.vehicle_bookings
set driver_commission_amount = round(driver_commission_value * number_of_days, 2),
    updated_at = now()
where driver_commission_type = 'fixed_per_ride'
  and number_of_days > 1
  and driver_commission_amount is distinct from round(driver_commission_value * number_of_days, 2);
