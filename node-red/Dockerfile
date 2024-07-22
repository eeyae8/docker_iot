FROM nodered/node-red:4.0.2-debian
USER root
WORKDIR /data

# Copy files from the data subdirectory
COPY node-red/data/package.json* ./

# Install dependencies if package.json exists
RUN if [ -f package.json ]; then \
    npm install --unsafe-perm --no-update-notifier --no-fund --only=production; \
fi

# Copy other configuration files
COPY node-red/data/settings.js* node-red/data/flows.json* node-red/data/flows_cred.json* ./

WORKDIR /usr/src/node-red