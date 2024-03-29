
echo "Removing runner..."

# Extracting the necessary fields from the config.toml file
CONFIG_FILE="/etc/gitlab-runner/config.toml"
URL=$(awk '/url =/ {print $3}' $CONFIG_FILE | tr -d '"')
TOKEN=$(awk '/token =/ {print $3}' $CONFIG_FILE | tr -d '"')
NAME=$(awk '/name =/ {print $3}' $CONFIG_FILE | tr -d '"')

# Unregister the runner
./entrypoint unregister --name "$NAME" --url "$URL" --token "$TOKEN"
