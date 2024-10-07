ALTER TABLE user_to_companies ADD COLUMN status boolean NOT NULL DEFAULT true;

ALTER TABLE companies ADD COLUMN blocked_reason character varying(2000) DEFAULT NULL::character varying;
ALTER TABLE users ADD COLUMN blocked_reason character varying(2000) DEFAULT NULL::character varying;

ALTER TABLE users ADD COLUMN ext_user_id integer;

ALTER TABLE logins ADD COLUMN hash1_change_time INTEGER, ADD COLUMN hash1_change_time_last_expire_notification INTEGER;

UPDATE logins
SET hash1_change_time = (date_part('epoch'::text, now()))::integer, hash1_change_time_last_expire_notification = (date_part('epoch'::text, now()))::integer
WHERE hash1 IS NOT NULL and type = 7;
