#Install OS in the container.
FROM		debian:buster

#Update server.
RUN			apt-get update
RUN			apt-get upgrade -y


RUN			apt-get install sysvinit-utils

#Install Wget.
RUN			apt-get -y install wget

#Install Nginx.
RUN			apt-get -y install nginx

RUN			apt-get -y install mariadb-server
#Install PHP.
RUN			apt-get -y install php-cgi php-common php-fpm php-pear php-mbstring
RUN			apt-get -y install php-zip php-net-socket php-gd php-xml-util php-gettext php-mysql php-bcmath
#Install MariaDB.



ENV INDEX=on


RUN mkdir /var/www/localhost

COPY srcs/localhost /etc/nginx/sites-available

RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

WORKDIR		/var/www/localhost/


COPY ./srcs/container_setup.sh ./

COPY ./srcs/set_index.sh ./

CMD  bash ./container_setup.sh;

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz

RUN tar -xf phpMyAdmin-5.1.0-english.tar.gz && rm -rf phpMyAdmin-5.1.0-english.tar.gz

RUN mv phpMyAdmin-5.1.0-english phpmyadmin

COPY ./srcs/config.inc.php phpmyadmin


# Download Wordpress using wget
RUN wget https://wordpress.org/latest.tar.gz

# Extract it and remove the .tar file
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz 

# Copy our configuration file inside the container
COPY ./srcs/wp-config.php /var/www/localhost/wordpress

# Change ownership and allow access to all the files
# This is required for phpMyAdmin to have acces to all the data, otherwise it will display an error
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*


RUN openssl req -x509 -nodes -days 30 -subj "/C=BE/ST=Belgium/L=Brussels/O=42 Network/OU=s19/CN=tedison" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

