CREATE TABLE IF NOT EXISTS starred_objects (
  obj_id integer NOT NULL,
  obj_type smallint NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT starred_objects_pkey PRIMARY KEY (obj_id, obj_type, user_id)
);

WITH user_to_favorite_folder AS (
  SELECT
    u.id AS user_id,
    f.id AS folder_id
  FROM users AS u
    INNER JOIN user_to_user_groups AS utug ON utug.user_id = u.id
    INNER JOIN user_groups AS ug ON ug.id = utug.user_group_id
    INNER JOIN folders AS f ON f.owner_id = ug.id AND f.type = 2
), user_to_starred_object AS (
  SELECT
    utff.user_id,
    fc.obj_id,
    fc.obj_type
  FROM user_to_favorite_folder AS utff
    INNER JOIN folder_content AS fc ON fc.folder_id = utff.folder_id
), upsert_user_to_starred_object AS (
  INSERT INTO starred_objects (obj_id, obj_type, user_id)
  SELECT utso.obj_id, utso.obj_type, utso.user_id
  FROM user_to_starred_object AS utso
  ON CONFLICT(obj_id, obj_type, user_id) DO NOTHING
), update_favorite_folders_status AS (
  UPDATE folders AS f
  SET status = 3, change_time = date_part('epoch'::text, now())
  FROM (SELECT folder_id FROM user_to_favorite_folder) AS utff
  WHERE utff.folder_id = f.id
)
DELETE FROM folder_content AS fc
USING user_to_favorite_folder AS utff
WHERE fc.folder_id = utff.folder_id;
