## Services

- [Transfer service](https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-core-transfer)
- [Authorization service](https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-core-auth-management)
- [Nsi webservice](https://webgate.ec.europa.eu/CITnet/stash/projects/SDMXRI/repos/nsiws.net/browse)
- [Keycloak](https://www.keycloak.org/)
 
## File overview

- [Single dataspace definition](docker-compose-single-dataendpoint-reset.yml)
    - Start with authentication & keycloak\
    `docker-compose -f docker-compose-single-dataendpoint-reset.yml -f keycloak-postgres.yml up`
    - Start services with anonymous access\
    `AUTH_ENABLED=false docker-compose -f docker-compose-single-dataendpoint-reset.yml up`
    - Stop all services\
    ` docker-compose -f docker-compose-single-dataendpoint-reset.yml -f keycloak-postgres.yml down`

- [Two dataspaces definition](docker-compose-two-dataenpoints-reset-persist.yml)
    - Start with authentication & keycloak\
    `docker-compose -f docker-compose-two-dataenpoints-reset-persist.yml -f keycloak-postgres.yml up`
    - Start services with anonymous access\
    `AUTH_ENABLED=false docker-compose -f docker-compose-two-dataenpoints-reset-persist.yml up`
    - Stop all services\
    ` docker-compose -f docker-compose-two-dataenpoints-reset-persist.yml -f keycloak-postgres.yml down`

- [Environment variables](.env) 

All docker images are using "latest" tag. **Note!** that "latest" tag image is built from recent commit into master or develop branch, so it might be unstable.
In case you have local copies of some of the images and you want to insure you are using the most recent run this command:

> docker-compose -f [DOCKER-COMPOSE FILE] pull

example that will pull new images for all services in **docker-compose-single-dataendpoint-reset.yml** and **keycloak-postgres.yml** files:

`docker-compose -f docker-compose-single-dataendpoint-reset.yml -f keycloak-postgres.yml pull`

## Keycloak

Keycloak on start imports sample [**siscc** realm](keycloak/siscc-realm.json), that contains `stat-suite` client, `admins` group and a user with a login/password `test-admin/admin`. 
Navigating to http://localhost:{KEYCLOAK_HTTP_PORT}/auth it's possible to add more users if needed.

The Keycloak main admin panel credentials are defined in .env file and by default are set to admin/admin.

## Configuration settings

| Variable | Description |Default value
|---------|-------------|-------------
|SA_PASSWORD|MSSQL sa Password for instance created as a docker container|My-Mssql-Pwd-123
|NSI_RESET_PORT|NSI HTTP port for a reset dataspace|80
|NSI_STABLE_PORT|NSI HTTP port for a stable dataspace|81
|TRANSFER_PORT|Transfer service HTTP port|83
|AUTH_PORT|Authorization service HTTP port|84
|SQL_PORT|Port of MSSQL instance running in container|1434
|**STRUCT_DB_RESET**|Name of Structure DB for reset dataspace|ResetStructDb
|STRUCT_DB_RESET_USER|Login of Structure DB for reset dataspace|testLoginResetStruct
|STRUCT_DB_RESET_PWD|Password of Structure DB for reset dataspace|testLogin(!)Password
|**DATA_DB_RESET**|Name of Data DB for reset dataspace|ResetDataDb
|DATA_DB_RESET_USER|Login of Data DB for reset dataspace|testLoginResetData
|DATA_DB_RESET_PWD|Password of Data DB for reset dataspace|testLogin(!)Password
|**STRUCT_DB_STABLE**|Name of Structure DB for stable dataspace|StableStructDb
|STRUCT_DB_STABLE_USER|Login of Structure DB for stable dataspace|testLoginStableStruct
|STRUCT_DB_STABLE_PWD|Password of Structure DB for stable dataspace|testLogin(!)Password
|**DATA_DB_STABLE**|Name of Data DB for stable dataspace|StableDataDb
|DATA_DB_STABLE_USER|Login of Data DB for stable dataspace|testLoginStableData
|DATA_DB_STABLE_PWD|Password of Data DB for stable dataspace|testLogin(!)Password
|**COMMON_DB**|Name of Common DB|CommonDb
|COMMON_DB_USER|Login of Common DB|testLoginCommon
|COMMON_DB_PWD|Password of Common DB|testLogin(!)Password
|SMTP_HOST|SMTP relay host|smtp.gmail.com
|SMTP_PORT|SMTP relay port|587
|SMTP_SSL|Is SMTP relay over SSL|true
|SMTP_USER|SMTP relay username|
|SMTP_PASSWORD|SMTP relay password|
|AUTH_ENABLED|Is authentication enabled for services|true
|KEYCLOAK_HOST|Keycloak host|localhost
|KEYCLOAK_HTTP_PORT|Keycloak port|8080
|KEYCLOAK_DB|Keycloak database name|KeyCloak
|KEYCLOAK_USER|Keycloak admin panel (**http://KEYCLOAK_HOST:KEYCLOAK_HTTP_PORT/auth**) username|admin
|KEYCLOAK_PWD|Keycloak admin panel (**http://KEYCLOAK_HOST:KEYCLOAK_HTTP_PORT/auth**) password|admin