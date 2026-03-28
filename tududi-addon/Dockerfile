ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies
RUN apk add --no-cache \
    bash \
    nodejs \
    npm \
    sqlite \
    curl \
    git

# Set working directory
WORKDIR /app

# To update the version, change the branch tag on the git clone line below
RUN git clone --depth 1 --branch v1.0.0 https://github.com/chrisvel/tududi.git /tmp/tududi && \
    cd /tmp/tududi && \
    npm config set fetch-retry-maxtimeout 300000 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retries 10 && \
    npm config set progress false && \
    npm config set loglevel error && \
    npm install --no-audit --no-fund --legacy-peer-deps && \
    npm install nanoid@3 --save --no-audit --no-fund --legacy-peer-deps && \
    npm install i18next --save --no-audit --no-fund --legacy-peer-deps && \
    NODE_OPTIONS="--max-old-space-size=2048" NODE_ENV=production npm run frontend:build && \
    # Upstream webpack publicPath is already '' (relative), and index.html has
    # a dynamic <base> tag that detects HA ingress. No index.html sed needed.
    #
    # TODO: Remove this sed workaround once the addon bumps to a tududi version
    # that includes PR #946 (https://github.com/chrisvel/tududi/pull/946).
    # The fix is merged to main but not yet in a release. It makes Navbar.tsx
    # and Login.tsx use getAssetPath() for logo paths instead of hardcoded
    # absolute paths.
    find dist -name "*.js" -type f -exec sed -i \
        -e 's|"/wide-logo-light.png"|"./wide-logo-light.png"|g' \
        -e "s|'/wide-logo-light.png'|'./wide-logo-light.png'|g" \
        -e 's|"/wide-logo-dark.png"|"./wide-logo-dark.png"|g' \
        -e "s|'/wide-logo-dark.png'|'./wide-logo-dark.png'|g" {} + && \
    mkdir -p /app/backend /app/backend/dist /app/backend/dist/locales /app/node_modules && \
    cp -r backend/* /app/backend/ && \
    cp -r dist/* /app/backend/dist/ && \
    cp public/favicon* /app/backend/dist/ 2>/dev/null || echo "No favicon files found" && \
    cp public/manifest.json /app/backend/dist/ 2>/dev/null || echo "No manifest.json found" && \
    cp public/*.png /app/backend/dist/ 2>/dev/null || echo "No PNG files found in public/" && \
    if [ -d "public/locales" ]; then cp -r public/locales/* /app/backend/dist/locales/; else echo "No locales directory found"; fi && \
    cp -r node_modules /app/ && \
    cp package.json /app/ && \
    npm install -g sequelize-cli && \
    cd /app && \
    rm -rf /tmp/tududi

# Create necessary directories
RUN mkdir -p /app/backend/db /app/backend/uploads /app/backend/public /app/backend/locales

# Copy add-on run script
COPY run.sh /
RUN chmod a+x /run.sh

# Set permissions
RUN chmod +x /app/backend/cmd/start.sh

WORKDIR /app/backend

CMD [ "/run.sh" ]
