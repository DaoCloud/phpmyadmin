#!/bin/bash

cat << EOF > /etc/php5/apache2/conf.d/newrelic.ini

newrelic.license = "$NEWRELIC_LICENSE"
newrelic.appname = "$NEWRELIC_APP_NAME"

EOF

apachectl -DFOREGROUND
