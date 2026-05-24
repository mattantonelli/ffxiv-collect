-- Rails dev mode runs db:schema:load against both development and test.
-- The mariadb image only auto-creates one database via MARIADB_DATABASE,
-- so we create the test one (and grant the same user access) here.
CREATE DATABASE IF NOT EXISTS ffxiv_collect_test
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON ffxiv_collect_test.* TO 'ffxiv'@'%';
FLUSH PRIVILEGES;
