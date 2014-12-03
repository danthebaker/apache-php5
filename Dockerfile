FROM ubuntu:12.04

MAINTAINER Dan Baker, dan@wk1.net

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
RUN apt-get -y install curl apache2 php5 php-db php-html-template-it php-http php-mail php-net-smtp php-net-socket php-pear php-xml-parser php5-common php5-cli php5-cgi php5-curl php5-dev php5-ffmpeg php5-gd php5-mysql php5-sybase libapache2-mod-php5 libapache2-mod-php5 php5-json php5-mysql php-apc php5-gd php5-memcached php5-mcrypt imagemagick libjpeg62-dev libbz2-dev libtiff4-dev libwmf-dev zlib1g-dev liblcms1-dev libexif-dev libperl-dev ghostscript ffmpeg

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