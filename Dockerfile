FROM debian:latest 

RUN apt-get update && \
    apt-get install -y libapache2-mod-php5 php5-mysql php5-curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

ADD 000-default /etc/apache2/sites-available/000-default
ADD src/ /var/www/html/
VOLUME ["/var/lib/php5/sessions"]

EXPOSE 80
CMD ["apachectl", "-DFOREGROUND"]
