# create databases
CREATE DATABASE IF NOT EXISTS `ffxiv_collect_development`;
CREATE DATABASE IF NOT EXISTS `ffxiv_collect_test`;

# create root user and grant rights
GRANT ALL PRIVILEGES ON *.* TO 'ffxiv-collect'@'%';