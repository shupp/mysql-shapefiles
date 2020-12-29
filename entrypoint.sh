#!/bin/sh

set -e

cd /tmp
unzip /timezones-with-oceans.shapefile.zip

USERNAME=${USERNAME:-root}
PASSWORD=${PASSWORD:-example}
HOST=${HOST:-db}
DATABASE=${DATABASE:-tz_world}

# Wait one minute for mysql to be up
SLEEP=2
MAX=30
COUNT=1

set +e
while [ ${COUNT} -le ${MAX} ]; do
    echo "Waiting for MySQL to be up ... ${COUNT}"
    TEST_RESULT=$(mysql -u ${USERNAME} -p${PASSWORD} -h ${HOST} -e "QUIT" 2>&1)
    TEST_RETURN_CODE=$?
    if [ ${TEST_RETURN_CODE} -eq 0 ]; then
        echo "MySQL appears to be up!"
        break
    fi
    sleep ${SLEEP}
    COUNT=$(($COUNT + 1))
done
if [ ${TEST_RETURN_CODE} -ne 0 ]; then
    echo "Error: unable to connect to MySQL: ${TEST_RESULT}"
    exit ${TEST_RETURN_CODE}
fi
set -e

echo "Creating tz_world database"
mysql -u ${USERNAME} -p${PASSWORD} -h ${HOST} -e "CREATE database ${DATABASE}"

echo "Adding shapefiles, this may take a minute or two ..."
time ogr2ogr -progress -lco engine=MYISAM -f MySQL \
    MySQL:${DATABASE},user=${USERNAME},password=${PASSWORD},host=${HOST} combined-shapefile-with-oceans.shp
echo "Done"
