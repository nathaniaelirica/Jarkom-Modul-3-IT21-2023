apt-get update
apt-get install mariadb-server -y
service mysql start

echo "
[mysqld]
skip-networking=0
skip-bind-address
" > /etc/mysql/my.cnf

# Masukkan command-command berikut
# mysql -u root -p
# CREATE USER 'kelompokIT21'@'%' IDENTIFIED BY 'passwordIT21';
# CREATE USER 'kelompokIT21'@'localhost' IDENTIFIED BY 'passwordIT21';
# CREATE DATABASE dbkelompokIT21;
# GRANT ALL PRIVILEGES ON *.* TO 'kelompokIT21'@'%';
# GRANT ALL PRIVILEGES ON *.* TO 'kelompokIT21'@'localhost';
# FLUSH PRIVILEGES;

service mysql restart