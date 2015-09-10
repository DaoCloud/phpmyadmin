FROM corbinu/docker-nginx-php

RUN apt-get update && \
    apt-get install -y mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV MAX_UPLOAD "50M"

RUN rm -r /www && \
    curl -o pma-4.4.14.zip https://files.phpmyadmin.net/phpMyAdmin/4.4.14/phpMyAdmin-4.4.14-all-languages.zip && \
    unzip /pma-4.4.14.zip && \
    rm /pma-4.4.14.zip && \
    mv /phpMyAdmin-4.4.14-all-languages /www
ADD config.inc.php /www/
ADD sso.php /www/
ADD libraries/Util.class.php /www/libraries/Util.class.php

RUN sed -i "s/http {/http {\n        client_max_body_size $MAX_UPLOAD;/" /etc/nginx/nginx.conf
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = $MAX_UPLOAD/" /etc/php5/fpm/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = $MAX_UPLOAD/" /etc/php5/fpm/php.ini

EXPOSE 80
CMD ["nginx-start"]