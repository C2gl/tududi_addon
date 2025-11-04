ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies - use nodejs-current for ARM64 compatibility
RUN apk add --no-cache \
    bash \
    curl \
    git \
    sqlite \
    jq

# Install Node.js and npm separately to handle ARM64 issues
# Use nodejs-current from edge for ARM64 with matching ICU libraries
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        echo "Installing Node.js for ARM64 from edge repository..."; \
        apk add --no-cache nodejs-current npm icu-libs icu-data-full --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main; \
    else \
        echo "Installing Node.js for AMD64..."; \
        apk add --no-cache nodejs npm; \
    fi

# Set working directory
WORKDIR /app

# Clone Tududi repository (v0.85.1 stable release) and build with retry logic
RUN git clone --depth 1 --branch v0.85.1 https://github.com/chrisvel/tududi.git /tmp/tududi && \
    cd /tmp/tududi && \
    npm config set fetch-retry-maxtimeout 300000 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retries 10 && \
    npm config set progress false && \
    npm config set loglevel error && \
    npm install --no-audit --no-fund --prefer-offline --legacy-peer-deps && \
    npm install nanoid@3 --save --no-audit --no-fund --legacy-peer-deps && \
    sed -i "s|publicPath: '/'|publicPath: ''|g" webpack.config.js && \
    NODE_OPTIONS="--max-old-space-size=2048" NODE_ENV=production npm run frontend:build && \
    sed -i 's|="/|="./|g' dist/index.html && \
    sed -i 's|href="/|href="./|g' dist/index.html && \
    find dist -name "*.js" -type f -exec sed -i 's|"/api/|"./api/|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i "s|'/api/|'./api/|g" {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|`/api/|`./api/|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|"/locales/|"./locales/|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i "s|'/locales/|'./locales/|g" {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|`/locales/|`./locales/|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|loadPath:"/locales/|loadPath:"./locales/|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i "s|loadPath:'/locales/|loadPath:'./locales/|g" {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|navigate("/|navigate("./|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i "s|navigate('/|navigate('./|g" {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|to="/|to="./|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i "s|to='/|to='./|g" {} + && \
    find dist -name "*.js" -type f -exec sed -i 's|href="/|href="./|g' {} + && \
    find dist -name "*.js" -type f -exec sed -i "s|href='/|href='./|g" {} + && \
    mkdir -p /app/backend /app/backend/dist /app/backend/dist/locales /app/node_modules && \
    cp -r backend/* /app/backend/ && \
    cp -r dist/* /app/backend/dist/ && \
    cp public/favicon* /app/backend/dist/ 2>/dev/null || true && \
    cp public/manifest.json /app/backend/dist/ 2>/dev/null || true && \
    cp -r public/locales/* /app/backend/dist/locales/ && \
    cp -r node_modules /app/ && \
    cp package.json /app/ && \
    npm install -g sequelize-cli && \
    cd /app && \
    rm -rf /tmp/tududi

# Create necessary directories
RUN mkdir -p /app/backend/db /app/backend/uploads

# Copy add-on run script
COPY run.sh /
RUN chmod a+x /run.sh

# Copy backup/restore scripts
COPY scripts/ /scripts/
RUN chmod a+x /scripts/*.sh

# Set permissions
RUN chmod +x /app/backend/cmd/start.sh

WORKDIR /app/backend

CMD [ "/run.sh" ]
