FROM debian:latest 

RUN apt-get update && \
    apt-get install -y libapache2-mod-php5 php5-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD src/ /var/www/html/

EXPOSE 80

CMD ["apachectl", "-DFOREGROUND"]
