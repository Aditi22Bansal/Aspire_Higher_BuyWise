-- 21-case-priority: triage for procurement dashboard
ALTER TABLE procurement_cases ADD COLUMN IF NOT EXISTS priority TEXT NOT NULL DEFAULT 'normal';
ALTER TABLE procurement_cases ADD COLUMN IF NOT EXISTS due_date DATE;
CREATE INDEX IF NOT EXISTS idx_cases_priority_due ON procurement_cases (priority, due_date);
