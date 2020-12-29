FROM alpine:latest

RUN apk add -U gdal-tools mysql-client bash

# This file expects timezones-with-oceans.shapefile.zip to be mounted at
# runtime at /timezones-with-oceans.shapefile.zip

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
