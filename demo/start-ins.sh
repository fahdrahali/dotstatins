#!/bin/bash

echo "Starting Keycloak services"
docker-compose -f docker-compose-demo-keycloak.yml up -d

echo "Starting .Net services"
docker-compose -f docker-compose-demo-dotnet.yml up -d

echo "Starting JS services"
docker-compose -f docker-compose-demo-js.yml up -d

echo -n "Services being started."

