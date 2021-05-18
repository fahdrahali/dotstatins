#!/bin/sh 

#﻿get docker
sudo apt install docker.io;

#get docker compose
#sudo apt install docker-compose;

sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

#get json validator
sudo apt install jsonlint;

#display json validator help screen (no version attribute)
jsonlint-php --help;

#display docker version
docker -v;

#display docker-compose version
docker-compose -v;
