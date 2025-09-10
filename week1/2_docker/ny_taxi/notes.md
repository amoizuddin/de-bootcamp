# Docker and Postgres Basics

## pg setup
so we started off by making a container for postgres and running a postgres server in that container
this was done by running the following command:

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v /Users/abdullah/Documents/data_enginering_learning/de_bootcamp/week1/2_docker/ny_taxi/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13
```
what this did was do the docker run command using the `-it` flag which means interactive and passed all those different arguements. At the very bottom we specified `postgres:13` which signifies which docker image we want to pull from the docker repo or whatever you want to call it.

after this we installed pgcli and played around with our DB a little and noticed it was just an empty db.

to run pgcli we need to pass it the following command:
```bash
pgcli -h <ip> -p <port> -u <username> -d <db_name>
pgcli -h localhost -p 5432 -u root -d ny_taxi

```

## populating db with parquet data
so to populate it with data we downloaded the NY yellow taxi data from 2021. this filetype was parquet. So working with this is different than working with a plain old CSV.

details of the the script to upload data are covered in `upload_data.ipynb`

## pgadmin

now pg admin is a containerized web app with taht being said the container is publiclly available and we dont need to download the pgadmin app because were already utilizing containers.

to get pgadmin we need to do a simmilar docker run -it command as we did for pg itself. and docker will pull the image for pgadmin. 

```bash
docker run -it \
-e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
-e PGADMIN_DEFAULT_PASSWORD="root" \
-p 8080:80 \
dpage/pgadmin4
```

now when we run this command a container spins up with pg admin. we mapped our local port on our machine to port 80 on the container so we can navigate to localhost:8080 to goto pgadmin

we can then login using the admin creds specfiied in the docker run command

if we then try to add a server after logging in and we pass our docker containers port '5432' on localhost then its not gonna work because its looking for a postgres server on 5432 localhost in this same container we are running pgadmin in. so thats an issue right because pgadmin and docker are running on two different containers.

Luckily there is a way we can have containers talk to each other. and thats by using a docker network.. the documentation is available on the docker docs

`docs.docker.com/reference/cli/docker/network/create/`

so lets start off by creating a network

```bash
docker network create <network_name>
```
now when we spin up our containers we need to specify that they are in this network and how they will be referred to.

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v /Users/abdullah/Documents/data_enginering_learning/de_bootcamp/week1/2_docker/ny_taxi/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=<network-name> \
  --name pg-database \
  postgres:13


docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v /Users/abdullah/Documents/data_enginering_learning/de_bootcamp/week1/2_docker/ny_taxi/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
  ```
now that our pg server is up and running, we can use pgcli and our command to login and run some tests to ensure that our data persisted.

lets run `pgcli -h localhost -p 5432 -u root -d ny_taxi`

and we can once again do our `select count(1) from ny_taxi_data;`

and we can see that we have our 1.3 million records.

so now that we have created our network and started a container with postgres we can go to another terminal and spin up pgadmin 

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=<network-name> \
  --name <pg-admin-name>\
  dpage/pgadmin4

docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg_network \
  --name pgadmin\
  dpage/pgadmin4
```

now thats its loaded we can go back to local host 8080 and try to connect to the db

we create a new connetion and then add the db name and password and because theyre in the same docker network we dont need to specify the ip we just pass it the db name in hostname and then the port and then pass the username and password and we can connect to the db.

now that its all loaded in we can go to the ny_taxi db and then look at its schema. we see theres a public schema with 1 table whihc is the ny_taxi_data
we can right click that table and click view and then 100 rows and it executes a query to select all from that table limit 100

now we can go to the tools tab and open the query tool and run that same select count(1) from ny_taxi_data; script that we were running in pgcli.

and we can see from its output its working as expected.

now we can actually dockerize the ingestion script and have dockercompose do all this setup for us.

## dockerizing the ingestion script