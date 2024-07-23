#!/bin/bash
set -e

# Start InfluxDB in the background
influxd &

# Wait for InfluxDB to be ready
for i in {1..30}; do
  if curl -s http://localhost:8086/health > /dev/null; then
    echo "InfluxDB is ready!"
    break
  fi
  echo "Waiting for InfluxDB to be ready... (attempt $i)"
  sleep 2
done

if [ $i -eq 30 ]; then
  echo "InfluxDB failed to start within 60 seconds"
  exit 1
fi

# Check if config files exist
if [ ! -f "/etc/influxdb/influx-configs" ]; then
  echo "Setting up InfluxDB..."
  
  # Ensure all required variables are set
  if [ -z "${INFLUXDB_USER}" ] || [ -z "${INFLUXDB_PASSWORD}" ] || [ -z "${INFLUXDB_ORG}" ] || [ -z "${INFLUXDB_BUCKET}" ]; then
    echo "Error: INFLUXDB_USER, INFLUXDB_PASSWORD, INFLUXDB_ORG, and INFLUXDB_BUCKET must be set"
    exit 1
  fi

  # Setup initial user, org, and bucket
  influx setup \
    --username "${INFLUXDB_USER}" \
    --password "${INFLUXDB_PASSWORD}" \
    --org "${INFLUXDB_ORG}" \
    --bucket "${INFLUXDB_BUCKET}" \
    --retention 0 \
    --force

  # Generate API token
  API_TOKEN=$(influx auth create \
    --user "${INFLUXDB_USER}" \
    --org "${INFLUXDB_ORG}" \
    --all-access \
    --json | jq -r '.token')

  # Save configs
  echo "INFLUXDB_ORG=${INFLUXDB_ORG}" > /etc/influxdb/influx-configs
  echo "INFLUXDB_BUCKET=${INFLUXDB_BUCKET}" >> /etc/influxdb/influx-configs
  echo "INFLUXDB_TOKEN=${API_TOKEN}" >> /etc/influxdb/influx-configs

  # Export API token to a file that Node-RED can read
  echo "INFLUXDB_TOKEN=${API_TOKEN}" > /shared/influxdb_token.env
else
  echo "InfluxDB configs found, skipping setup..."
  # Load existing configs
  source /etc/influxdb/influx-configs
fi

# Keep the container running
tail -f /dev/null