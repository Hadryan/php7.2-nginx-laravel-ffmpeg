FROM ubuntu:18.04

MAINTAINER RadicalRad <rad@mira-digital.com>

ENV DEBIAN_FRONTEND noninteractive

#Install nginx and php
RUN apt-get update && \
	apt-get install -y \
	software-properties-common \
	apt-transport-https \
	curl \
	nginx \
	php \
	php-fpm \
	php-curl \
	php-mysql \
	php-zip \
	git \
	node.js \
	npm \
	supervisor \
	autoconf \
    automake \
    build-essential \
    git-core \
    libass-dev \
    libgpac-dev \
    libsdl1.2-dev \
    libtheora-dev \
    libtool \
    libvdpau-dev \
    libvorbis-dev \
    libx11-dev \
    libx264-dev \
    libxext-dev \
    libxfixes-dev \
    pkg-config \
    texi2html \
    zlib1g-dev \
    libmp3lame-dev \
    nasm \
    gcc \
    yasm \
    wget

#Install phalcon
#RUN curl -s https://packagecloud.io/install/repositories/phalcon/nightly/script.deb.sh | bash
#RUN apt-get install php7.0-phalcon

RUN add-apt-repository ppa:ondrej/php

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
	apt-get install -y \
	yarn \
	php7.1-mcrypt

#Create web folder
RUN mkdir -p /var/www/html /run/php /var/log/supervisor


#Add supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY php.ini /etc/php/7.2/fpm/php.ini
COPY build.sh /usr/sbin/build.sh
RUN chmod 755 /usr/sbin/build.sh
RUN /usr/sbin/build.sh
#Share web folder
VOLUME ["/var/www/html"]

#Update nginx config
COPY default /etc/nginx/sites-available/default

#Set port
EXPOSE 80 443

#Start supervisor
CMD ["/usr/bin/supervisord"]
