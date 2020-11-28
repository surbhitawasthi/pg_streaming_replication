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

## Play Around

### Replication Check

Insert the following data into master

Connect to the master db
```bash
docker exec -it pg_streaming_replication_pg_master_1 /bin/bash
su - postgres
psql -U surbhit -d testdb
```

and run the following commands to insert data into db.
```sql
CREATE TABLE persons (
id INTEGER PRIMARY KEY,
name VARCHAR (10)
);

INSERT INTO persons
VALUES (1, 'alice');

INSERT INTO persons
VALUES (2, 'bob');

INSERT INTO persons
VALUES (3, 'claire');
```

Connect to the replica db
```bash
docker exec -it pg_streaming_replication_pg_replica_1 /bin/bash
su - postgres
psql -U surbhit -d testdb
```

and run the following command to see that data is replicated:
```sql
SELECT * FROM persons;
```

### Failover of Master Node

To simulate a failure of master run:
```bash
docker stop pg_streaming_replication_pg_master_1
```

After this you can see that the replica logs start complaining in the `docker-compose up` terminal (which streams logs
from master and replica container)

To promote the replica to master, on the replica container run

```bash
touch /tmp/pg_ctl_promote
```

In the `docker-compose up` terminal you will see that now replica can accept both read and write connections.

> Note: Once replica is promoted to master if (original) master is brought back up, we have 2 db server and two db instances.
