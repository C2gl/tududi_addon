#!/usr/bin/with-contenv bashio
set -e

echo "Starting Tududi add-on..."

# Read configuration from options.json
CONFIG_PATH=/data/options.json

# PORT: default to 3002
PORT=$(jq --raw-output '.port // 3002' $CONFIG_PATH)
export PORT
echo "Tududi will run on port ${PORT}"

# Export optional add-on options if set (do not log secrets)
TUDUDI_USER_EMAIL=$(jq --raw-output '.tududi_user_email // ""' $CONFIG_PATH)
if [ -n "$TUDUDI_USER_EMAIL" ]; then
    export TUDUDI_USER_EMAIL
    echo "TUDUDI_USER_EMAIL configured"
fi

TUDUDI_USER_PASSWORD=$(jq --raw-output '.tududi_user_password // ""' $CONFIG_PATH)
if [ -n "$TUDUDI_USER_PASSWORD" ]; then
    export TUDUDI_USER_PASSWORD
    echo "TUDUDI_USER_PASSWORD configured"
fi

TUDUDI_SESSION_SECRET=$(jq --raw-output '.tududi_session_secret // ""' $CONFIG_PATH)
if [ -n "$TUDUDI_SESSION_SECRET" ]; then
    export TUDUDI_SESSION_SECRET
    echo "TUDUDI_SESSION_SECRET configured"
fi

DISABLE_TELEGRAM=$(jq --raw-output '.disable_telegram // false' $CONFIG_PATH)
if [ "$DISABLE_TELEGRAM" = "true" ]; then
    export DISABLE_TELEGRAM=true
    echo "Telegram integration disabled"
fi

DISABLE_SCHEDULER=$(jq --raw-output '.disable_scheduler // false' $CONFIG_PATH)
if [ "$DISABLE_SCHEDULER" = "true" ]; then
    export DISABLE_SCHEDULER=true
    echo "Scheduler disabled"
fi

UPLOAD_PATH=$(jq --raw-output '.upload_path // "/app/backend/uploads"' $CONFIG_PATH)
export TUDUDI_UPLOAD_PATH="$UPLOAD_PATH"
echo "Upload path set to ${TUDUDI_UPLOAD_PATH}"

DB_FILE=$(jq --raw-output '.db_file // "/app/backend/db/production.sqlite3"' $CONFIG_PATH)
export DB_FILE
echo "Database file set to ${DB_FILE}"

# Delegate to upstream entrypoints (prefer official scripts)
if [ -x "/app/scripts/docker-entrypoint.sh" ]; then
    echo "Using upstream entrypoint: /app/scripts/docker-entrypoint.sh"
    exec /app/scripts/docker-entrypoint.sh
fi

if [ -x "/app/backend/cmd/start.sh" ]; then
    echo "Using upstream start script: /app/backend/cmd/start.sh"
    exec /app/backend/cmd/start.sh
fi

# Backwards-compatible fallbacks
if [ -x "/app/tududi" ]; then
    echo "Executing /app/tududi"
    exec /app/tududi --port "${PORT}"
fi

if [ -f "/app/main.py" ]; then
    echo "Executing Python main.py"
    exec python3 /app/main.py --port "${PORT}"
fi

# If nothing worked, log error and list contents
echo "ERROR: No executable found in /app to start Tududi."
echo "Listing /app contents:"
ls -la /app || true
exit 1
