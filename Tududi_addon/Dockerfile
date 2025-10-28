ARG BUILD_FROM
FROM $BUILD_FROM

COPY --from=chrisvel/tududi:v0.84.2 /app /app

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]