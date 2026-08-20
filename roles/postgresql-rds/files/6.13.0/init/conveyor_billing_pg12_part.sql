DROP TABLE conveyor_billing;

CREATE TABLE public.conveyor_billing (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    ts integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size bigint NOT NULL,
    period integer NOT NULL
) PARTITION BY RANGE (ts);


ALTER TABLE public.conveyor_billing OWNER TO postgres;

ALTER TABLE ONLY public.conveyor_billing
    ADD CONSTRAINT pk_conveyor_billing PRIMARY KEY (conveyor_id, user_id, ts);


CREATE INDEX ix_conveyor_billing_conveyor_id_ts ON public.conveyor_billing USING btree (conveyor_id, ts);

CREATE INDEX ix_conveyor_billing_ts ON public.conveyor_billing USING btree (ts);

CREATE INDEX ix_conveyor_billing_user_id_ts ON public.conveyor_billing USING btree (user_id, ts);



GRANT SELECT ON TABLE public.conveyor_billing TO viewers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.conveyor_billing TO appusers;
