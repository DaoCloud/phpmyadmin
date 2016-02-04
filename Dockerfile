FROM debian:latest 

RUN apt-get update && \
    apt-get install -y libapache2-mod-php5 php5-mysql php5-curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

ADD src/ /var/www/html/
ADD 30-session.ini /etc/php5/apache2/conf.d/30-session.ini
VOLUME ["/session"]

EXPOSE 80
CMD ["apachectl", "-DFOREGROUND"]
