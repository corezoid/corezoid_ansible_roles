CREATE TABLE single_account_api_keys (
      id serial PRIMARY KEY,
      client_id varchar(255) NOT NULL,
      scope text,
      api_user_id integer NOT NULL,
      api_login text NOT NULL,
      api_login_id integer NOT NULL
);

ALTER TABLE oauth2_tokens ADD COLUMN type smallint NOT NULL DEFAULT 0;
