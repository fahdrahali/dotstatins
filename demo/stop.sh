#!/bin/sh 

docker-compose -f docker-compose-demo-js.yml -f docker-compose-demo-dotnet.yml -f docker-compose-demo-keycloak.yml down
