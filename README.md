# NHTSA vPIC Database

## Description
Docker image for National Highway Traffic Safety Administration's Vehicle Product Information database with Microsoft SQL Server. This image is for development purposes.

## Getting Started
Run `docker build . -t vpic-mssql`

Run `docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourPassword>" -p 1433:1433 -d vpic-mssql`

## Database Versions
Base off of Microsft SQL Server 2022 latest. https://hub.docker.com/r/microsoft/mssql-server.
vPIC database based off of 2024-07 backup.