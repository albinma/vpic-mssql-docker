#!/bin/bash

export MSSQL_SA_PASSWORD=$DEFAULT_MSSQL_SA_PASSWORD

# start the MSSQL server with the build password
echo -e "$(date +%F\ %T.%N) \t Starting SQL Server..."
(/opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "SQL Server is now ready for client connections" && sleep 30

echo -e "$(date +%F\ %T.%N) \t Creating database..."

restore_database() {
    for restoreFile in /var/opt/mssql/backups/*.bak
    do
        echo -e "$(date +%F\ %T.%N) \t Restoring $restoreFile..."
        (/opt/mssql-tools18/bin/sqlcmd -S localhost -C -U sa -P $MSSQL_SA_PASSWORD -Q "IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'vPICList_Lite1') BEGIN CREATE DATABASE [vPICList_Lite1] RESTORE DATABASE [vPICList_Lite1] FROM DISK = N'$restoreFile' WITH FILE = 1, MOVE N'vPICList_Lite1' TO N'/var/opt/mssql/data/vPICList_Lite1.mdf', MOVE N'vPICList_Lite1_log' TO N'/var/opt/mssql/data/vPICList_Lite1_log.ldf', NOUNLOAD, REPLACE, STATS = 5 END" & ) | grep -q "RESTORE DATABASE successfully" && sleep 2
        rm -rf $restoreFile
    done
}

# restore the files to the db
restore_database || (sleep 5 && restore_database)