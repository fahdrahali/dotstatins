#!/bin/bash 

##################
# Initialization #
##################
HOST=$1

#determine current OS
CURRENT_OS=$(uname -s)
echo "OS detected: $CURRENT_OS"

if [ -z "$HOST" ]; then 
   #If HOST paramter is not provided, use the default hostname/adderss:

   if [ "$CURRENT_OS" == "Darwin" ]; then
      # Max OS X - not tested!!!
      HOST=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1); 
   elif [ "$(expr substr $CURRENT_OS 1 5)" == "Linux" ]; then
      # Linux - first ip address displayed by ifconfig
      HOST=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1);
   else 
      # Windows with GitBash - host.docker.internal (set by Docker Desktop in hosts file)
      #HOST=$(ipconfig | grep IPv4 | grep Address | sed -E 's/.*IPv4 Address(\. )*: (([0-9]*\.){3}[0-9]*).*/\2/p' | head -1);
      #Docker Desktop adds 'host.docker.internal' entry to hosts file so for local access it can be used instead of first IP address
      HOST=host.docker.internal
   fi
fi

# Display the hostname/ip address that will be applied on configuration files
COLOR='\033[1;32m'
NOCOLOR='\033[0m' # No Color
echo -e "The following host address is being applied on configuration files: $COLOR $HOST $NOCOLOR"

# Remove existing configuration directory (of JavaScript services)
#rm -rf config

# Re-initialize js configuration
#scripts/init.config.mono-tenant.two-dataspaces.sh $HOST

# Apply host value at KEYCLOAK_HOST variable in ENV file
sed -Ei "s#^KEYCLOAK_HOST=.*#KEYCLOAK_HOST=$HOST#g" .env

# Apply host value at HOST variable in ENV file
sed -Ei "s#^HOST=.*#HOST=$HOST#g" .env

#########################
# Start docker services #
#########################

echo "Starting Keycloak services"
docker-compose -f docker-compose-demo-keycloak.yml up -d

echo "Starting .Net services"
docker-compose -f docker-compose-demo-dotnet.yml up -d

echo "Starting JS services"
docker-compose -f docker-compose-demo-js.yml up -d

echo -n "Services being started."

#Wait until keycloak service is started ('Admin console listening' message appears in log')
LOG="$(docker logs keycloak 2>&1 | grep -o 'Admin console listening')"

while [ -z "$LOG" ];
do
   echo -n "."
   sleep 2

   LOG="$(docker logs keycloak 2>&1 | grep -o 'Admin console listening')"
done

echo "."
echo "Switching off HTTPS requirement in Keycloak"
./scripts/disable-ssl.sh

echo "Services started:"

docker ps
