# InfluxDB README
As configured by Amandi Sevmini Edirisinghe - Sri Lanka Telecom Digital Lab Intern under Mr. Rumesh - July to Sept 2024

## Overview
InfluxDB is a time series database designed to handle high write and query loads. It's particularly well-suited for operations monitoring, application metrics, IoT sensor data, and real-time analytics.

## Docker Configuration
- **Image**: influxdb:2.7.6
- **Container Name**: influxdb
- **Port**: 8086 (mapped to host port 8086)
- **Network**: common_network
- **Restart Policy**: unless-stopped

## Volumes
- `influxdb-data:/var/lib/influxdb2`: This volume stores the InfluxDB data, ensuring persistence across container restarts.
- `shared-data:/shared`: This shared volume can be used for data exchange between services.

## Environment Variables
Environment variables are stored in the `influxdb.env` file. Here's a breakdown of each variable:

1. `DOCKER_INFLUXDB_INIT_MODE=setup`
   - This sets the initialization mode to 'setup', which is used for the initial configuration of InfluxDB.

2. `DOCKER_INFLUXDB_INIT_USERNAME
   - This sets the initial admin username for InfluxDB.

3. `DOCKER_INFLUXDB_INIT_PASSWORD
   - This sets the initial admin password. Should configure docker secrets in future to hide these details 

4. `DOCKER_INFLUXDB_INIT_ORG=IoT Project`
   - This sets the name of the initial organization in InfluxDB.

5. `DOCKER_INFLUXDB_INIT_BUCKET=IoT`
   - This creates an initial bucket named 'IoT' for storing data.

6. `DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=`
   - This sets the admin token for API access. Taken from my actual influxdb account. All access and infinite retention.

7. `DOCKER_INFLUXDB_INIT_RETENTION=0`
   - This sets the retention policy for the initial bucket. A value of 0 means infinite retention.

## Accessing InfluxDB
After starting the Docker container, the InfluxDB API and UI can be accessed at `http://localhost:8086`

## Data Persistence
All data written to InfluxDB is stored in the `influxdb-data` volume, ensuring data persistence even if the container is stopped or removed.

## Interacting with Other Services
InfluxDB is configured to work seamlessly with other services in the stack:
- Grafana can use InfluxDB as a data source for creating dashboards and visualizations.
- Node-RED can write data to InfluxDB for storage and later analysis.

## Security Considerations
- The admin token in the environment file is sensitive information. Ensure that the `influxdb.env` file is not exposed or committed to version control.
- Consider changing the admin password after initial setup.
- Use the admin token for programmatic access to InfluxDB API.
- Regularly rotate the admin token for enhanced security.

## Backup and Restore
To backup InfluxDB data:
1. Use the `influx backup` command inside the container
2. Copy the backup files from the container to the host

To restore:
1. Copy backup files into the container
2. Use the `influx restore` command

## Monitoring
InfluxDB provides built-in monitoring capabilities. You can create a separate bucket for storing InfluxDB's internal metrics.

## Retention Policy
The initial bucket is set up with infinite retention (`DOCKER_INFLUXDB_INIT_RETENTION=0`). Depending on your data volume and storage capacity, you might want to adjust this for production use.

## Customization
To modify InfluxDB configuration beyond what's possible with environment variables, you can mount a custom influxdb.conf file into the container.

## Restarting InfluxDB
The container is configured to restart automatically unless stopped manually (`restart: unless-stopped`).

For more detailed information on using and configuring InfluxDB, refer to the official InfluxDB documentation at https://docs.influxdata.com/