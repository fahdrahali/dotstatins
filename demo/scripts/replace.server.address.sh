#!/bin/sh 

echo "Working folder .... : "$1
echo "Replace host to ... : "$2
echo "Replace host from . : "$3
echo "JSON files detected :"
find $1 -type f -name "settings.json"
find $1 -type f -name "datasources.json"

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://sfs-qa-oecd.redpelicans.com/api"|"http://'$3':3004/api"#"http://'$2':3004/api"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://dv-qa-oecd.redpelicans.com"|"http://'$3':7002"#"http://'$2':7002"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://share-qa-oecd.redpelicans.com/api/charts"|"http://'$3':3005/api/charts"#"http://'$2':3005/api/charts"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://share-qa-oecd.redpelicans.com"|"http://'$3':3005"#"http://'$2':3005"#g' {} +

find $1 -type f -name "settings.json" -exec sed -Ei 's#"http://'$3':7001"#"http://'$2':7001"#g' {} +

find $1 -type f -name "datasources.json" -exec sed -Ei 's#"http://'$3:'#"http://'$2:'#g' {} +
find $1 -type f -name "datasources.json" -exec sed -Ei 's#"http://'$3/'#"http://'$2/'#g' {} +

echo "JSON configuration files updated with the following host address: "$2

