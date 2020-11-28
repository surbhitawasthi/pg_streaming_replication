# PG Streaming Replication - Docker

This project is for understanding how can I quickly bootstrap a master-replica postgresql db environment with streaming
replication enabled.

## Run Instructions

1. To start master and replica containers (with streaming replication enabled):
    ```bash
    docker-compose up
    ```

2. To stop the running containers
    ```bash
    docker-compose down
    ```

3. To get inside any container, first run
    ```bash
    docker ps
    ```

    to get the container name/id, then run
    ```bash
    docker exec -it <name or id of container> /bin/bash
    ```

    Inside the container run
    ```bash
    su - postgres
    ```

    to change to user `postgres`, and `psql` can be connected to as:
    ```bash
    psql -U surbhit -d testdb
    ```

> Note: ssh, less, vim installation on any container is actually not needed. It is for a personal project.
