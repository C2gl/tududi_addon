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
    npm install nanoid@3 --save --no-audit --no-fund && \
    sed -i "s|publicPath: '/'|publicPath: ''|g" webpack.config.js && \
    NODE_ENV=production npm run frontend:build && \
    sed -i 's|="/|="./|g' dist/index.html && \
    sed -i 's|href="/|href="./|g' dist/index.html && \
    find dist -name "*.js" -type f -exec sed -i 's|"/api/|"./api/|g' {} \; && \
    find dist -name "*.js" -type f -exec sed -i "s|'/api/|'./api/|g" {} \; && \
    find dist -name "*.js" -type f -exec sed -i 's|"/locales/|"./locales/|g' {} \; && \
    find dist -name "*.js" -type f -exec sed -i "s|'/locales/|'./locales/|g" {} \; && \
    find dist -name "*.js" -type f -exec sed -i 's|loadPath:"/locales/|loadPath:"./locales/|g' {} \; && \
    find dist -name "*.js" -type f -exec sed -i "s|loadPath:'/locales/|loadPath:'./locales/|g" {} \; && \
    mkdir -p /app/backend /app/backend/dist /app/node_modules && \
    cp -r backend/* /app/backend/ && \
    cp -r dist/* /app/backend/dist/ && \
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
