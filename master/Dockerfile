FROM postgres:9.5

RUN apt update && apt install -y iputils-ping ssh less vim

RUN service ssh start

COPY ./initialize-master.sh /docker-entrypoint-initdb.d/initialize-master.sh

RUN chmod 0666 /docker-entrypoint-initdb.d/initialize-master.sh
