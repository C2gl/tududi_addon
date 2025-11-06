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
RUN git clone --depth 1 --branch v0.86-beta.3 https://github.com/chrisvel/tududi.git /tmp/tududi && \
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

# Copy backup scripts
COPY tududi-backup-pre.sh /usr/bin/tududi-backup-pre.sh
COPY tududi-backup-post.sh /usr/bin/tududi-backup-post.sh
RUN chmod a+x /usr/bin/tududi-backup-pre.sh /usr/bin/tududi-backup-post.sh

# Set permissions
RUN chmod +x /app/backend/cmd/start.sh

WORKDIR /app/backend

CMD [ "/run.sh" ]
