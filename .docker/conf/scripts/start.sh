#!/bin/bash
/etc/init.d/ssh start
/etc/init.d/php-fpm start
/usr/sbin/apache2ctl -D FOREGROUND
