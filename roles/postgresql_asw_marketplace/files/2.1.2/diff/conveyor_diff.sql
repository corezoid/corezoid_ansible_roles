/* it looks like an old usercode issue
 ALTER TABLE cce_exec_time
	DROP COLUMN sum_success,
	DROP COLUMN sum_error;*/

ALTER TABLE companies
	ADD COLUMN status smallint DEFAULT 1;

ALTER TABLE conveyor_id_to_conveyor_ref
	ADD CONSTRAINT conveyor_id_to_conveyor_ref_pkey PRIMARY KEY (conveyor_ref, env);

DROP TABLE conveyor_billing_old;

ALTER SEQUENCE conveyor_billing_id_seq
	OWNED BY conveyor_billing.id;

-- Create new tables: payments_history, user_billing_stats, user_billing_tacts

CREATE SEQUENCE payments_history_id_pk_seq
	START WITH 1000
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

CREATE SEQUENCE user_billing_stats_id_pk_seq
	START WITH 1000
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

CREATE SEQUENCE user_billing_tacts_id_pk_seq
	START WITH 1000
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

CREATE TABLE payments_history (
	order_id character varying(255) NOT NULL,
	payplan_id integer NOT NULL,
	paytype smallint DEFAULT 0,
	date_start character varying(255) DEFAULT date_part('epoch'::text, now()),
	amount integer NOT NULL,
	tacts integer NOT NULL,
	user_id integer NOT NULL,
	"timestamp" integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
	"state" smallint DEFAULT 1,
	payment_id character varying(255),
	id_pk integer DEFAULT nextval('payments_history_id_pk_seq'::regclass) NOT NULL
);

CREATE TABLE user_billing_stats (
	user_id integer NOT NULL,
	conveyor_id integer NOT NULL,
	conveyor_tacts bigint,
	"timestamp" integer,
	"interval" integer,
	operations bigint DEFAULT 0,
	id_pk integer DEFAULT nextval('user_billing_stats_id_pk_seq'::regclass) NOT NULL
);

CREATE TABLE user_billing_tacts (
	user_id integer NOT NULL,
	tacts bigint NOT NULL,
	"timestamp" integer NOT NULL,
	"interval" integer NOT NULL,
	operations bigint DEFAULT 0,
	id_pk integer DEFAULT nextval('user_billing_tacts_id_pk_seq'::regclass) NOT NULL
);

ALTER TABLE payments_history
	ADD CONSTRAINT pk_payments_history PRIMARY KEY (id_pk);

ALTER TABLE user_billing_stats
	ADD CONSTRAINT pk_user_billing_stats PRIMARY KEY (id_pk);

ALTER TABLE user_billing_tacts
	ADD CONSTRAINT pk_user_billing_tacts PRIMARY KEY (id_pk);

CREATE UNIQUE INDEX payment_history_order_by_user ON payments_history USING btree (user_id, order_id);

CREATE UNIQUE INDEX payment_history_order_id ON payments_history USING btree (order_id);

CREATE INDEX user_billing_stats_user_to_conv_on_timestamp ON user_billing_stats USING btree (user_id, conveyor_id, "timestamp");

CREATE INDEX user_billing_tacts_user_to_timestamp ON user_billing_stats USING btree (user_id, "timestamp");
