docker exec keycloak bash -c "cd /opt/jboss/keycloak/bin/ && ./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user \$KEYCLOAK_USER --password \$KEYCLOAK_PASSWORD && ./kcadm.sh update realms/master -s sslRequired=NONE"
echo "HTTPS Required" flag of Keycloak has been turned off.
