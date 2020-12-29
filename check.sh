#!/bin/sh

SWAP=$(echo $1 | awk -F, '{ print $2 "," $1}')

USERNAME=${USERNAME:-root}
PASSWORD=${PASSWORD:-example}
HOST=${HOST:-db}
DATABASE=${DATABASE:-tz_world}

mysql \
    -u ${USERNAME} \
    -p${PASSWORD} \
    -h ${HOST} \
    -e "SELECT tzid FROM combined_shapefile_with_oceans WHERE ST_Contains(SHAPE, POINT(${SWAP}));" \
    ${DATABASE}
