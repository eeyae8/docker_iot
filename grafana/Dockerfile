FROM grafana/grafana:latest

USER root

# Install inotify-tools and other necessary packages
RUN apt-get update && apt-get install -y inotify-tools jq curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the dashboard-watcher script into the container
COPY dashboard-watcher.sh /dashboard-watcher.sh

# Make sure the script is executable
RUN chmod +x /dashboard-watcher.sh

USER grafana

# Modify the entrypoint to run both Grafana and the dashboard-watcher
ENTRYPOINT ["/bin/sh", "-c", "/run.sh & /dashboard-watcher.sh & wait -n"]