# IoT Monitoring System

This project sets up a comprehensive IoT monitoring system using Docker, combining InfluxDB for data storage, Grafana for visualization, Node-RED for data processing and automation, and Mosquitto as an MQTT broker.

SEE To-Do.md for tasks to do.

## Table of Contents
1. [Components](#components)
2. [Key Features](#key-features)
3. [Architecture](#architecture)
4. [Setup Instructions](#setup-instructions)
5. [Docker Compose Configuration](#docker-compose-configuration)
6. [Grafana Setup](#grafana-setup)
7. [Customization](#customization)
8. [Troubleshooting](#troubleshooting)
9. [Contributing](#contributing)
10. [License](#license)

## Components

1. **InfluxDB**: Time series database for storing IoT sensor data.
2. **Grafana**: Data visualization and analytics platform.
3. **Node-RED**: Flow-based programming tool for the Internet of Things.
4. **Mosquitto**: Lightweight MQTT broker for pub/sub messaging.

## Key Features

- **Containerized Setup**: All components run in Docker containers, ensuring easy deployment and scalability.
- **Automated Dashboard Provisioning**: Grafana dashboards are automatically created and configured upon startup.
- **Persistent Storage**: Data is preserved between container restarts using Docker volumes.
- **Real-time Data Visualization**: Grafana dashboards update in real-time, displaying the latest data from InfluxDB.
- **Customizable Data Flow**: Node-RED allows for flexible data processing and routing.
- **MQTT Integration**: Mosquitto enables efficient IoT device communication.

## Architecture

[Include a diagram or brief description of how the components interact]

## Setup Instructions

1. Ensure Docker and Docker Compose are installed on your system.
2. Clone this repository: `git clone [repository-url]`
3. Navigate to the project directory: `cd [project-directory]`
4. Create necessary environment files:
   - `influxdb.env`
   - `grafana.env`
   - `mosquitto.env`
5. Run `docker-compose up -d` to start all services.
6. Access the services:
   - Grafana: `http://localhost:3000`
   - Node-RED: `http://localhost:1880`
   - InfluxDB: `http://localhost:8086`

## Docker Compose Configuration

Our `docker-compose.yml` file defines and configures the services for our IoT monitoring stack:

### InfluxDB Service
- Uses InfluxDB version 2.7.6
- Exposes port 8086
- Uses environment variables from `influxdb.env`
- Persists data in `influxdb-data` volume
- Shares data with other services via `shared-data` volume

### Grafana Service
- Uses the latest Grafana image
- Exposes port 3000
- Uses environment variables from `grafana.env`
- Persists data in `grafana-data` volume
- Mounts local `./grafana/provisioning` and `./grafana/dashboards` directories for configuration

### Node-RED Service
- Uses Node-RED version 4.0.2-debian
- Custom build using `node-red/Dockerfile`
- Exposes port 1880
- Depends on InfluxDB and Mosquitto services
- Persists data in `./node-red/data` directory
- Set to UTC+1 timezone

### Mosquitto Service
- Uses Eclipse Mosquitto image
- Custom build using `mosquitto/Dockerfile`
- Exposes ports 1883 (MQTT) and 9001 (WebSocket)
- Persists data in `mosquitto-data` volume
- Mounts local configuration, data, and log directories
- Uses environment variables from `mosquitto.env`

All services use a common network for inter-container communication. The compose file also defines named volumes for data persistence across container restarts.

## Grafana Setup

### Key Features

- **Automated Dashboard Provisioning**: Dashboards are automatically created and loaded on startup.
- **Persistent Storage**: Dashboard configurations and data are preserved between container restarts.
- **InfluxDB Integration**: Pre-configured to connect with the InfluxDB container.
- **Real-time Updates**: Dashboards refresh automatically to show the latest data.

### Dashboard Configuration

The main dashboard (`influxdb_dashboard.json`) is automatically loaded and includes:

- A time series graph displaying "Flow" data from the InfluxDB "IoT" bucket.
- Automatic query generation using Flux query language.
- 5-second auto-refresh for real-time data updates.

### Grafana Dashboard Provisioning

The `dashboard.yml` file in `grafana/provisioning/dashboards/` configures how Grafana loads dashboards:

```yaml
apiVersion: 1
providers:
- name: 'default'
  orgId: 1
  folder: ''
  type: file
  disableDeletion: false
  updateIntervalSeconds: 10
  allowUiUpdates: true
  options:
    path: /etc/grafana/dashboards
    foldersFromFilesStructure: true

## Node-RED Setup

### Key Features

- **Visual Programming**: Create data flows using a browser-based editor.
- **Extensible**: Wide range of nodes available for various protocols and services.
- **InfluxDB Integration**: Pre-configured nodes for writing to and querying InfluxDB.
- **MQTT Support**: Built-in nodes for MQTT publish/subscribe functionality.

### Configuration

Node-RED is configured to:
- Run on port 1880
- Persist flows and configurations in the `./node-red/data` directory
- Connect to InfluxDB and Mosquitto services

### Usage

1. Access the Node-RED editor at `http://localhost:1880`
2. Create flows by dragging nodes from the palette and connecting them
3. Use the InfluxDB nodes to write data to or query from InfluxDB
4. Utilize MQTT nodes to publish/subscribe to topics on the Mosquitto broker

### Customization

- Install additional nodes via the Node-RED UI or by modifying the `node-red/Dockerfile`
- Adjust settings in `./node-red/data/settings.js`

## Mosquitto Setup

### Key Features

- **MQTT Broker**: Facilitates publish/subscribe messaging between IoT devices and applications
- **WebSocket Support**: Enables MQTT over WebSockets for web applications
- **Authentication**: Configurable username/password authentication

### Configuration

Mosquitto is set up to:
- Listen on port 1883 for MQTT connections
- Listen on port 9001 for WebSocket connections
- Use configurations from `./mosquitto/config/mosquitto.conf`
- Store persistent data in `./mosquitto/data`
- Log to `./mosquitto/log`

### Usage

- Devices and applications can connect to the broker at `localhost:1883` (or your server's IP)
- Use WebSocket connections at `ws://localhost:9001` for web-based MQTT clients
- Configure MQTT clients with the appropriate credentials defined in `mosquitto.env`

### Customization

- Modify `./mosquitto/config/mosquitto.conf` for broker settings
- Update `mosquitto.env` to change access credentials
- Add SSL/TLS support by configuring certificates in the Mosquitto configuration

## InfluxDB Setup

### Key Features

- **Time Series Database**: Optimized for time-stamped data storage and retrieval
- **Flux Query Language**: Powerful language for data analysis and processing
- **Retention Policies**: Automated data management and expiration
- **HTTP API**: Easy integration with various data sources and visualization tools

### Configuration

InfluxDB is configured to:
- Run on port 8086
- Use environment variables from `influxdb.env` for initial setup
- Store data in the `influxdb-data` volume

### Usage

1. Access the InfluxDB UI at `http://localhost:8086`
2. Use the provided credentials in `influxdb.env` to log in
3. Create buckets (databases) for your time series data
4. Write data using the HTTP API, client libraries, or via Node-RED
5. Query data using the Flux language in the InfluxDB UI or via API

### Data Model

- Data in InfluxDB is organized into buckets (similar to databases)
- Each data point consists of:
  - Measurement (like a table name)
  - Tags (indexed metadata)
  - Fields (the actual data values)
  - Timestamp

### Customization

- Modify retention policies to control how long data is kept
- Set up continuous queries for automatic data processing
- Configure additional users and access controls in the InfluxDB UI

## Integration Flow

1. **Data Collection**: IoT devices publish data to specific MQTT topics on the Mosquitto broker
2. **Data Processing**: Node-RED subscribes to these MQTT topics, processes the data if needed
3. **Data Storage**: Node-RED writes the processed data to InfluxDB
4. **Visualization**: Grafana queries data from InfluxDB and displays it in dashboards

