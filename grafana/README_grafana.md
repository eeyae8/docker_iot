### GRAFANA README
- As configured by Amandi Sevmini Edirisinghe
- Sri Lanka Telecom Digital Lab Intern under Mr. Rumesh
- July to Sept 2024

# Dashboards
- Dashboards can be made in grafana and are saved locally within the container under /var/lib/grafana/dashboards which is then mapped to the volume 'grafana-data' under ./grafana/dashboards . If a container is deleted the dashboards will be saved. If the volume is deleted then it wont be.

## Loading Dashboards locally
- An option to permanently save a dashboard is to save it as a JSON file in the grafana UI online (localhost:3000) and then supply it to the subdirectory 'grafana/local_dashboards'. This is mapped to the container subdirectory /var/lib/grafana/dashboards/local which builds existing JSON files in that directory as a dashboard (located under the 'Local' folder on localhost:3000) even if the volumes are deleted. 


## Understanding Grafana Provisioning

# Dashboard Provisioning:
The dashboards directory in Grafana's provisioning setup is used to automatically load dashboards into Grafana on startup or when the configuration is reloaded.

- Location: Usually found at /etc/grafana/provisioning/dashboards/
- Configuration: Uses YAML files to define dashboard providers
- Dashboard files: Can be stored as JSON files in a specified directory
- Auto-update: Changes to dashboard files can be automatically reflected in Grafana 
    - allowUiUpdates: true sets it so that any changes to the dashboard are saved. To make it read only, change this to allowUiUpdates: false

# Data Source Provisioning:
The datasources directory is used to automatically add, update, or delete data sources in Grafana.

- Location: Typically at /etc/grafana/provisioning/datasources/
- Configuration: Uses YAML files to define data source configurations
- Supported types: Can configure various data source types (e.g., Prometheus, InfluxDB, MySQL)
    - Our case: InfluxDB is preconfigured with organisation, bucket and API token so that any new instance needs only the pasted Query script to be able to pass information from InfluxDB to Grafana instantly and constantly
- Credentials: Allows secure storage of access credentials

## Env File
- GF_SECURITY_ADMIN_USER
    - This sets the admin user's email address for Grafana.

- GF_SECURITY_ADMIN_PASSWORD
    - This sets the admin user's password. The actual password is hidden for security reasons.

- GF_USERS_ALLOW_SIGN_UP=false
    - This disables the ability for new users to sign up. Only admins can create new user accounts. Setting it to true would allow for sign up

- GF_PATHS_DATA=/var/lib/grafana
    - This specifies the path where Grafana will store its database and other data.

- GF_PATHS_LOGS=/var/log/grafana
    - This sets the directory where Grafana will store its log files.

- GF_PATHS_PLUGINS=/var/lib/grafana/plugins
    - This defines the directory where Grafana plugins are stored.

- GF_PATHS_PROVISIONING=/etc/grafana/provisioning
    - This sets the path for Grafana's provisioning directory, where configuration files for automatic resource creation are stored.

- GF_AUTH_API_KEY
    - This is an API key for Grafana. It appears to be a base64 encoded string that likely contains information about the key's permissions and scope.
    - For our case this token does not expire and is all-access for convenience reasons. This can be changed via logging into an actual Grafana account (i used my personal one outside the container)