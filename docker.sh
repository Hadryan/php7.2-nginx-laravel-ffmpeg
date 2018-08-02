#!/bin/bash
export DOCKER_HOST_IP=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
docker rm -f api
docker run -d --name api -v ~/Projects/www/api:/var/www/html -p 8080:80 -h rig --add-host mysql:$DOCKER_HOST_IP php7-nginx-docker:latest
