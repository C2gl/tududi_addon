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

# Clone Tududi repository and build with retry logic
RUN git clone --depth 1 https://github.com/chrisvel/tududi.git /tmp/tududi && \
    cd /tmp/tududi && \
    npm config set fetch-retry-maxtimeout 120000 && \
    npm config set fetch-retry-mintimeout 10000 && \
    npm config set fetch-retries 5 && \
    npm install --no-audit --no-fund --prefer-offline && \
    NODE_ENV=production npm run frontend:build && \
    mkdir -p /app/backend /app/dist /app/node_modules && \
    cp -r backend/* /app/backend/ && \
    cp -r dist/* /app/dist/ && \
    cp -r node_modules /app/ && \
    cp package.json /app/ && \
    cd /app && \
    rm -rf /tmp/tududi

# Create necessary directories
RUN mkdir -p /app/backend/db /app/backend/uploads

# Copy add-on run script
COPY run.sh /
RUN chmod a+x /run.sh

# Set permissions
RUN chmod +x /app/backend/cmd/start.sh

WORKDIR /app/backend

CMD [ "/run.sh" ]
