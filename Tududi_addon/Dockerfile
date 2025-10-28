ARG BUILD_FROM
FROM $BUILD_FROM

COPY --from=chrisvel/tududi:latest 

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]