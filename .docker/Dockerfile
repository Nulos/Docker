FROM debian:latest
WORKDIR "/application"

MAINTAINER Nulos "nulos@auriol.me"

FROM debian:latest

ARG phpversion
ARG xdebug

RUN export DEBIAN_FRONTEND=noninteractive \
        && apt-get update \
        && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        wget \
        vim \
        gnupg2 \
        openssh-server \
        net-tools \
        apt-utils \
        && wget -O -  https://packages.sury.org/php/apt.gpg | apt-key add - \
        && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list

RUN if [ "${phpversion}" != "7.2" ]; then export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y php${phpversion}-fpm php${phpversion}-cli php${phpversion}-common php${phpversion}-curl php${phpversion}-gd php${phpversion}-gmp php${phpversion}-intl php${phpversion}-json php${phpversion}-mbstring php${phpversion}-mcrypt php${phpversion}-mysql php${phpversion}-opcache php${phpversion}-readline php${phpversion}-soap php${phpversion}-sqlite3 php${phpversion}-xml php${phpversion}-zip php-imagick ghostscript; else export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y php7.2-fpm php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-gmp php7.2-imap php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline php7.2-soap php7.2-sqlite3 php7.2-xml php7.2-zip php-imagick ghostscript;fi
ADD ./conf/php/pool-php${phpversion}.conf /etc/php/${phpversion}/fpm/pool.d/www.conf
RUN ln -s /etc/init.d/php${phpversion}-fpm /etc/init.d/php-fpm

RUN export DEBIAN_FRONTEND=noninteractive \
        && apt-get update \
        && apt-get install -y \
        apache2 \
        && a2enmod \
        expires \
        proxy_fcgi \
        rewrite \
        http2 \
        authz_groupfile \
        headers \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ADD ./conf/apache/apache-php${phpversion}.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Paris" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    rm /etc/timezone && \
    rm /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata

RUN if [ "${xdebug}" = "true" ] ; then apt-get update && apt-get install -y php-xdebug ; fi

RUN echo 'root:password' | chpasswd
RUN sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ADD ./conf/scripts/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80 22

CMD ["/bin/bash", "/start.sh"]