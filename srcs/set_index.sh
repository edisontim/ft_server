#!/bin/sh

if [ $1 = "y" ]
then
	sed -i 's/autoindex off/autoindex on/g' /etc/nginx/sites-available/localhost
	rm -rf /var/www/localhost/index.html
	echo "---> Index enabled."
	service nginx reload
elif [ $1 = "n" ]
then
	sed -i 's/autoindex on/autoindex off/g' /etc/nginx/sites-available/localhost
	cp /var/www/html/index.nginx-debian.html /var/www/localhost/index.html
	echo "---> Index disabled."
	service nginx reload
else
	echo "Parameter must be 'y' or 'n'."
fi
