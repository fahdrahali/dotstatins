:warning: dev folder is only for dev purpose

# Dotstatsuite Js / Docker-compose
All services, in this docker-compose, are JavaScript made related.  
In order to install all .Stat Suite servcies, add the docker-compose file .NET made related.

If you don't work on localhost, you need to change localhost by your domain name or IP. (explained below)

# Table of Contents
1. [Installation](#installation)
    1. [Docker architecture](#docker-architecture)
    2. [Config](#config)
    3. [.env](#.env)
    4. [run docker-compose](#run-docker-compose)
    5. [Keycloak Setup](#keycloak-setup)
2. [Update](#Update)
    1. [Update Docker-compose](#update-docker-compose)
    2. [Update Config](#update-config)
3. [Overview](#overview)

## Installation
### Docker architecture
```
├── dotstatsuite
│   ├── docker-compose.yml
│   ├── config (cf. Installation => Config)
│   ├── .env
```

> **WARNING**: in docker-compose.yml develop image will be downloaded.

### Config
```bash
git clone https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-config.git config
yarn
yarn dist
```

From now on, you need to chose what type of architecture: mono-tenant or multi-tenants.

#### Mono-tenant architecture

In this architecture type, only the default folder is required. You can delete all of the others tenants.

```
├── config
│   ├── node_modules                       
│   ├── dist                               
│   ├── configs                            
│   │   ├── datasources.json               
│   │   ├── tenants.json 
│   │   ├── default
│   │   │   ├── data-explorer
│   │   │   │   ├── i18n
│   │   │   │   ├── settings.json
│   │   │   ├── data-viewer
│   │   │   │   ├── i18n
│   │   │   │   ├── settings.json
│   ├── assets 
│   │   ├── default
│   │   │   ├── data-explorer
│   │   │   │   │   ├── images
│   │   │   │   │   ├── styles*
│   │   │   ├── data-viewer
│   │   │   │   │   ├── images
│   │   │   │   │   ├── styles*
│   ├── package.json
```
#### Multi-tenants architecture
```
├── config
│   ├── node_modules                       
│   ├── dist                               
│   ├── configs                            
│   │   ├── datasources.json               
│   │   ├── tenants.json 
│   │   ├── default
│   │   │   ├── data-explorer
│   │   │   │   ├── i18n
│   │   │   │   ├── settings.json
│   │   │   ├── data-viewer
│   │   │   │   ├── i18n
│   │   │   │   ├── settings.json
│   │   ├── my_tenant
│   │   │   ├── data-explorer
│   │   │   │   ├── i18n
│   │   │   │   ├── settings.json
│   │   │   ├── data-viewer
│   │   │   │   ├── i18n
│   │   │   │   ├── settings.json
│   ├── assets 
│   │   ├── default
│   │   │   ├── data-explorer
│   │   │   │   │   ├── images
│   │   │   │   │   ├── styles*
│   │   │   ├── data-viewer
│   │   │   │   │   ├── images
│   │   │   │   │   ├── styles*
│   │   ├── my_tenant
│   │   │   ├── data-explorer
│   │   │   │   │   ├── images
│   │   │   │   │   ├── styles*
│   │   │   ├── data-viewer
│   │   │   │   │   ├── images
│   │   │   │   │   ├── styles*
│   ├── package.json
```

#### Settings.json

You need to add `http://localhost:port/` in `settings.json` for your different applications.  
e.g.:
```json
"app": {
    "title": "OECD Data Explorer",
    "favicon": "/assets/siscc/data-explorer/images/favicon.ico"
  },
```
is changed to
```json
"app": {
  "title": "OECD Data Explorer",
  "favicon": "http://localhost:5007/assets/siscc/data-explorer/images/favicon.ico",
},
```

**Data-lifecycle-manager** need your data-explorer URL!

> **WARNING**: If you change the port, make sure to also change it in the settings file and .env!
```json
{
  "sdmx": {
    "datasourceIds": ["my_datasource_id"],
    "datasources": {
      "my_datasource_id": {
        "dataExplorerUrl": "http://localhost:7001",
        "color": "white",
        "backgroundColor": "#D24A44"
      }
   }
}
```

### .env

if you are not in localhost, then change HOST in this file.

> **WARNING**: If you change the port, make sure to also change it in the settings file and .env!

#### analytics

You can change GA_TOKEN in the .env by your google analytics token

### run docker-compose 

To run all services and build your config forlder.
```
docker-compose up --build
```

### Keycloak Setup

#### keycloack ssl deactivation (if not localhost)
```
docker exec -it keycloak bash
cd keycloak/bin/
./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin
./kcadm.sh update realms/master -s sslRequired=NONE
```

#### Keycloack configuration
go to http://localhost:8080  
add a client in Clients for master realm
  - client_id: app
  - root_url: http://localhost:7000     (port of dlm)

## Update

### Update Docker-compose

```
docker-compose pull
```

### Update Config
```
git pull
yarn 
yarn dist
```

> **WARNING**: after each change of config, you need to run yarn dist

## Overview

solr: http://localhost:8983  
redis: http://localhost:6379  
postgres: http://localhost:5432  
keycloak: http://localhost:8080  
config: http://localhost:5007  
data-lifecycle-manager: http://localhost:7000  
data-explorer: http://localhost:7001  
data-viewer: http://localhost:7002  
sdmx-faceted-search: http://localhost:3004  
share: http://localhost:3005  