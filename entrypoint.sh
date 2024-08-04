#!/bin/bash

# replace the password used to build the container with one that is in ENV
/opt/mssql-tools/bin/sqlcmd \
    -l 60 \
    -S localhost -U SA -P "$DEFAULT_MSSQL_SA_PASSWORD" \
    -Q "ALTER LOGIN SA WITH PASSWORD='${MSSQL_SA_PASSWORD}'" &

# start the MSSQL server, $@ is expanded to the CMD from the dockerfile
# effectively ~$: /opt/mssql/bin/permissions_check.sh "/opt/mssql/bin/sqlservr"
/opt/mssql/bin/permissions_check.sh "$@"
