CREATE INDEX CONCURRENTLY ON history_v2 (create_time DESC);
CREATE INDEX CONCURRENTLY ON history_v2 (level, user_id, create_time DESC);
CREATE INDEX CONCURRENTLY ON history_v2_rows (history_id);
CREATE INDEX CONCURRENTLY ON history_v2_rows (severity, type, obj, company_id);

ALTER TABLE companies ADD COLUMN IF NOT EXISTS description text;
