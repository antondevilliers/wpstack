FROM wordpress

RUN apt-get update && apt-get install -y git wget subversion cvs bzr

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp

RUN pecl install xdebug

RUN sed -i "s/WP_DEBUG', false/WP_DEBUG', true/" /usr/src/wordpress/wp-config-sample.php

RUN docker-php-ext-install opcache

COPY php/php.ini /usr/local/etc/php/php.ini

COPY php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN echo "zend_extension = /usr/local/lib/php/extensions/$(ls /usr/local/lib/php/extensions | tail -n 1)/xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

COPY php/mailcatcher.ini /usr/local/etc/php/conf.d/mailcatcher.ini

COPY bootstrap.sh /bootstrap.sh

RUN sed -i 's/exec.*//' /entrypoint.sh

ENTRYPOINT ["/bootstrap.sh"]
CMD ["apache2-foreground"]
