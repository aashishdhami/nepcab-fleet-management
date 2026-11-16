# NepCab Fleet Management v3.4.4

## Changes
1. Expense History search now resolves the currently linked vehicle and driver for each expense. Searching by vehicle registration can find both vehicle expenses and expenses recorded against its assigned driver. Searching by driver name or phone can find both driver expenses and vehicle expenses associated with that driver's currently assigned vehicle.
2. Owner earnings now deduct all expenses associated with the owner's fleet: direct vehicle expenses and driver expenses for drivers currently assigned to those vehicles.
3. Owner settlement month discovery, owner financial reports, vehicle-wise expense breakdowns, and expense exports include linked driver expenses. Expense reporting now distinguishes expense type and shows linked vehicle/driver where available.

## Important relationship assumption
Driver expenses are attributed to the owner of the vehicle to which the driver is currently assigned. Vehicle/driver association is resolved from the current assignment because expense records store either vehicle_id or driver_id, not both. If historical driver-to-vehicle assignments change, old driver expenses may be attributed using the current assignment.

## Validation
Source-level changes made. Production build was not completed in this environment because dependency installation did not finish before timeout. Run `npm install` and `npm run build` locally before deployment.
