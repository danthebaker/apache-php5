FROM ubuntu:12.04

MAINTAINER Kai Davenport, kaiyadavenport@gmail.com

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Utilities and Apache, PHP
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install curl apache2 php5 php5-cli libapache2-mod-php5 php5-json php5-mysql php-apc php5-gd php5-curl php5-memcached php5-mcrypt imagemagick
RUN apt-get clean

# PHP prod config
ADD php.ini /etc/php5/conf.d/prod.ini
RUN cd /etc/php5/cli/conf.d && ln -sf ../../conf.d/prod.ini prod.ini &&\
    cd /etc/php5/apache2/conf.d && ln -sf ../../conf.d/prod.ini prod.ini

# Ensure PHP log file exists and is writable
RUN touch /var/log/php_errors.log && chmod a+w /var/log/php_errors.log

# Turn on some crucial apache mods
RUN a2enmod rewrite headers

# Our start-up script
ADD start.sh /start.sh
RUN chmod a+x /start.sh

VOLUME ["/var/log"]

ENTRYPOINT ["/start.sh"]
EXPOSE 80