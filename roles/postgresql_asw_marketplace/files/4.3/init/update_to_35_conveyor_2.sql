UPDATE user_groups AS ug
SET type = 2
WHERE ug.type in (3,4,5,6,7,8,9,10,11);

UPDATE user_groups AS ug
SET status = 3
WHERE ug.type = 13;

WITH my_group_id_to_owner_user_id    AS(
  SELECT DISTINCT ug.id AS group_id, utug1.user_id AS owner_user_id, f.create_time
  FROM folders AS f
    INNER JOIN folder_content AS fc ON fc.folder_id = f.id
    INNER JOIN users AS u ON u.id = fc.obj_id
    INNER JOIN login_to_users AS ltu ON ltu.user_id = u.id
    INNER JOIN logins AS l ON l.id = ltu.login_id AND l.type = 4

    INNER JOIN user_to_user_groups AS utug ON utug.user_id = u.id
    INNER JOIN user_groups AS ug ON ug.id = utug.user_group_id AND ug.type = 1

    INNER JOIN user_groups AS ug1 ON ug1.id = f.owner_id AND ug1.type = 1
    INNER JOIN user_to_user_groups AS utug1 ON utug1.user_group_id = ug1.id
  WHERE f.type = 1
  ORDER BY f.create_time
), user_to_company AS (
  SELECT DISTINCT ON (utc.user_id) *
  FROM user_to_companies AS utc
    INNER JOIN companies AS c ON c.company_id = utc.company_id AND c.status <> 3
  ORDER BY utc.user_id, c.create_time
), company_group_id_to_owner_user_id AS(
  SELECT ug.id AS group_id, utc.owner_user_id
  FROM user_to_company AS utc
    INNER JOIN login_to_users AS ltu ON ltu.user_id = utc.user_id
    INNER JOIN logins AS l ON l.id = ltu.login_id AND l.type = 4
    INNER JOIN users AS u ON u.id = utc.owner_user_id
    INNER JOIN user_to_user_groups AS utug ON utug.user_id = utc.user_id
    INNER JOIN user_groups AS ug ON ug.id = utug.user_group_id AND ug.type = 1
    LEFT JOIN my_group_id_to_owner_user_id AS mgitou ON mgitou.group_id = ug.id WHERE mgitou.group_id IS NULL
), all_group_to_owner                AS(
  SELECT group_id, owner_user_id FROM my_group_id_to_owner_user_id
  UNION
  SELECT group_id, owner_user_id FROM company_group_id_to_owner_user_id
)
UPDATE user_groups AS ug
SET owner_user_id = gto.owner_user_id
FROM all_group_to_owner AS gto
WHERE ug.id = gto.group_id;
