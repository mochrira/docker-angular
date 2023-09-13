if [ ! -d "/home/node/app/dist" ]; then
    sudo mkdir /home/node/app/dist
fi

if [ -d "/var/www/html" ]; then
    sudo rm -rf /var/www/html
fi

sudo chown -R node:node /home/node/app/dist
sudo ln -s /home/node/app/dist /var/www/html
sudo /usr/sbin/httpd -DFOREGROUND