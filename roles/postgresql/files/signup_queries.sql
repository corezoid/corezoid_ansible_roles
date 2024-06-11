CREATE OR REPLACE FUNCTION sha1(bytea)
RETURNS character varying AS
$BODY$
BEGIN
RETURN ENCODE(DIGEST($1, 'sha1'), 'hex');
END;
$BODY$
LANGUAGE 'plpgsql';

BEGIN;
    LOCK TABLE users IN EXCLUSIVE MODE;

    INSERT INTO users ( name, lang )
    SELECT 'system_timer', NULL
    WHERE NOT EXISTS (
        SELECT 1 FROM users WHERE name = 'system_timer' AND lang IS NULL
    );

    -- SELECT setval('users_id_seq', COALESCE((SELECT MAX(id)+1 FROM users), 1), false);
COMMIT;
-- INSERT INTO users ( name, lang ) VALUES ( 'system_timer', NULL ) returning id;


BEGIN;
    LOCK TABLE logins IN EXCLUSIVE MODE;

    INSERT INTO logins ( login, type, hash1 )
    SELECT 'admin@corezoid.loc', 7, '0e718e62543de93288744b1100ff3e0643ee755c'
    WHERE NOT EXISTS (
        SELECT 1 FROM logins WHERE login = 'admin@corezoid.loc' AND type = 7 AND hash1 = '0e718e62543de93288744b1100ff3e0643ee755c'
    );

COMMIT;
-- INSERT INTO logins ( login, type, hash1 ) VALUES ( 'admin@corezoid.loc', 7, '0e718e62543de93288744b1100ff3e0643ee755c' ) returning id;

UPDATE logins SET hash1 = (select sha1('admin@corezoid.locJU2z1oScNqQpjXgAncMtwkTC2tMnUdPCcorezoid')) WHERE login = 'admin@corezoid.loc';

BEGIN;
    LOCK TABLE users IN EXCLUSIVE MODE;

    INSERT INTO users ( name, lang )
    SELECT 'Admin', NULL
    WHERE NOT EXISTS (
        SELECT 1 FROM users WHERE name = 'Admin' AND lang IS NULL
    );
COMMIT;
-- INSERT INTO users ( name, lang ) VALUES ( 'Admin', NULL ) returning id;


BEGIN;
    LOCK TABLE user_groups IN EXCLUSIVE MODE;

    INSERT INTO user_groups ( name, type )
    SELECT 'root', 1
    WHERE NOT EXISTS (
        SELECT 1 FROM user_groups WHERE name = 'root' AND type = 1
    );
COMMIT;
-- INSERT INTO user_groups ( name, type ) VALUES ( 'root', 1 ) returning id;



BEGIN;
    LOCK TABLE login_to_users IN EXCLUSIVE MODE;

    INSERT INTO login_to_users ( user_id, login_id )
    SELECT 2, 1
    WHERE NOT EXISTS (
        SELECT 1 FROM login_to_users WHERE user_id = 2 AND login_id = 1
    );
COMMIT;
-- INSERT INTO login_to_users ( user_id, login_id ) VALUES ( 2, 1 );


-- BEGIN;
--     LOCK TABLE user_to_user_groups IN EXCLUSIVE MODE;

--     INSERT INTO user_to_user_groups ( user_id, user_group_id )
--     SELECT 1, 1
--     WHERE NOT EXISTS (
--         SELECT 1 FROM user_to_user_groups WHERE user_id = 1 AND user_group_id = 1
--     );
-- COMMIT;
-- INSERT INTO user_to_user_groups ( user_id, user_group_id ) VALUES ( 1, 1 );

BEGIN;
    LOCK TABLE user_to_user_groups IN EXCLUSIVE MODE;

    INSERT INTO user_to_user_groups ( user_id, user_group_id )
    SELECT 2, 1
    WHERE NOT EXISTS (
        SELECT 1 FROM user_to_user_groups WHERE user_id = 2 AND user_group_id = 1
    );
COMMIT;
-- INSERT INTO user_to_user_groups ( user_id, user_group_id ) VALUES ( 2, 1 );


BEGIN;
    LOCK TABLE user_groups IN EXCLUSIVE MODE;

    INSERT INTO user_groups ( name, type )
    SELECT 'all', 0
    WHERE NOT EXISTS (
        SELECT 1 FROM user_groups WHERE name = 'all' AND type = 0
    );
COMMIT;
-- INSERT INTO user_groups ( name, type ) VALUES ( 'all', 0 ) returning id;

UPDATE user_to_user_groups SET user_id = 2 WHERE user_group_id = 1;
