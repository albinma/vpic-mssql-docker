# Description: Dockerfile to create a SQL Server container with the vPIC database restored

# Download and unzip the database backup
FROM alpine:latest AS unzipper
USER root

# Set the build environment variables
ENV VPIC_BACKUP_ZIP_FILE_NAME=vPICList_lite_2025_02

# Install the necessary tools
RUN apk add --no-cache unzip curl

# Create a directory for the downloads
RUN mkdir /usr/download

WORKDIR /usr/download

# Download the database backup
RUN curl -o "$VPIC_BACKUP_ZIP_FILE_NAME.bak.zip" "https://vpic.nhtsa.dot.gov/api/$VPIC_BACKUP_ZIP_FILE_NAME.bak.zip"
RUN unzip "$VPIC_BACKUP_ZIP_FILE_NAME.bak.zip"
RUN rm  "$VPIC_BACKUP_ZIP_FILE_NAME.bak.zip"

# Create the SQL Server container
FROM mcr.microsoft.com/mssql/server:2022-latest
USER root

# Set the build environment variables
ENV DEFAULT_MSSQL_SA_PASSWORD=myStrongDefaultPassword123$
ENV ACCEPT_EULA=Y

# Create a directory for the backups
RUN mkdir /var/opt/mssql/backups

# Copy the database backup to the container
COPY --from=unzipper "/usr/download/*.bak" "/var/opt/mssql/backups/vpic.bak"
COPY restore.sh entrypoint.sh /opt/mssql/bin/

# Grant permissions for the restore script and entrypoint
RUN chmod +x /opt/mssql/bin/restore.sh /opt/mssql/bin/entrypoint.sh
RUN chown -R mssql:root /var/opt/mssql/backups
RUN chmod 0755 /var/opt/mssql/backups

USER mssql

# Restore backup
RUN /opt/mssql/bin/restore.sh

# Start the SQL Server
CMD [ "/opt/mssql/bin/sqlservr" ]
ENTRYPOINT [ "/opt/mssql/bin/entrypoint.sh" ]




