FROM debian:latest 

ENV DEBIAN_FRONTEND noninteractive
ENV NEWRELIC_LICENSE ""
ENV NEWRELIC_APP_NAME "PHP Application"

RUN apt-get update && \
    apt-get install -y libapache2-mod-php5 php5-mysql php5-curl curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list && \
    apt-get update && \
    apt-get install -y newrelic-php5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
 
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ADD php.ini /etc/php5/apache2/php.ini
ADD src/ /var/www/html/

RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/var/lib/php5/sessions"]
EXPOSE 80
CMD ["entrypoint.sh"]
