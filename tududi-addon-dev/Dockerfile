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

# For me if i come back in a while, to update the version, change the branch tag from the upstream repo on line 18
RUN git clone --depth 1 --branch v0.87-beta.2 https://github.com/chrisvel/tududi.git /tmp/tududi && \
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
    # Only basic path fixes needed since v0.87-beta.2 includes upstream path fixes
    sed -i 's|="/|="./|g' dist/index.html && \
    sed -i 's|href="/|href="./|g' dist/index.html && \
    sed -i 's|src="/|src="./|g' dist/index.html && \
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

# Copy backup scripts
COPY tududi-backup-pre.sh /usr/bin/tududi-backup-pre.sh
COPY tududi-backup-post.sh /usr/bin/tududi-backup-post.sh
RUN chmod a+x /usr/bin/tududi-backup-pre.sh /usr/bin/tududi-backup-post.sh

# Set permissions
RUN chmod +x /app/backend/cmd/start.sh

WORKDIR /app/backend

CMD [ "/run.sh" ]
