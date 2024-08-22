### Node-RED README
As configured by Amandi Sevmini Edirisinghe - Sri Lanka Telecom Digital Lab Intern under Mr. Rumesh - July to Sept 2024

## Overview
Node-RED is a flow-based development tool for visual programming developed originally by IBM for wiring together hardware devices, APIs and online services.

## Docker Configuration
- **Base Image**: nodered/node-red:4.0.2-debian
- **Container Name**: node-red
- **Port**: 1880 (mapped to host port 1880)
- **Dependencies**: Depends on influxdb and mosquitto services
- **Network**: common_network

## Dockerfile Explanation
The custom Dockerfile for Node-RED does the following:

1. Uses the official Node-RED 4.0.2 Debian-based image as the base.
2. Switches to the root user for installation processes.
3. Sets the working directory to /data.
4. Copies package.json from the host's node-red/data directory (if it exists).
5. Installs npm packages defined in package.json (if it exists).
6. Copies settings.js, flows.json, and flows_cred.json from the host to the container.
7. Sets the final working directory to /usr/src/node-red.

## Volumes
- `"./node-red/data:/data"`: Maps the local `./node-red/data` directory to `/data` in the container. This is where Node-RED stores its flows, credentials, and settings.

## Node-RED Settings
The `settings.js` file contains important configurations:

1. **Project Feature**: Enabled
   ```javascript
   editorTheme: {
       projects: {
           enabled: true
       }
   }
   ```

2. **Authentication**: 
   - Uses credential-based authentication
   - Default admin username: "admin"
   - Password is hashed (make sure to change this in production)
   ```javascript
   adminAuth: {
       type: "credentials",
       users: [{
           username: "admin",
           password: "$2y$08$gg7TEDs499Z.J/3iWHBcq.5amm0VwzQCfOSuYx1E7oEU8vmCudBp.",
           permissions: "*"
       }]
   }
   ```

3. **HTTP Configuration**:
   - Admin and Node roots are set to '/'
   - Listens on all interfaces (0.0.0.0) to allow connections from Cloudflare Tunnel
   - Port: 1880
   ```javascript
   httpAdminRoot: '/',
   httpNodeRoot: '/',
   uiHost: "0.0.0.0",
   uiPort: 1880,
   ```

4. **CORS and WebSocket**:
   - CORS is configured to allow all origins and methods
   - WebSocket connections are allowed without verification
   ```javascript
   httpNodeCors: {
       origin: "*",
       methods: "GET,PUT,POST,DELETE"
   },
   webSocketNodeVerifyClient: () => true,
   ```

5. **Proxy and HTTPS**:
   - Configured to work behind a reverse proxy (like Cloudflare Tunnel)
   - HTTPS is not required as it's handled by Cloudflare Tunnel
   ```javascript
   requireHttps: false,
   trustProxy: true,
   ```

6. **Logging**:
   - Console logging level set to "info"
   - Metrics and audit logging are disabled
   ```javascript
   logging: {
       console: {
           level: "info",
           metrics: false,
           audit: false
       }
   }
   ```

## Using mkcert for Local SSL/TLS

As an alternative to Cloudflare Tunnels, you can use mkcert to generate locally-trusted development certificates. This is useful for testing HTTPS locally without the need for a reverse proxy.

### Setting up mkcert

1. Install mkcert:
   - On macOS: `brew install mkcert`
   - On Linux: Follow the instructions at https://github.com/FiloSottile/mkcert
   - On Windows: `choco install mkcert`

2. Install the local CA in the system trust store:
   ```
   mkcert -install
   ```

3. Generate a certificate for your Node-RED instance:
   ```
   mkcert localhost 127.0.0.1 ::1
   ```
   This will create two files: `localhost+2.pem` (the certificate) and `localhost+2-key.pem` (the private key).

### THIS IS ALREADY DONE. CHECK THE CERTIFICATES IN THE DIRECTORY, GENERATED AUGUST 2024. 

### Modifying Node-RED Settings

To use the mkcert-generated certificates, modify your `settings.js` file as follows:

```javascript
const fs = require('fs');

module.exports = {
    // ... other settings ...

    https: {
        key: fs.readFileSync('path/to/localhost+2-key.pem'),
        cert: fs.readFileSync('path/to/localhost+2.pem')
    },
    requireHttps: true,
    uiPort: 1880,
    
    // Remove or comment out these lines:
    // httpNodeCors: { ... },
    // webSocketNodeVerifyClient: () => true,
    // trustProxy: true,

    // ... rest of the settings ...
};
```

### Updating Docker Configuration

1. Copy the generated certificate files into your Node-RED data directory.

2. Update your Dockerfile to copy these files into the container:

```dockerfile
# ... previous Dockerfile content ...

COPY node-red/data/localhost+2.pem node-red/data/localhost+2-key.pem ./

# ... rest of Dockerfile ...
```

3. Update your docker-compose.yml to map port 1880 for HTTPS:

```yaml
services:
  node-red:
    # ... other configuration ...
    ports:
      - "1880:1880"
    # ... rest of configuration ...
```
### Security Considerations

- mkcert certificates are only trusted on the machine where they were generated. They are perfect for local development but not suitable for production environments.
- For production, always use certificates from a publicly trusted Certificate Authority.
- Ensure that your certificate files are properly secured and not exposed in version control systems.

By using mkcert, you can test your Node-RED instance with HTTPS enabled locally, which can be useful for development and testing scenarios where you need to simulate a secure environment.

Also a automated script to renew the certificates after 2 years will be required. Cloudflare automates this and is closer to industry standard and is therefore preferred (in my own opinion) for security reasons.

## Accessing Node-RED
After starting the Docker container, Node-RED can be accessed at `http://localhost:1880`

## Flows and Data Persistence
Flows created in Node-RED will be saved in the `./node-red/data` directory on the host. This ensures that your flows and configurations persist even if the container is stopped or removed.

## Security Considerations
- The default admin password should be changed in production environments.
- While CORS is currently allowing all origins, this should be restricted in production.
- The WebSocket verification is currently disabled. Consider implementing proper verification in production.

## Cloudflare Tunnel Integration
The configuration is set up to work seamlessly with Cloudflare Tunnel:
- Listens on all interfaces (0.0.0.0)
- Trusts the proxy (Cloudflare Tunnel)
- HTTPS is not required as it's handled by Cloudflare Tunnel

## Customization
To add custom nodes or further modify the Node-RED configuration, you can edit the `settings.js` file in the `./node-red/data` directory.

## Restarting Node-RED
The container is configured to restart automatically unless stopped manually (`restart: unless-stopped` in docker-compose).

For more detailed information on using and configuring Node-RED, refer to the official Node-RED documentation at https://nodered.org/docs/