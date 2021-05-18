# The dotstatsuite-docker-compose repository

This repository contains .Stat Suite docker-compose sample files to ease deployments for developments, tests, pilots and demos using docker containers.
They can also be used as a starting point to setup production environments, but for that still need to be complemented with scaling, archiving, security configurations, etc.

# Setup of mono-tenant .Stat Suite v8 docker-based installation with two dataspaces

The aim of this document to provide a reference manual for setting up a demo .StatSuite v8 installation: a mono-tenant configuration with two dataspaces (*design* and *release*) using KeyCloak service for authentication.

For further details on the requirements please refer to the following GitLab ticket: https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-docker-compose/-/issues/4#note_373485821

This repository contains sample configuration files and unix shell scripts to help certain installation and configuration steps.

The installation has been tested in the following host operating systems:
- Linux
  - Ubuntu Server 18.04 LTS
- Windows
  - MS Windows 10 Pro 1809
  - MS Windows 10 Pro 1909

The root folder of this git repository's local copy is referenced as **$DOTSTATSUITE-DOCKER-COMPOSE-ROOT** in this document.
E.g. if you have cloned this repository to */c/git/dotstatsuite-docker-compose/* folder then any mention of *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT* means reference to that folder.

## Table of contents

[[_TOC_]]


## Quick start 

In this section you will find instruction how to start and stop docker services of demo mono-tenant installations with two dataspaces.

**It is assumed that the installation of all the required [prerequisites](#initialization-steps) are already successfully done.**

### Starting docker compose services of demo configuration

Open a new bash (Linux) or Git Bash (Windows) terminal. 
Please navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder.

Start the docker services with the following command:

```sh
$ ./start.sh 
```

On **Linux** systems the execution of this script may require *elevated privilege*.
In this case please start the script with 'sudo' command as follows:

```sh
$ sudo ./start.sh
```

When the script is executed without a parameter then it starts the services to run locally on your machine:
- On Windows the following hostname is used: host.docker.internal (which referst to the machine running the docker engine)
- On Linux one of the IP addresses is used (the first one returned by ifconfig)

The actually used hostname/ip address highlighted in green is shown in the 2nd line of the log written by the script:

>The following host address is being applied on configuration files:  host.docker.internal

If you want to make your demo installation accessible from other computers (e.g. when installation is done on a VM in the cloud) you have to provide the hostname/ip address of your host machine, e.g. when the hostname is *dotstat-demo.myorganization.org*:

```sh
$ ./start.sh dotstat-demo.myorganization.org
```

When all the services started properly, you should see the list of the running services on the screen started by the script.

In case you would need to see the logs produced by the containers, please see [this section](#checking-logs-of-detached-docker-containers).

### Stopping docker compose services of demo configuration

In a bash (Linux) or Git Bash (Windows) terminal, please navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder.

Execute the following script to stop the docker services:

```sh
$ ./stop.sh
```

On **Linux** systems the execution of this script may require *elevated privilege*.
In this case please start the script with 'sudo' command as follows:

```sh
$ sudo ./stop.sh
```

## Architecture

The following diagram shows the topology of the solution created by these scripts. To view diagrams for each component in more detail, see the [Architecture page](Architecture.md).

![](images/OverallArchDiagram.png "Overall Architecture of Solution")

## Basic Docker customization options

### Initialization steps

All docker images of .Stat Suite v8 are containerized in **Linux container images**.
As a result **there is no specific requirement on the host OS** only that it should be capable to run Linux containers.

Please make sure that the configured **TCP/IP ports of .Stat Suite are allowed on your firewall**.
When **using a VM in a cloud environment** (e.g. Azure, AWS, etc.) it is also important to configure the cloud network security rules to allow the inbound access of the same ports (e.g. on Azure the inbound security rules of the VM's network security group).

Please also make sure that the TCP/IP ports you are planning to use are not yet bound to other services running on the same machine.

For list of TCP ports used by default installation please see the following section: [Summary of TCP ports](#summary-of-tcp-ports)

If you are planning to access the .Stat installation from other machines also, it is important to have either **a static IP address or a hostname** that is dynamically bound to the IP of your machine running .Stat Suite docker containers.
E.g. in Azure environment a public IP address associated to the VM might be configured to be either static or to have a DNS name label.

Docker engine, docker cli and docker compose must be installed on your computer in order to use run docker containers of .Stat Suite v8. Please see the following sections on how to install them.

#### Linux 

Start a terminal session and navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/**demo*** folder.

##### Grant Execute permission
In Linux system scripts must have Execute permission granted in order to be able to use them from a command shell.
To grant execute permission on the helper shell scripts included in this repository please execute the following command in *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder:

```sh
$ chmod -R a+x */*.sh */scripts/*.sh -v 
```

While granting the permissions, the command displays the list of script files the Execute permission has been applied on.

##### Installation of prerequisites

For using docker compose on Linux system *docker.io* and *docker-compose* components need to be installed.

Run the following script to initialize your system for runnin docker containers with docker-compose.

```sh
$ init/initialization.linux.sh
```

<details>
<summary>Further details on what the script does</summary>

> Please note that on Linux systems the script may need elevated privileges to execute.
> In such a case use *sudo* prefix that will run the command with elevated privileges.
> ```sh
> $ sudo init/initialization.linux.sh
> ```
> 
> The script installs the following:
> - docker.io package
> - get docker-compose version 1.25.5
> - jsonlint package - for easy validation of JSON files

</details>

When the script executed you shall see the following on your screen (version numbers may be higher):

```
 Usage: jsonlint file [options]
 
 Options:
   -q, --quiet     Cause jsonlint to be quiet when no errors are found
   -h, --help      Show this message
 Docker version 19.03.6, build 369ce74a3c
 docker-compose version 1.25.5, build 8a1c60f6
```

For editing json and yml configuration files you can use *nano* or any other text editor of your preference.

#### Windows (desktop)

##### Installation of prerequisites

Install *Docker Desktop* from the following link: https://www.docker.com/products/docker-desktop

- *Hyper-V* installation (older way):
Installation of Docker Desktop CE (Community Edition): https://docs.docker.com/docker-for-windows/install/
When prompted, ensure the *Enable Hyper-V Windows Features* option is selected on the *Configuration* page (it is the default selection in the installer), this is required for running Linux based containers on a Windows machine.

- *WSL 2* installation (new way):
From Windows 10, version 2004 or higher another option could be to use the Docker Desktop WSL 2 backend.
We haven't yet tested this option, but WSL seems to be the future of docker development on Windows, and apparently offers many advantages compared to Hyper-V solution, including performance gains.
Installation of Docker Desktop WSL 2 backend: https://docs.docker.com/docker-for-windows/wsl/

After installation please make sure that your Docker Desktop client uses Linux containers (this is the default setup): https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers

It is also recommended to increase the size of memory that can be used by the Docker engine to at least a minimum of 8Gb, this can be done in the Docker settings panel.

Install *Git for Windows* from the following link: https://gitforwindows.org/

During installation when asked please choose MinTTY terminal emulator (default selection). Having this bash shell will let you run the unix shell scripts on your Windows environemnt to help your installation.

When the installations are done check the verison of docker and docker compose by executing the following script in a Git Bash terminal window:

```sh
$ docker --version && docker-compose --version
```

You shall see the following on your screen (version numbers can be higher):

```
 Docker version 19.03.8, build afacb8b
 docker-compose version 1.25.5, build 8a1c60f6
```

In order to run docker containers, the Docker Desktop client application has to be started and running in Linux containers mode.

For editing json and yml configuration files you can use *Notepad++* (https://notepad-plus-plus.org/downloads/) with *JSON Viewer plugin* or any other text editor of your preference.

### Keycloak service

In *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/docker-compose-demo-keycloak.yml* docker-compose file the Keycloak service is configured to use a Postgres database instance for storing data.

#### List of docker containers used in *docker-compose-demo-keycloak.yml*

<details>
<summary>Docker containers used</summary>

> Location of docker compose file: *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**docker-compose-demo-keycloak.yml***
> 
> |Image name|Version|Description|Official site
> |----------|-------|-----------|-------------
> |[jboss/keycloak](https://hub.docker.com/r/jboss/keycloak)|7.0.0|[Keycloak](https://www.keycloak.org/)|https://github.com/keycloak/keycloak-containers
> |[postgres](https://hub.docker.com/_/postgres)|12|[PostgreSQL database](https://www.postgresql.org/)|https://github.com/docker-library/postgres

</details>

#### Configuration of Keycloak service (Optional)

In *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder there is a .env file containing the environment variables used by the docker-compose file including *docker-compose-demo-keycloak.yml*.
You can leave the default values (not in production environments!) or you can change them according to your preferences.

##### List and description of Keycloak parameters with defaults

<details>
<summary>Keycloak parameters</summary>

> Location of Keycloak service parameters: *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**.env***
> 
> | Variable | Description |Default value
> |----------|-------------|-------------
> |KEYCLOAK_USER|Admin username on Keycloak admin panel (http://*KEYCLOAK_HOST:KEYCLOAK_PORT*/auth)|admin
> |KEYCLOAK_PWD|Admin password on Keycloak admin panel (http://*KEYCLOAK_HOST:KEYCLOAK_PORT*/auth)|admin
> |KEYCLOAK_PORT|HTTP port of Keycloak|8080
> |KEYCLOAK_DB|Name of Keycloak's Postgres database|keycloak
> |KEYCLOAK_DB_USER|Database username|keycloak
> |KEYCLOAK_DB_PASSWORD|Database password|password
> |KEYCLOAK_DB_PORT|Port of Postgres database|5432

</details>

#### Start KeyCloak service

Open a new bash (Linux) or Git Bash (Windows) terminal. Please navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder.

Start KeyCloak service with the following command:

```sh
$ docker-compose -f ./docker-compose-demo-keycloak.yml up
```

The keycloak container has started properly if you see the following log entry from keycloak service in the last row:
``` 
INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: Keycloak 7.0.0 (WildFly Core 9.0.2.Final) started in 24580ms - Started 683 of 988 services (701 services are lazy, passive or on-demand)
```

Please note that it may take a while for Keycloak service to start up.

<details>
<summary>Further details on what the command does</summary>

> Keycloak services are started in *line 51* in start.sh.
>
> The script creates, starts and attaches to containers of services defined in*$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/docker-compose-demo-keycloak.yml*.
> This command also aggregates the output of each container and displays them in the terminal window.
> 
> Press *Ctrl+C* to abort the command. When the command exits, all containers are stopped.
> 
> If you prefer to start containers running in the background please execute the following command instead:
> 
> ```sh
> $ ./docker-compose -f ./docker-compose-demo-keycloak.yml up -d
> ```
> 
> Please note that when containers are run in the background they are executed in detached mode and their logs are not displayed in the current window.
> For further info on how to display the logs of docker containers please see [this section](#checking-logs-of-detached-docker-containers).
>
> To terminate keycloak containers running in the background execute the following command:
> 
> ```sh
> $ ./docker-compose -f ./docker-compose-demo-keycloak.yml down
> ```
> 

</details>

#### Verification of Keycloak service

To see if Keycloak works properly or needs additional configuration the admin page of Keycloak service should be opened.

Please open the admin page in your browser with the following link after applying the hostname or ip address of your server and the keycloak port (by default 8080):

http://*[hostname_or_ip_address_of_your_server]:KEYCLOAK_PORT*/auth

Apply the hostname or IP address of your machine where the keycloak docker installation is running, e.g.:
http://dotstat-demo.myorganization.org:8080/auth

On the main page of Keycloak application click on *"Administration Console >"* link and the login page should appear.

<details>
<summary>In case of <b>HTTPS required</b> message ...</summary>

> In case of linux installation and/or not addressing your server from localhost you may see the following error message instead of the login screen: *HTTPS required*
> 
> This means that *"Require SSL"* flag of the master realm defined in Keycloak has to be set to *"none"* before being able to login without https.
> To do so open **another terminal window** (bash or Git Bash) and navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/* folder and execute the following script:
> 
> ```sh
> $ scripts/disable-ssl.sh
> ```
> 
> **Important!** When this script is executed **the keycloak service must be running** (launched in the other terminal window earlier).
> 
> When the script finishes, you should see the following:
> 
> ```
> Logging into http://localhost:8080/auth as user admin of realm master
> Done.
> ```
> 
> <details>
> <summary>Further details on what the script does</summary>
>   
> > The script connects to the running Keycloak container, opens a bash terminal and executes the following commands inside the container to alter the *sslReqired* flag:
> > 
> > ```sh
> > #The following commands are executed inside the container by disable-ssl.sh script
> > cd /opt/jboss/keycloak/bin/
> > ./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user \$KEYCLOAK_USER --password \$KEYCLOAK_PASSWORD 
> > ./kcadm.sh update realms/master -s sslRequired=NONE"
> > ```
>  
> </details>
> 
> Try to open the Keycloak administration page again in your browser and this time you should see the login page.

</details>

On the login page enter the Keycloak admin username and password according to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/.env* file.
Their default values are *"admin"* and *"password"*.

The Keycloak instances import the *demo* realm upon startup from *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/realm/demo-realm.json* file.
The file contains definition of a realm with the following details:
- The id of the realm is *demo* (http://[hostname_or_ip_address_of_your_server]:8080/auth/admin/master/console/#/realms/demo)
- There is a client (application) defined with id *stat-suite*
- There is a group defined in the realm: *admins*
- There is one (application) user defined in the realm:
  - username: *test-admin*
  - password: *admin*  
  - group membership: *admins*

##### Setting up email address for receiving reports of transactions (optional)
<details>
<summary>Setting up email address for receiving reports of transactions</summary>

> If you are planning to setup SMTP mail server at .Net back-end service configuration to receive reports of import and transfer transactions in email, then you can configure your email address now.
> 
> If you are planning to use the default *test-admin* user later on, you can change the user's email address on the Keycloak admininistration interface to yours by doing the following steps:
> - Login to Keycloak administration interface
> - Select *demo* realm (is selected by default)
> - Manage -> Users -> View all users
> - Click on id of *test-admin* user
> - On *Details* tab change *Email* to your email address
> - Save your changes by clicking *Save* button at the bottom of the form.
> 
> Another option could be to add new users, and specify the email addresses of these users.
> Please note that by default only the *admins* group has permission defined in *Authorization Management service*.

</details>

**Your Keycloak setup is complete now.**

### .Net back-end services

The *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/docker-compose-demo-dotnet.yml* docker-compose file contains definition of .Net based back-end services and the database engine:
- NSI WS instances with .Stat Data plugin for the two dataspaces (design and release)
- Transfer web service
- Authorization Management web service
- Microsoft SQL Server for Linux

#### List of docker containers used in *docker-compose-demo-dotnet.yml*

<details>
<summary>Docker containers used</summary>

> Location of docker-compose file: *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**docker-compose-demo-dotnet.yml***
> 
> |Image name|Version|Description|Repository
> |----------|-------|-----------|-------------
> |[siscc/sdmxri-nsi-maapi](https://hub.docker.com/r/siscc/sdmxri-nsi-maapi)|master|SDMX web service (for structure upload/download) plugged to .Stat DB based on ESTAT's NSI WS| https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-core-sdmxri-nsi-ws
> |[siscc/dotstatsuite-core-transfer](https://hub.docker.com/r/siscc/dotstatsuite-core-transfer)|master|Transfer web service|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-core-transfer
> |[siscc/dotstatsuite-core-auth-management](https://hub.docker.com/r/siscc/dotstatsuite-core-auth-management)|master|Authorization Management web service|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-core-auth-management
> |[siscc/dotstatsuite-dbup](https://hub.docker.com/r/siscc/dotstatsuite-dbup)|master|Database initialization/upgrade tool|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-core-data-access
> |[mcr.microsoft.com/mssql/server](https://hub.docker.com/_/microsoft-mssql-server)|2017-latest-ubuntu|Microsoft SQL Server for Linux|https://github.com/microsoft/mssql-docker
> |[vigurous/wait4sql](https://hub.docker.com/r/vigurous/wait4sql)|latest|Database startup helper tool|-

</details>

#### Configuration of .Net back-end services

In *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/* folder there is a *.env* file containing the environment variables used by *docker-compose-demo-dotnet.yml* docker-compose file.

##### Setting host of Keycloak service

You can leave most of the default values (not in production environments!) in case you are planning to use this .Stat Suite installation only from localhost.
But if you'd like **to access** the .Stat Suite installation **from other machines, you have to update KEYCLOAK_HOST** value in the *.env* file to the hostname or ip address of your machine that runs the Keycloak service, e.g.:

```
KEYCLOAK_HOST=dotstat-demo.myorganization.org
```

##### Setting parameters of SMTP service

The SMTP related parameters are used by the transfer service to send the execution report of import or transfer requests to users.
The configuration of SMTP service is optional for development, testing or demoing purposes.
If it is not enabled, the developer or system administrator can review the user's activity in the Transfer service's log files.

In case you would like to have Transfer service to send mails with results of data import and transfer transaction, you can configure SMTP details in the *.env* file.
By default the docker-compose examples are not configured to send emails.

Further details on setting up a Gmail account for SMTP service can be found here: [gmail_smtp_example.md](dotnet/gmail_smtp_example.md)

##### List and description of .Net service parameters with defaults

<details>
<summary>.Net service parameters</summary>

> Location of .Net back-end service paramters:
> *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**.env***
> 
> | Variable | Description |Default value
> |----------|-------------|-------------
> |SA_PASSWORD|Admin password of MS SQL database|My-Mssql-Pwd-123
> |NSI_DESIGN_PORT|Port of NSI WS - Design instance|80
> |NSI_RELEASE_PORT|Port of NSI WS - Release instance|81
> |TRANSFER_PORT|Port of Transfer service|93
> |AUTH_PORT|Port of Authorization Management service|94
> |SQL_PORT|Port of MS SQL Server|1434
> |STRUCT_DB_DESIGN|Name of structure database (Design dataspace)|DesignStructDb
> |STRUCT_DB_DESIGN_USER|Username for structure database (Design dataspace)|testLoginDesignStruct
> |STRUCT_DB_DESIGN_PWD|Password for structure database (Design dataspace)|testLogin(!)Password
> |STRUCT_DB_DESIGN_SERVER|Name of the database server (Design dataspace)|db (default name of MS SQL instance running in container)
> |DATA_DB_DESIGN|Name of data database (Design dataspace)|DesignDataDb
> |DATA_DB_DESIGN_USER|Username for data database (Design dataspace)|testLoginDesignData
> |DATA_DB_DESIGN_PWD|Password for data database (Design dataspace)|testLogin(!)Password
> |DATA_DB_DESIGN_SERVER|Name of the database server (Design dataspace)|db (default name of MS SQL instance running in container)
> |STRUCT_DB_RELEASE|Name of structure database (Release dataspace)|ReleaseStructDb
> |STRUCT_DB_RELEASE_USER|Username for  structure database (Release dataspace)|testLoginReleaseStruct
> |STRUCT_DB_RELEASE_PWD|Password for structure database (Release dataspace)|testLogin(!)Password
> |STRUCT_DB_RELEASE_SERVER|Name of the database server (Release dataspace)|db (default name of MS SQL instance running in container)
> |DATA_DB_RELEASE|Name of data database (Release dataspace)|ReleaseDataDb
> |DATA_DB_RELEASE_USER|Username for data database (Release dataspace)|testLoginReleaseData
> |DATA_DB_RELEASE_PWD|Password for data database (Release dataspace)|testLogin(!)Password
> |DATA_DB_RELEASE_SERVER|Name of the database server (Release dataspace)|db (default name of MS SQL instance running in container)
> |COMMON_DB|Name of common database|CommonDb
> |COMMON_DB_USER|Username for common database|testLoginCommon
> |COMMON_DB_PWD|Password for common database|testLogin(!)Password
> |COMMON_DB_SERVER|Name of the database server of common database|db (default name of MS SQL instance running in container)
> |SMTP_HOST|SMTP server hostname or IP address|smtp.gmail.com
> |SMTP_PORT|SMTP server port|587
> |SMTP_SSL|SMTP server uses SSL|true
> |SMTP_USER|SMTP server username|*empty*
> |SMTP_PASSWORD|SMTP server password|*empty*
> |AUTH_ENABLED|Is authentication enabled|true
> |KEYCLOAK_HOST|Hostname or ip address of Keycloak service|localhost
> |KEYCLOAK_PORT|Port set for Keycloak service|8080
> |KEYCLOAK_REALM|The realm defined in Keycloak|demo
> |KEYCLOAK_CLIENT_ID|The id of the client defined in KEYCLOAK_REALM|stat-suite

</details>

#### Start of .Net back-end services

Open a new bash (Linux) or Git Bash (Windows) terminal.
Please navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder.

Start the backend services with the following command:

```
$ docker-compose -f ./docker-compose-demo-dotnet.yml up
```

Please note that it may take a while for all the service defined in the file to start up, especially the database instance.

<details>
<summary>Further details on what the script does</summary>

> Dotnet services are started in *line 54* in start.sh.
>
> The script creates, starts, and attaches to containers of services defined in  *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/docker-compose-demo-dotnet.yml*.
> This command also aggregates the output of each container and displays them in the terminal window.
> 
> Press *Ctrl+C* to abort the command. When the command exits, all containers are stopped.
> 
> If you prefer to start containers running in the background please execute the following command instead:
> ```sh
> $ docker-compose -f ./docker-compose-demo-dotnet.yml up -d
> ```
> 
> Please note that when containers are run in the background they are executed in detached mode and their logs are not displayed in the current window.
> For further info on how to display the logs of docker containers please see [this section](#checking-logs-of-detached-docker-containers).
>
> To terminate .Net back-end containers running in the background execute the following command:
> 
> ```sh
> $ docker-compose -f ./docker-compose-demo-dotnet.yml down
> ```

</details>

It is normal if among of the first half of the log entries there are number of log entries containing error messages about the database connection.
This is because during the startup of the database server the services cannot connect to the database and they keep on trying until the database becomes online.
Once the database started (depending on the machine and docker configuration it can take even a few minutes) the other services shall continue normally.
 
#### Verification of .Net back-end services

##### Healthchecks
When all the services have started you can check them as follows.

If the .Stat Suite installation is intended to be used with localhost access only, you can use the following links:
- NSI WS (Design dataspace): http://localhost:80/health
- NSI WS (Release dataspace): http://localhost:81/health
- Transfer service: http://localhost:93/health
- Authorization Management service: http://localhost:94/health

Othwerwise please use the following pattern with using the proper hostname/ip address: 
- NSI WS (Design dataspace): http://[hostname_or_ip_address_of_your_server]:80/health
- NSI WS (Release dataspace): http://[hostname_or_ip_address_of_your_server]:81/health
- Transfer service: http://[hostname_or_ip_address_of_your_server]:93/health
- Authorization Management service: http://[hostname_or_ip_address_of_your_server]:94/health

##### Verification of NSI WS instances

The structure databases of NSI WS instances contain a few pre-defined codelists.
By querying them the installation of NSI WS instances can be verified.

If the .Stat Suite installation is intended to be used with localhost access only, you can use the following links:
- Codelists defined in Design dataspace: http://localhost:80/rest/codelist
- Codelists defined in Release dataspace: http://localhost:81/rest/codelist

Othwerwise please use the following pattern with using the proper hostname/ip address: 
- Codelists defined in Design dataspace: http://[hostname_or_ip_address_of_your_server]:80/rest/codelist
- Codelists defined in Release dataspace: http://[hostname_or_ip_address_of_your_server]:81/rest/codelist

##### Verification of the connection to Keycloak service

Swagger UI of Transfer and Authorization Management services can be used to check if the .Net back-end services work properly with the Keycloak service.

If the .Stat Suite installation is intended  to be used with localhost access only, you can use the following links: 
- Swagger UI of Transfer service: http://localhost:93/swagger/index.html
- Swagger UI of Authorization Management service: http://localhost:94/swagger/index.html

Otherwise the following ones with the proper hostname/ip address applied:
- Swagger UI of Transfer service: http://[hostname_or_ip_address_of_your_server]:93/swagger/index.html
- Swagger UI of Authorization Management service: http://[hostname_or_ip_address_of_your_server]:94/swagger/index.html

In the following example the swagger interface of Authorization Management service will be used:
- Open the Swagger UI of Authorization Management service
- On the page click on *Authorize* button 
- Then on the pop-up window click on *Authorize* again
- On the login page enter the application user name defined in the *demo* realm of Keycloak. By default it is *test-admin* and *admin*.
- After successful Keycloak authorization click *Close* on "Available authorizatios" window.

Now you are authenticated and should be able to execute the the methods exposed on swagger UI:
- Select the first method *"​/{version}​/AuthorizationRules List all authorization rules"*
- Click on *"Try it out"*
- Apply the following version : 1.1
- Click on *"Execute"*
- You should see a *HTTP200* response with authorization rule definitions in the response body.

<details>
<summary>Sample json response with authorization rule definitions</summary>

> ```json
> {
>   "payload": [
>     {
>       "id": 1,
>       "userMask": "admin",
>       "isGroup": false,
>       "dataSpace": "*",
>       "artefactType": 0,
>       "artefactAgencyId": "*",
>       "artefactId": "*",
>       "artefactVersion": "*",
>       "permission": 2047
>     },
>     {
>       "id": 2,
>       "userMask": "admins",
>       "isGroup": true,
>       "dataSpace": "*",
>       "artefactType": 0,
>       "artefactAgencyId": "*",
>       "artefactId": "*",
>       "artefactVersion": "*",
>       "permission": 2047
>     }
>   ],
>   "success": true
> }
> ```

</details>


**Your .Net back-end services setup is complete now.**

### JavaScript services

The *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/docker-compose-demo-js.yml* docker-compose file contains definition of JavaScript based services as well as Solr and Redis servers:
- DLM - .Stat Data Lifecycle Manager
- DE - .Stat Data Explorer
- Configuration server
- Share server
- Data viewer server
- SDMX faceted search server
- Apache Solr server
- Redis server

#### List of docker containers used in *docker-compose-demo-js.yml*

<details>
<summary>Docker containers used</summary>

> |Image name|Version|Description|Official site/Repository
> |----------|-------|-----------|------------------------
> |[solr](https://hub.docker.com/_/solr)|7.7.2|[Apache Solr](https://lucene.apache.org/solr/)|https://github.com/docker-solr/docker-solr
> |[redis](https://hub.docker.com/_/redis)|5.0.3|[Redis key-value store](https://en.wikipedia.org/wiki/Redis)|https://github.com/docker-library/redis
> |[siscc/dotstatsuite-config-prod](https://hub.docker.com/r/siscc/dotstatsuite-config-dev)|master|Configuration server|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-config
> |[siscc/dotstatsuite-data-lifecycle-manager](https://hub.docker.com/r/siscc/dotstatsuite-data-lifecycle-manager)|master|.Stat Data Lifecycle Manager (DLM)|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-data-lifecycle-manager
> |[siscc/dotstatsuite-data-explorer](https://hub.docker.com/r/siscc/dotstatsuite-data-explorer)|master|.Stat Data Explorer (DE)|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-data-explorer
> |[siscc/dotstatsuite-share](https://hub.docker.com/r/siscc/dotstatsuite-share)|master|Share server|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-share
> |[siscc/dotstatsuite-data-viewer](https://hub.docker.com/r/siscc/dotstatsuite-data-viewer)|master|Data viewer server|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-data-viewer
> |[siscc/dotstatsuite-sdmx-faceted-search](https://hub.docker.com/r/siscc/dotstatsuite-sdmx-faceted-search)|master|SDMX Faceted Search server|https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-sdmx-faceted-search

</details>


#### Configuration of JavaScript services

You can leave most of the configuration parameters with their defualt values.
It's actually expected in case you would like to use the helper scripts of this repository for quicker setup of the monotenant installation of .Stat Suite with two dataspaces defined in .Net (back-end) services.

The only exception is the HOST parameter.
In case you are planning to use this .Stat Suite installation only from localhost, you don't have to do anything with it.
But if you'd like **to access** the .Stat Suite isntallation **from other machines, you have to update HOST** value in the *.env* file to the hostname or ip address of your machine that runs the docker containers, e.g.:

```
HOST=dotstat-demo.myorganization.org
```

##### List and description of JavaScript service parameters with defaults

<details>
<summary>JavaScript service parameters</summary>

> Location of JavaScript service parameters:
> *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**.env***
> 
> | Variable | Description |Default value
> |----------|-------------|-------------
> |CONFIG_PORT|Port of configuration service|5007
> |DLM_PORT|Port of Data Lifecycle Management service|7000
> |DE_PORT|Port of DataExplorer service|7001
> |VIEWER_PORT|Port of Data Viewer service|7002
> |SHARE_PORT|Port of Share service|3005
> |SFS_PORT|Port of Search service|3004
> |SOLR_PORT|Port of SolR service|8983
> |REDIS_PORT|Port of Redis service|6379
> |KEYCLOAK_PORT|Port of Keycloak service|8080
> |TRANSFERT_PORT|Port of Transfer service|93
> |PROTOCOL|Protocol used by services|http
> |HOST|Hostname or ip address of the machine hosting the docker services|localhost
> |DEFAULT_TENANT|Id of the default tennant|default
> |TRANSFER_API_VERSION|API version of Transfer service|1.2
> |GA_TOKEN|Google Analytics token|''
> |AUTH_PROVIDER|Name of your authentification service|''
> |SHARE_DB_INDEX|index of share db|'0'
> |SFS_DB_INDEX|index of sfs db|'1'

</details>

##### Redis db configuration

We are using two databases in redis, respectively for share data and search config.  
Default indexes are provided by the default parameters `REDIS_DB` and can be overridden.

**Warning:** the version ^7.0.0 of the dotstatsuite introduces the 2 databases.  
Before this version only there was only one database and flushing search config data was causing the deletion of share data.  
In order to keep existing share data, default indexes are set to keep existing share data:
- 0 for share (keep the existing database)
- 1 for search config (this new database will be automatically created and will require to reindex all dataflows)

##### Initialization of JavaScript services (monotenant with two dataspaces)

Open a third terminal window (bash or Git Bash) and navigate to the *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/* folder.
Execute the following script to initialize a monotenant installation with two dataspaces using the sample files from the repository:

```sh
$ scripts/init.config.mono-tenant.two-dataspaces.sh
```

At the end of execution you should see the following message:

```
Done. Files updated with the following host address: localhost
Done.
```

<details>
<summary>Further details on what the script does</summary>

> The script is executed in *line 38* of start.sh.
>
> 1. The script clones the [config](https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-config) git library *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/config/ directory.
> 2. From the local copy of the config repository removes the following tenant folders:
> - config/data/prod/configs/default/
> - config/data/prod/configs/abs/
> - config/data/prod/configs/astat/
> - config/data/prod/configs/ins/
> - config/data/prod/configs/oecd/
> - config/data/prod/configs/statec/
> - config/data/prod/configs/statsnz/
> 3. Renames *siscc* tenant folder to *default*
> 4. Copies sample files configuration json files from *samples/mono-tenant-two-dataspaces/*
> 5. Replaces default urls to localhost
> 
> You will have the following directory and file structure in *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/config/data/prod/configs* folder:
> 
> ```
> ├── configs
> │   ├── datasources.json
> │   ├── tenants.json
> │   ├── default
> │   │   ├── data-explorer
> │   │   │   ├── i18n
> │   │   │   ├── settings.json
> │   │   ├── data-lifecycle-manager
> │   │   │   ├── i18n
> │   │   │   ├── settings.json
> │   │   ├── data-viewer
> │   │   │   ├── i18n
> │   │   │   ├── settings.json
> ```

</details>

##### Changing localhost to hostname or ip address (optional)
At this point the front-end services are configured to be used from localhost and if you are planning to access your .Stat Suite installation from your local machine only, you can skip this section.

If you want to use the services from other location then the localhost reference should be replaced to the actual hostname or ip address of the server.
To do that:
- edit the .env file and replace value of HOST to the hostname/ip address of your server (to the same value used at backend config)
- replace links pointing to localhost in *datasources.json* and applications' *settings.json* files. The simplest way to do that is to execute the following script from folder *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* (please replace **hostname_or_ip_address_of_your_server** with the actual hostname/ip address of your server):

```sh
$ scripts/replace.server.address.sh config/data/prod/configs/ **hostname_or_ip_address_of_your_server** localhost
```

When the script executed normally you should see no error messages and the following at the end of the log:

```
Done. Files updated with the following host address: **hostname_or_ip_address_of_your_server**
```

<details>
<summary>Further details on what the script does</summary>

> The script takes 3 command line parameters in general:
> 
> ```sh
> $ scripts/replace.server.address.sh param1 param2 param3
> ```
> 
> The description of the parameters:
> - param1: the path to the directory the configuration files should be looked for. Can be relative or absolute path, must end with / (slash)
> - param2: the new server address that should be applied in json config files
> - param3: the old server address that should be replaced in json config files.
> 
> The script looks for json configuration files and updates the following patterns:
> - settings.json files:
>    - "http://**server_address**:3004/api"
>    - "http://**server_address**:7002"
>    - "http://**server_address**:3005/api/charts"
>    - "http://**server_address**:3005"
>    - "http://**server_address**:7001"
> - datasources.json file:
>    - "http://**server_address**:
>    - "http://**server_address**/
> 
> Sample log of successfull execution:
> 
> ```
> Working folder: config/data/prod/configs/
> Replace host to: **hostname_or_ip_address_of_your_server**
> Replace host from (not mandatory): localhost
> Files detected:
> config/data/prod/configs/default/data-lifecycle-manager/settings.json
> config/data/prod/configs/default/data-explorer/settings.json
> config/data/prod/configs/default/data-viewer/settings.json
> config/data/prod/configs/datasources.json
> Done. Files updated with the following host address: **hostname_or_ip_address_of_your_server**
> ```

</details>

##### Check validity of json configuration files (optional but recommended)

Javascript services expect valid JSON configuration files in order to function properly.
In case you experience broken/weird functionality on user interface of DLM and/or DE after a change in configuration file(s) there is a chance of accidental mistake made in one of the config files, turning it to an invalid JSON file.

It is recomended to check validity of the following JSON configuration files:
- datasources.json
- tenants.json
- default/data-lifecycle-manager/settings.json
- default/data-explorer/settings.json
- default/data-viewer/settings.json

Please note that not always obvious to find what makes a json file invalid, e.g. BOM (byte order mark) at the beginning of the file or CR+LF instead of LF as line-ending characted could be such barely visible causes.

###### Validation in Linux

Check validity of json configuration files with the following command from *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder:

```sh
$ scripts/check.json.validity.sh config/data/prod/configs/
```

You should see one row for each file verified, either the "Valid JSON" message or the error description.
<details>
<summary>Further details ...</summary>

> The script uses jsonlint-php tool to check all json files in the *config/data/prod/configs/* folder.
> 
> A sample result can be seen below where all files are valid:
> 
> ```
> Valid JSON (config/data/prod/configs/datasources.json)
> Valid JSON (config/data/prod/configs/tenants.json)
> Valid JSON (config/data/prod/configs/default/data-lifecycle-manager/i18n/nl.json)
> Valid JSON (config/data/prod/configs/default/data-lifecycle-manager/i18n/fr.json)
> Valid JSON (config/data/prod/configs/default/data-lifecycle-manager/i18n/en.json)
> Valid JSON (config/data/prod/configs/default/data-lifecycle-manager/i18n/ar.json)
> Valid JSON (config/data/prod/configs/default/data-lifecycle-manager/settings.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/es.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/nl.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/fr.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/km.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/en.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/ar.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/i18n/it.json)
> Valid JSON (config/data/prod/configs/default/data-explorer/settings.json)
> Valid JSON (config/data/prod/configs/default/data-viewer/i18n/nl.json)
> Valid JSON (config/data/prod/configs/default/data-viewer/i18n/fr.json)
> Valid JSON (config/data/prod/configs/default/data-viewer/i18n/km.json)
> Valid JSON (config/data/prod/configs/default/data-viewer/i18n/en.json)
> Valid JSON (config/data/prod/configs/default/data-viewer/i18n/ar.json)
> Valid JSON (config/data/prod/configs/default/data-viewer/settings.json)
> ```

</details>

###### Validation on Windows

An option for validity checking of Json files on Windows could be Notepad++ with JSONViewer plugin but any tool of your preference could be used.

#### Start JavaScript services

Open a new bash (Linux) or Git Bash (Windows) terminal. Please navigate to *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* folder and start the services with the following command:

```sh
$ docker-compose -f ./docker-compose-demo-js.yml up
```

<details>
<summary>Further details on what the script does</summary>

> JavaScript services are started in *line 57* in start.sh.
>
> The script creates, starts, and attaches to containers of services defined in *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/docker-compose-demo-js.yml*.
> This command also aggregates the output of each container and displays them in the terminal window.
> 
> Press *Ctrl+C* to abort the command. When the command exits, all containers are stopped.
> 
> If you prefer to start containers running in the background please execute the following command instead:
> ```sh
> $ docker-compose -f ./docker-compose-demo-js.yml up -d
> ```
> 
> Please note that when containers are run in the background they are executed in detached mode and their logs are not displayed in the current window.
> For further info on how to display the logs of docker containers please see [this section](#checking-logs-of-detached-docker-containers).
>
> To terminate the JavaScript containers running in the background execute the following command:
> 
> ```sh
> $ docker-compose -f ./docker-compose-demo-js.yml down
> ```

</details>

##### Verification of JavaScript services

###### DLM
When all service have started open the Data Lifecycle Manager page in a browser as follows.
If all configurations have been done previously for localhost access you can use this link: http://localhost:7000/
othwerwise please use the following format: http://[hostname_or_ip_address_of_your_server]:7000/

If you are requested to login, use the configured (application) user, by default *"test-admin"* with the password *"admin"*.

After successful login you should see the homepage of DLM with TestAdmin user authenticated.

Please select both dataspace filters (demo-design and demo-release) and also check the "Codelist" artefact type.

Now the default codelists defined in mapping store should appear on the screen.

###### DE

Open the Data Explorer page in a browser as follows.
If all configurations have been done previously for localhost access you can use this link:
http://localhost:7001/

othwerwise please use the following format: http://[hostname_or_ip_address_of_your_server]:7001/

You should see the Data Explorer main page appearing properly.

**Your JavaScript services setup is complete now.**

### Further steps

#### Checking logs of detached docker containers

When the containers of .Stat Suite v8 are started with docker compose in detached mode (using the *'-d'* parameter) the logs written by the containers are not displayed on the screen.

> At the time of writing this document, *docker-compose logs* command does not support custom compose file names.
> It can only use the default files names (docker-compose.yml and docker-compose.yaml), therefore the usage of *docker logs* command is described in this section.
> Although, the parameters of *docker-compose logs* are somewhat similar to *docker logs* command.


To display a log written by a (detached) container you will need either the *container id* or the *name* of the container.
The container may be stopped or running.

To see the list of containers (running and exited) use the following command:

```sh
$ docker ps -a
```

This command displays the running and exited containers. The first column of the table (*CONTAINER ID*) shows the id of the container, the last column (*NAMES*) contain the name of the container.
To display the logs written by a container **you can use either the ID or the name of the container**.

E.g.: to display the logs written by the *keycloak* service *so far*, use the following command:
 
```sh
$ docker logs keycloak
```

The command displays the logs written by *keycloak* service on the screen and returns to the shell.

Please note that *docker logs* command displays logs written to both standard output and standard error.
It may result in unexpected behaviour when piping (e.g. when filtering the logs using *grep*) as only the standard output is redirected to the next command in the pipe.
To overcome this issue the standard error of *docker logs* should be redirected either to standard output or /dev/null depending on whether you want to pass the logs of standard error or not:

```sh
$ docker logs keycloak 2>&1 | grep 'started in'
```

```sh
$ docker logs keycloak 2>/dev/null | grep 'started in'
```

In case you want to monitor real-time the logs written by a running service, use the '*-f*' or '*--follow*' parameter.

E.g. to monitor the activity of the *nsiws-demo-release* service, use the following command:

```sh
$ docker logs nsiws-demo-release -f
```

The command displays the logs written by *nsiws-demo-release* so far and does not terminate but keeps displaying the upcoming log entries of the container. The command command can be terminated by pressing *Ctrl+C*.

For further reference please see the following links:
- [docker logs](https://docs.docker.com/engine/reference/commandline/logs/)
- [docker-compose logs](https://docs.docker.com/compose/reference/logs/)

#### Changing the IP address/hostname of your machine

Before applying the changes on configuration files please stop the dotnet and js docker services.

In case the IP address or the hostname you used previously in your .Stat Suite installation is changed, you need to update the following configuration files to apply the new IP address or hostname:
- *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**.env***
    Change value of **KEYCLOAK_HOST** variable to the new hostname or ip address of your machine:
    ```
    KEYCLOAK_HOST=new-dotstat-demo.myorganization.org
    ```
- *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/**.env***
    Change value of **HOST** variable to the new hostname or ip address of your machine:
    ```
    HOST=new-dotstat-demo.myorganization.org
    ```
- **datasources.json** and **settings.json files** within *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/config/data/prod/configs/* folder.
    The simplest way to do that is to execute the following script from folder *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo* (please replace both **NEW_hostname_or_ip_address_of_your_server** and **OLD_hostname_or_ip_address_of_your_server** with the actual NEW and OLD hostnames/ip addresses of your server):

    ```sh
    $ scripts/replace.server.address.sh config/data/prod/configs/ NEW_hostname_or_ip_address_of_your_server OLD_hostname_or_ip_address_of_your_server
    ```
	
    When the script executed normally you should see no error messages and the following at the end of the log:
	```
	Done. Files updated with the following host address: NEW_hostname_or_ip_address_of_your_server
	```
	
    Example: To replace *old-dotstat-demo.myorganization.org* to *new-dotstat-demo.myorganization.org* in json configuration files execute the following:
    ```sh
    $ scripts/replace.server.address.sh config/data/prod/configs/ new-dotstat-demo.myorganization.org old-dotstat-demo.myorganization.org
    ```
	
    Remember to validate the json configuration files to make sure that the changes made on the configuration files resulted valid json files, see details [here](#check-validity-of-json-configuration-files-optional-but-recommended)

#### Further configuration of Data Explorer and Data Lifecycle Manager

Please see the following links for further information about configuration and customization of DE and DLM.

- [Data Explorer configuration](https://sis-cc.gitlab.io/dotstatsuite-documentation/configurations/de-configuration/)
- [Data Explorer customization](https://sis-cc.gitlab.io/dotstatsuite-documentation/configurations/de-customisation/)
- [Data Lifecycle Management configuration](https://sis-cc.gitlab.io/dotstatsuite-documentation/configurations/dlm-configuration/)

In the default docker-compose installation the configuration files of DE and DLM components are located in *$DOTSTATSUITE-DOCKER-COMPOSE-ROOT/demo/config/data/prod/configs/* folder:
 
```
 ├── configs
 │   ├── datasources.json
 │   ├── tenants.json 
 │   ├── default
 │   │   ├── data-explorer
 │   │   │   ├── settings.json
 │   │   ├── data-lifecycle-manager
 │   │   │   ├── settings.json
 │   │   ├── data-viewer
 │   │   │   ├── settings.json
```

Remember to validate the json configuration files to make sure that the changes made on the configuration files resulted valid json files, see details [here](#check-validity-of-json-configuration-files-optional-but-recommended)

#### Indexing data 

Please find information on when and how to index data at the following link: https://sis-cc.gitlab.io/dotstatsuite-documentation/using-de/searching-data/indexing-data/#when-and-how-to-index

#### How auto-clean you share service DB

**You need to have cURL install on your machine**

- create file (e.g. autoCleanShareService.sh)
- add the following line in the autoCleanShareService.sh file, replace localhost, port and api-key if needed
```bash
curl -X DELETE http://localhost:3005/cleanup/start?api-key=secret
```

##### Windows

- Open task Scheduler
- Create a Task
In Actions, you need to link your autoCleanShareService.sh file.
  - add new action
    - Browse your script autoCleanShareService.share
    - OK
you can configure name and triggers as you wish.

###### Unix

open your crontab editor, 
```bash
crontab -e
```

configure your scheduling task and add the path of your script  
e.g. once a day  
```bash
* * */1 * * /root/path/to/autoCleanShareService.sh 
```

### Summary of TCP ports 

The TCP ports used by default installation of .Stat Suite v8 are as follows:

|Service |Default value
|------------|:-------------:
|Data Lifecycle Management service|7000
|DataExplorer service|7001
|Data Viewer service|7002
|Keycloak service|8080
|Configuration service|5007
|Share service|3005
|Search service|3004
|SolR service|8983
|Redis service|6379
|NSI WS - Design instance|80
|NSI WS - Release instance|81
|Transfer service|93
|Authorization Management service|94
|MS SQL Server|1434
|SMTP server port|587
|Postgress DB|5432
