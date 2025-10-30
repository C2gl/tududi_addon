#!/usr/bin/env bashio
set -e

bashio::log.info "Starting Tududi add-on..."

# PORT: default to 3002, but allow override from add-on option
PORT=$(bashio::config 'port')
export PORT

bashio::log.info "Tududi will run on port ${PORT}"

# Export optional add-on options if set (do not log secrets)
if bashio::config.has_value 'tududi_user_email'; then
    export TUDUDI_USER_EMAIL=$(bashio::config 'tududi_user_email')
    bashio::log.info "TUDUDI_USER_EMAIL configured"
fi

if bashio::config.has_value 'tududi_user_password'; then
    export TUDUDI_USER_PASSWORD=$(bashio::config 'tududi_user_password')
    bashio::log.info "TUDUDI_USER_PASSWORD configured"
fi

if bashio::config.has_value 'tududi_session_secret'; then
    export TUDUDI_SESSION_SECRET=$(bashio::config 'tududi_session_secret')
    bashio::log.info "TUDUDI_SESSION_SECRET configured"
fi

if bashio::config.true 'disable_telegram'; then
    export DISABLE_TELEGRAM=true
    bashio::log.info "Telegram integration disabled"
fi

if bashio::config.true 'disable_scheduler'; then
    export DISABLE_SCHEDULER=true
    bashio::log.info "Scheduler disabled"
fi

if bashio::config.has_value 'upload_path'; then
    export TUDUDI_UPLOAD_PATH=$(bashio::config 'upload_path')
    bashio::log.info "Upload path set to ${TUDUDI_UPLOAD_PATH}"
fi

if bashio::config.has_value 'db_file'; then
    export DB_FILE=$(bashio::config 'db_file')
    bashio::log.info "Database file set to ${DB_FILE}"
fi

# Delegate to upstream entrypoints (prefer official scripts)
if [ -x "/app/scripts/docker-entrypoint.sh" ]; then
    bashio::log.info "Using upstream entrypoint: /app/scripts/docker-entrypoint.sh"
    exec /app/scripts/docker-entrypoint.sh
fi

if [ -x "/app/backend/cmd/start.sh" ]; then
    bashio::log.info "Using upstream start script: /app/backend/cmd/start.sh"
    exec /app/backend/cmd/start.sh
fi

# Backwards-compatible fallbacks
if [ -x "/app/tududi" ]; then
    bashio::log.info "Executing /app/tududi"
    exec /app/tududi --port "${PORT}"
fi

if [ -f "/app/main.py" ]; then
    bashio::log.info "Executing Python main.py"
    exec python3 /app/main.py --port "${PORT}"
fi

# If nothing worked, log error and list contents
bashio::log.error "No executable found in /app to start Tududi."
bashio::log.error "Listing /app contents:"
ls -la /app || true
exit 1
