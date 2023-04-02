PRODUCTION=${PRODUCTION:-NO}
REINSTALL_MODULES=${REINSTALL_MODULES:-NO}

NG_CONFIGURATION=${NG_CONFIGURATION:-development}
NG_REBUILD=${NG_REBUILD:-NO}

if [ $PRODUCTION == "YES" ]; then
    sudo -E /build.sh > /dev/stdout 2>&1 &

    if [ ! -d "/var/www/html" ]; then sudo mkdir -p /var/www/html; fi
    sudo sed -i 's#/home/node/app/dist#/var/www/html#g' /etc/apache2/httpd.conf
fi

if [ $PRODUCTION == "NO" ]; then
    /build.sh
fi

sudo /usr/sbin/httpd -DFOREGROUND