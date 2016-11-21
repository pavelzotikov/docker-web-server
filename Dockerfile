FROM ubuntu:14.04
MAINTAINER Pavel Zotikov pavelzotikov@gmail.com

ENV DEBIAN_FRONTEND noninteractive

ENV LANG C.UTF-8

RUN locale-gen ru_RU.UTF-8 && dpkg-reconfigure locales

RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository -y ppa:ondrej/php && \
	add-apt-repository -y ppa:nginx/stable && \
	add-apt-repository -y ppa:pinepain/libv8-5.2

RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

RUN apt-get update

# RUN apt-get install -y nano wget curl git-core apache2 libapache2-mod-php7.0 php5-mysql php5-gd php5-curl php-pear php-apc php5-mcrypt php5-imagick php5-memcache php5-redis php5-mongo supervisor nginx apache2 mysql-server phpmyadmin memcached redis-server mongodb

RUN apt-get install -y nano wget curl git-core apache2 libapache2-mod-php7.0 php7.0-common php-pear \
	php7.0-cli php7.0-curl php7.0-json php7.0-mcrypt php7.0-mysql php7.0-gd php7.0-imagick php7.0-dev \
	php7.0-ldap php7.0-sybase php7.0-mbstring php7.0-zip php7.0-soap \
	php7.0-memcache php7.0-memcached php7.0-redis \
	supervisor nginx mysql-server memcached mongodb redis-server libv8-5.2

RUN pecl install v8js && \
	echo "extension=v8js.so" > /etc/php/7.0/mods-available/v8js.ini && \
	phpenmod v8js

RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN rm -rf /var/lib/apt/lists/*

RUN pecl install mongodb && \
    echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
    phpenmod mongodb

# RUN mkdir -p /usr/lib /usr/include
# ADD v8/usr/lib/libv8* /usr/lib/
# ADD v8/usr/include /usr/include/
# ADD v8/usr/lib/php/20151012/v8js.so /usr/lib/php/20151012/v8js.so
# RUN echo "extension=v8js.so" > /etc/php/7.0/mods-available/v8js.ini && phpenmod v8js

# RUN echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /etc/php/7.0/cli/conf.d/mail.ini

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

RUN a2enmod php7.0
RUN a2enmod rewrite

RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini

# nginx config
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/default

# apache2 config
RUN rm /etc/apache2/ports.conf
ADD apache2-ports.conf /etc/apache2/ports.conf
RUN rm /etc/apache2/sites-available/000-default.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD apache2.conf /etc/apache2/sites-enabled/default.conf

# mysql config 

# mongodb config
RUN mkdir /var/mongodb

# supervisor config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid

VOLUME ["/var/www"] 

EXPOSE 80 

CMD ["/usr/bin/supervisord"]
