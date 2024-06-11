
DROP INDEX conveyors_status;

DROP INDEX owner_id;

ALTER SEQUENCE conveyors_id_seq
    OWNED BY conveyors.id;

ALTER TABLE conveyors
    DROP COLUMN esc_conv,
    ADD COLUMN version integer DEFAULT 1 NOT NULL,
    ALTER COLUMN id SET DEFAULT nextval('conveyors_id_seq'::regclass);