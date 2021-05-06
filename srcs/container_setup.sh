#!/bin/sh

service nginx start;

service mysql start;

service php7.3-fpm start;

echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password;
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password;
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password;
echo "update mysql.user set plugin='' where user='root';" | mysql -u root --skip-password;


service nginx restart;

service php7.3-fpm restart;

if [ $INDEX = "on" ]
then
	bash set_index.sh y
elif [ $INDEX = "off" ]
then
	bash set_index.sh n
else
	echo "Only on or off values are expected."
fi


tail -f /var/log/nginx/access.log /var/log/nginx/error.log

