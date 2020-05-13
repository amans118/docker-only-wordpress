FROM ubuntu:16.04
EXPOSE 80

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y apache2 php libapache2-mod-php php-mysql wget supervisor
ADD https://raw.githubusercontent.com/amans118/docker-only-wordpress/master/supervisord.conf /etc/supervisord.conf
ADD https://raw.githubusercontent.com/amans118/docker-only-wordpress/master/php-fpm.conf /etc/supervisord/conf.d/php-fpm.conf
ADD https://raw.githubusercontent.com/amans118/docker-only-wordpress/master/apache2.conf /etc/supervisord/conf.d/apache2.conf

RUN cd /var/www
RUN wget http://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz -C /var/www/
RUN cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

RUN sed -i 's/database_name_here/wordpress/' /var/www/wordpress/wp-config.php
RUN sed -i 's/username_here/wordpress/' /var/www/wordpress/wp-config.php
RUN sed -i 's/password_here/wordpress/' /var/www/wordpress/wp-config.php
RUN sed -i 's/localhost/wordpress:3306/' /var/www/wordpress/wp-config.php

RUN cd /etc/apache2/sites-enabled/
RUN sed -i 's/\/var\/www\/html/\/var\/www\/wordpress/' /etc/apache2/sites-enabled/000-default.conf

CMD ["/usr/bin/supervisord", "-n"]
