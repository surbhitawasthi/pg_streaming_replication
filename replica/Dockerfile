FROM postgres:9.5

RUN apt update && apt install -y iputils-ping ssh less vim

RUN service ssh start

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["gosu", "postgres", "postgres"]
