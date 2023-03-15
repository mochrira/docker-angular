FROM node:lts-slim

COPY httpd-2.4.56.tar.gz /home/node
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt update
RUN apt install -y build-essential libssl-dev libexpat-dev libpcre3-dev libapr1-dev libaprutil1-dev
RUN npm install -g @angular/cli

USER node
RUN tar -xf /home/node/httpd-2.4.56.tar.gz -C /home/node
RUN mkdir -p /home/node/local/apache2

WORKDIR /home/node/httpd-2.4.56
RUN ./configure --prefix=/home/node/local/apache2 --enable-shared=max
RUN make && make install
COPY httpd.conf /home/node/local/apache2/conf/httpd.conf
RUN rm -rf /home/node/httpd-2.4.56
RUN rm -rf /home/node/httpd-2.4.56.tar.gz

USER root
RUN rmdir /home/node/httpd-2.4.56
RUN apt --purge remove -y build-essential libssl-dev libexpat-dev libpcre3-dev libapr1-dev libaprutil1-dev
RUN apt -y autoremove
RUN apt install -y libapr1 libaprutil1
RUN rm -rf /var/lib/apt/lists/*
RUN npm cache verify

USER node
WORKDIR /home/node/app
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh"]