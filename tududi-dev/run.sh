#!/usr/bin/with-contenv bashio
set -e

# Enhanced error handling
set -o pipefail  # Catch errors in pipes
# Note: set -u is not used because bashio environment may have unset variables

# Logging functions
log_info() {
    bashio::log.info "$1"
}

log_error() {
    bashio::log.error "$1"
}

log_warning() {
    bashio::log.warning "$1"
}

log_fatal() {
    bashio::log.fatal "$1"
    exit 1
}

log_info "Starting Tududi add-on..."

# Read configuration from options.json
CONFIG_PATH=/data/options.json

# Validate config file exists and is readable
if [ ! -f "$CONFIG_PATH" ]; then
    log_fatal "Configuration file not found at ${CONFIG_PATH}"
fi

if [ ! -r "$CONFIG_PATH" ]; then
    log_fatal "Configuration file at ${CONFIG_PATH} is not readable"
fi

# Validate jq is available
if ! command -v jq &> /dev/null; then
    log_fatal "jq command not found - required for configuration parsing"
fi

# PORT: default to 3002
PORT=$(jq --raw-output '.port // 3002' "$CONFIG_PATH")
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    log_fatal "Invalid port number: ${PORT}. Must be between 1 and 65535"
fi
export PORT
log_info "Tududi will run on port ${PORT}"

# Export optional add-on options if set (do not log secrets)
TUDUDI_USER_EMAIL=$(jq --raw-output '.tududi_user_email // ""' "$CONFIG_PATH")
if [ -n "$TUDUDI_USER_EMAIL" ]; then
    # Basic email validation
    if [[ ! "$TUDUDI_USER_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        log_warning "TUDUDI_USER_EMAIL format appears invalid: ${TUDUDI_USER_EMAIL}"
    fi
    export TUDUDI_USER_EMAIL
    log_info "TUDUDI_USER_EMAIL configured"
fi

TUDUDI_USER_PASSWORD=$(jq --raw-output '.tududi_user_password // ""' "$CONFIG_PATH")
if [ -n "$TUDUDI_USER_PASSWORD" ]; then
    if [ ${#TUDUDI_USER_PASSWORD} -lt 8 ]; then
        log_warning "TUDUDI_USER_PASSWORD is shorter than 8 characters - consider using a stronger password"
    fi
    export TUDUDI_USER_PASSWORD
    log_info "TUDUDI_USER_PASSWORD configured"
fi

TUDUDI_SESSION_SECRET=$(jq --raw-output '.tududi_session_secret // ""' "$CONFIG_PATH")
if [ -n "$TUDUDI_SESSION_SECRET" ]; then
    if [ ${#TUDUDI_SESSION_SECRET} -lt 16 ]; then
        log_warning "TUDUDI_SESSION_SECRET is shorter than 16 characters - security may be compromised"
    fi
    export TUDUDI_SESSION_SECRET
    log_info "TUDUDI_SESSION_SECRET configured"
else
    log_warning "TUDUDI_SESSION_SECRET not set - consider setting for better security"
fi

DISABLE_TELEGRAM=$(jq --raw-output '.disable_telegram // false' "$CONFIG_PATH")
if [ "$DISABLE_TELEGRAM" = "true" ]; then
    export DISABLE_TELEGRAM=true
    log_info "Telegram integration disabled"
fi

DISABLE_SCHEDULER=$(jq --raw-output '.disable_scheduler // false' "$CONFIG_PATH")
if [ "$DISABLE_SCHEDULER" = "true" ]; then
    export DISABLE_SCHEDULER=true
    log_info "Scheduler disabled"
fi

# Use /data for persistent storage (Home Assistant managed)
UPLOAD_PATH=$(jq --raw-output '.upload_path // "/data/uploads"' "$CONFIG_PATH")
export TUDUDI_UPLOAD_PATH="$UPLOAD_PATH"
log_info "Upload path set to ${TUDUDI_UPLOAD_PATH}"

DB_FILE=$(jq --raw-output '.db_file // "/data/production.sqlite3"' "$CONFIG_PATH")
export DB_FILE
log_info "Database file set to ${DB_FILE}"

# Set NODE_ENV to production
export NODE_ENV=production

# Set CORS allowed origins for Home Assistant ingress
# Use wildcard to allow all origins when behind ingress proxy
# Home Assistant's ingress handles the actual security
export TUDUDI_ALLOWED_ORIGINS="*"

# Ensure database and upload directories exist
log_info "Creating necessary directories..."
if ! mkdir -p "$(dirname "$DB_FILE")" "$TUDUDI_UPLOAD_PATH"; then
    log_fatal "Failed to create directories for database or uploads"
fi

# Verify directories are writable
if [ ! -w "$(dirname "$DB_FILE")" ]; then
    log_fatal "Database directory $(dirname "$DB_FILE") is not writable"
fi

if [ ! -w "$TUDUDI_UPLOAD_PATH" ]; then
    log_fatal "Upload directory ${TUDUDI_UPLOAD_PATH} is not writable"
fi

# Check if database needs initialization (file doesn't exist or is empty/corrupt)
if [ ! -f "$DB_FILE" ] || [ ! -s "$DB_FILE" ]; then
    log_info "Initializing new database..."
    cd /app/backend || log_fatal "Failed to change directory to /app/backend"
    
    if [ -f "scripts/db-init.js" ]; then
        if ! node scripts/db-init.js; then
            log_warning "Database initialization script failed - will attempt runtime initialization"
        else
            log_info "Database initialized successfully"
        fi
    else
        log_warning "Database initialization script not found - will attempt runtime initialization"
    fi
fi

# Run database migrations (CRITICAL for proper schema setup)
cd /app/backend || log_fatal "Failed to change directory to /app/backend"
log_info "Running database migrations..."
if command -v npx &> /dev/null; then
    if npx sequelize-cli db:migrate --config config/database.js 2>&1 | tee /tmp/migration.log; then
        log_info "Migrations completed successfully"
    else
        log_warning "Migration failed, but continuing startup (may be expected for new installations)"
        cat /tmp/migration.log || true
    fi
else
    log_warning "npx not found - skipping migrations"
fi

# Delegate to upstream entrypoints (prefer official scripts)
log_info "Looking for Tududi executable..."

if [ -x "/app/scripts/docker-entrypoint.sh" ]; then
    log_info "Using upstream entrypoint: /app/scripts/docker-entrypoint.sh"
    exec /app/scripts/docker-entrypoint.sh
fi

if [ -x "/app/backend/cmd/start.sh" ]; then
    log_info "Using upstream start script: /app/backend/cmd/start.sh"
    exec /app/backend/cmd/start.sh
fi

# Backwards-compatible fallbacks
if [ -x "/app/tududi" ]; then
    log_info "Executing /app/tududi"
    exec /app/tududi --port "${PORT}"
fi

if [ -f "/app/main.py" ]; then
    if ! command -v python3 &> /dev/null; then
        log_fatal "Python3 not found but main.py exists"
    fi
    log_info "Executing Python main.py"
    exec python3 /app/main.py --port "${PORT}"
fi

# If nothing worked, log error and list contents
log_error "No executable found to start Tududi"
log_error "Listing /app contents for debugging:"
ls -la /app || log_error "Failed to list /app directory"

if [ -d "/app/backend" ]; then
    log_error "Listing /app/backend contents:"
    ls -la /app/backend || log_error "Failed to list /app/backend directory"
fi

log_fatal "Failed to start Tududi - no valid executable found"
