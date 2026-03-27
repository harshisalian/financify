-- Time Tracking & Wage Calculation System Migration
-- Add new fields to staff_assignments table for time tracking and wage calculation

-- Add tracking fields
ALTER TABLE staff_assignments 
ADD COLUMN IF NOT EXISTS "breakTime" INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS "adminNotes" TEXT,
ADD COLUMN IF NOT EXISTS "tlCommission" DECIMAL(10,2) DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS "loggedBy" TEXT REFERENCES users(id),
ADD COLUMN IF NOT EXISTS "loggedAt" TIMESTAMP;

-- Update existing records with default values
UPDATE staff_assignments 
SET 
  "basePay" = 350.00,
  "totalWage" = 350.00,
  "tlCommission" = "staffAssigned" * 25.00
WHERE "basePay" IS NULL;

-- Add comments for documentation
COMMENT ON COLUMN staff_assignments."breakTime" IS 'Break time in minutes';
COMMENT ON COLUMN staff_assignments."adminNotes" IS 'Additional notes from admin';
COMMENT ON COLUMN staff_assignments."tlCommission" IS 'Team leader commission (₹25 per staff member)';
COMMENT ON COLUMN staff_assignments."loggedBy" IS 'Admin user who logged the time';
COMMENT ON COLUMN staff_assignments."loggedAt" IS 'When the time was logged';

-- Update the status enum to include new statuses if needed
-- (This depends on your current status column type)
-- If using a text column, no changes needed
-- If using an enum, you might need to add 'completed' and 'paid' statuses

-- Example of how to add new statuses to an enum (uncomment if needed):
-- ALTER TYPE assignment_status ADD VALUE IF NOT EXISTS 'completed';
-- ALTER TYPE assignment_status ADD VALUE IF NOT EXISTS 'paid';
