# Create databases.
CREATE DATABASE IF NOT EXISTS `commonplace`;
CREATE DATABASE IF NOT EXISTS `commonplace_dev`;
CREATE DATABASE IF NOT EXISTS `commonplace_test`;

# Create root user and grant rights.
CREATE USER 'db'@'%' IDENTIFIED BY 'db';
GRANT ALL PRIVILEGES ON *.* TO 'db'@'%';
