ARG BUILD_FROM
FROM $BUILD_FROM

# Install bashio for Home Assistant add-on helpers
RUN apk add --no-cache bash

# Copy the application from the upstream Tududi image
COPY --from=chrisvel/tududi:latest /app /app

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

WORKDIR /app

CMD [ "/run.sh" ]
