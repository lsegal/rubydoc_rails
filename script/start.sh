#!/bin/sh

chown root:docker /var/run/docker.sock 2>/dev/null
docker swarm init 2>/dev/null
docker-compose build
docker stack deploy --resolve-image never --compose-file docker-compose.yml --compose-file docker-compose.prod.yml rubydoc
