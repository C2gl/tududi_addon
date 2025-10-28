#!/usr/bin/with-contenv bashio
set -euo pipefail

# PORT: default to 3002, but allow override from add-on option
PORT="$(bashio::config 'port' 2>/dev/null || echo 3002)"
export PORT

bashio::log.info "Starting Tududi (PORT=${PORT})"

# Export optional add-on options if set (do not log secrets)
if val="$(bashio::config 'tududi_user_email' 2>/dev/null || true)"; then
	[ -n "$val" ] && export TUDUDI_USER_EMAIL="$val"
fi
if val="$(bashio::config 'tududi_user_password' 2>/dev/null || true)"; then
	[ -n "$val" ] && export TUDUDI_USER_PASSWORD="$val"
fi
if val="$(bashio::config 'tududi_session_secret' 2>/dev/null || true)"; then
	[ -n "$val" ] && export TUDUDI_SESSION_SECRET="$val"
fi

if [ "$(bashio::config 'disable_telegram' 2>/dev/null || echo false)" = "true" ]; then
	export DISABLE_TELEGRAM=true
fi
if [ "$(bashio::config 'disable_scheduler' 2>/dev/null || echo false)" = "true" ]; then
	export DISABLE_SCHEDULER=true
fi

if val="$(bashio::config 'upload_path' 2>/dev/null || true)"; then
	[ -n "$val" ] && export TUDUDI_UPLOAD_PATH="$val"
fi
if val="$(bashio::config 'db_file' 2>/dev/null || true)"; then
	[ -n "$val" ] && export DB_FILE="$val"
fi

# Delegate to upstream entrypoints (prefer official scripts)
if [ -x "/app/scripts/docker-entrypoint.sh" ]; then
	bashio::log.info "Using upstream entrypoint"
	exec "/app/scripts/docker-entrypoint.sh"
fi

if [ -x "/app/backend/cmd/start.sh" ]; then
	bashio::log.info "Using upstream start script"
	exec "/app/backend/cmd/start.sh"
fi

# Backwards-compatible fallbacks
if [ -x "/app/tududi" ]; then
	exec "/app/tududi" --port "${PORT}"
fi

if [ -f "/app/main.py" ]; then
	exec python3 /app/main.py --port "${PORT}"
fi

bashio::log.error "No executable found in /app to start Tududi. Listing /app contents"
ls -la /app || true
exit 1