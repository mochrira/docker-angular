PRODUCTION=${PRODUCTION:-NO}
REINSTALL_MODULES=${REINSTALL_MODULES:-NO}

NG_CONFIGURATION=${NG_CONFIGURATION:-development}
NG_REBUILD=${NG_REBUILD:-NO}

if [ $PRODUCTION == "YES" ]; then
    sudo -E /build.sh > /dev/stdout 2>&1 &

    if [ ! -d "/var/www/html" ]; then sudo mkdir -p /var/www/html; fi
    
    sudo echo \
    $'server { \n
        listen 80 default_server; \n
        listen [::]:80 default_server; \n
        try_files $uri $uri/ /index.html; \n
    \n
        root /var/www/html; \n
        index index.html; \n
    \n
        include /home/node/app/.docker/nginx/*[.]conf; \n
    }' | sudo tee /etc/nginx/http.d/default.conf > /dev/null
fi

if [ $PRODUCTION == "NO" ]; then
    /build.sh

    sudo echo \
    $'server { \n
        listen 80 default_server; \n
        listen [::]:80 default_server; \n
        try_files $uri $uri/ /index.html; \n
    \n
        root /home/node/app/dist; \n
        index index.html; \n
    \n
        include /home/node/app/.docker/nginx/*[.]conf; \n
    }' | sudo tee /etc/nginx/http.d/default.conf > /dev/null
fi

sudo /usr/sbin/nginx -g 'daemon off;'