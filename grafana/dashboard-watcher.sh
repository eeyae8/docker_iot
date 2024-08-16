#!/bin/bash

GRAFANA_URL="http://localhost:3000"
API_KEY="${GF_AUTH_API_KEY}"
WATCH_DIR="/var/lib/grafana/dashboards"
EXPORT_DIR="/var/lib/grafana/dashboards"

echo "Starting dashboard-watcher script" >> /var/log/grafana/dashboard-watcher.log
echo "WATCH_DIR: $WATCH_DIR" >> /var/log/grafana/dashboard-watcher.log
echo "EXPORT_DIR: $EXPORT_DIR" >> /var/log/grafana/dashboard-watcher.log

export_dashboard() {
    local uid=$1
    echo "Exporting dashboard with UID: $uid" >> /var/log/grafana/dashboard-watcher.log
    local json=$(curl -s -H "Authorization: Bearer $API_KEY" "${GRAFANA_URL}/api/dashboards/uid/${uid}")
    local title=$(echo $json | jq -r '.dashboard.title')
    echo $json | jq '.dashboard' > "${EXPORT_DIR}/${title// /_}.json"
    echo "Exported dashboard: ${title}" >> /var/log/grafana/dashboard-watcher.log
}

delete_dashboard() {
    local file=$1
    echo "Deleting dashboard file: $file" >> /var/log/grafana/dashboard-watcher.log
    rm -f "${EXPORT_DIR}/$(basename $file)"
    echo "Deleted dashboard: $(basename $file)" >> /var/log/grafana/dashboard-watcher.log
}

echo "Starting inotifywait..." >> /var/log/grafana/dashboard-watcher.log
inotifywait -m -e create,modify,delete,move "${WATCH_DIR}" | while read path action file; do
    echo "Detected $action on file: $file" >> /var/log/grafana/dashboard-watcher.log
    if [[ "${file}" == *.json ]]; then
        case "${action}" in
            CREATE|MODIFY|MOVED_TO)
                uid=$(jq -r '.uid' "${path}${file}")
                export_dashboard "${uid}"
                ;;
            DELETE|MOVED_FROM)
                delete_dashboard "${file}"
                ;;
        esac
    fi
done