#!/bin/sh

# treat undefined variables as an error, and exit script immediately on error
set -eux
HEALTH_CHECK_URL="$1" 
MAX_WAIT_SECONDS="$2"

# hit the status endpoint (don't kill script on failure)
set +e

result= 

while [ "$result" != "200" ]
do
	sleep 1.0
	result=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_CHECK_URL)
	
	MAX_WAIT_SECONDS=$((MAX_WAIT_SECONDS-1))

	if [ $MAX_WAIT_SECONDS -le 0 ]; then
        echo "Docker smoke test failed"
        exit -1
    fi
done

# Reenable exit on error  
set -e

if [ $result -eq 200 ]; then
   exit 0
else
   exit 1
fi
