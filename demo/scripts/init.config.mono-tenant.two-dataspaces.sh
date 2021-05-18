#!/bin/sh 

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SERVER_ADDRESS=${1:-localhost}

CONFIG_DIR=${2:-$SCRIPT_DIR/../config}
SAMPLE_DIR=${3:-$SCRIPT_DIR/../samples}

echo Configuration of mono tenant installation with 2 dataspaces
echo Server address  : $SERVER_ADDRESS
echo Script directory: $SCRIPT_DIR
echo Config directory: $CONFIG_DIR
echo Sample directory: $SAMPLE_DIR

# Remove prev. version of config folder
rm -rf $CONFIG_DIR

# Get config directory from dotstatsuite-config repository
git clone https://gitlab.com/sis-cc/.stat-suite/dotstatsuite-config.git $CONFIG_DIR -b master;

# Remove tenant folders not needed (prod)
rm -r $CONFIG_DIR/data/prod/configs/default/

# The following are optional to be deleted or may be kept for further reference
rm -r $CONFIG_DIR/data/prod/configs/abs/
rm -r $CONFIG_DIR/data/prod/configs/astat/
rm -r $CONFIG_DIR/data/prod/configs/ins/
rm -r $CONFIG_DIR/data/prod/configs/oecd/
rm -r $CONFIG_DIR/data/prod/configs/statec/
rm -r $CONFIG_DIR/data/prod/configs/statsnz/

# Set the default tenant (using siscc)
mv $CONFIG_DIR/data/prod/configs/siscc/ $CONFIG_DIR/data/prod/configs/default/

# Copy sample configuration files
\cp -f $SAMPLE_DIR/mono-tenant-two-dataspaces/datasources.json $CONFIG_DIR/data/prod/configs/datasources.json
\cp -f $SAMPLE_DIR/mono-tenant-two-dataspaces/tenants.json $CONFIG_DIR/data/prod/configs/tenants.json
\cp -f $SAMPLE_DIR/mono-tenant-two-dataspaces/default/data-explorer/settings.json $CONFIG_DIR/data/prod/configs/default/data-explorer/settings.json
\cp -f $SAMPLE_DIR/mono-tenant-two-dataspaces/default/data-lifecycle-manager/settings.json $CONFIG_DIR/data/prod/configs/default/data-lifecycle-manager/settings.json
\cp -f $SAMPLE_DIR/mono-tenant-two-dataspaces/default/data-viewer/settings.json $CONFIG_DIR/data/prod/configs/default/data-viewer/settings.json

#Replace server address in JS configuration files
$SCRIPT_DIR/replace.server.address.sh $CONFIG_DIR/data/prod/configs/ $SERVER_ADDRESS localhost

echo Mono tenant configuration is done.
