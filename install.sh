#!/bin/bash
docker network create -d bridge wordpressonly
docker \
  run \
  --detach \
  --env MYSQL_ROOT_PASSWORD=wordpress \
  --env MYSQL_USER=wordpress \
  --env MYSQL_PASSWORD=wordpress \
  --env MYSQL_DATABASE=wordpress \
  --name mysql \
  --publish 3306:3306 \
  --network wordpressonly \
  mysql:5.7

# building image
docker build -t dockeronlywp:v1 --no-cache .

# running container
docker \
  run \
  --detach \
  --name dockeronlywp \
  --publish 9001:80 \
  --network wordpressonly \
  dockeronlywp:v1
