CREATE DATABASE IF NOT EXISTS `lms-kernel`;
CREATE DATABASE IF NOT EXISTS `lms-auth`;
CREATE USER 'local-user'@'%' IDENTIFIED WITH mysql_native_password BY 'local-password';
GRANT ALL PRIVILEGES ON *.* TO 'local-user'@'%';
FLUSH PRIVILEGES;
