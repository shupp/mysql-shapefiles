# Overview
This repository allows for the quick wiring up of timezone shapefiles from [timezone-boundary-builder](https://github.com/evansiroky/timezone-boundary-builder) to a MySQL (MariaDB) docker container.

# Getting Started
To get started, you can just run `make build` to build your seed image, and then `make up logs`, like so:

```
$ make up logs
curl -sLO https://github.com/evansiroky/timezone-boundary-builder/releases/download/2020d/timezones-with-oceans.shapefile.zip
--SNIP--
db_1    | 2020-12-29 19:07:41 0 [Note] mysqld: ready for connections.
db_1    | Version: '10.5.8-MariaDB-1:10.5.8+maria~focal'  socket: '/run/mysqld/mysqld.sock'  port: 3306  mariadb.org binary distribution
seed_1  | Waiting for MySQL to be up ... 4
seed_1  | MySQL appears to be up!
seed_1  | Creating tz_world database
seed_1  | Adding shapefiles, this may take a minute or two ...
seed_1  | 0...10...20...30...40...50...60...70...80...90...100 - done.
seed_1  | real	0m 21.02s
seed_1  | user	0m 18.46s
seed_1  | sys	0m 0.68s
seed_1  | Done
```

The above will download the release of the shape files from github, and then start up the database and seed client.  Once it's done, you can start querying the dataset.  To open up the client, do `make shell`, which opens up a shell on the mariadb container.  From here, you can use the `check.sh` script to pass in coordinates as a single argument, `check.sh 'lat,lon'`, using decimal degrees.

For example:

```
$ make shell
docker-compose exec db bash
root@fe19eed3a55d:/# ./check.sh '37.798499, -122.463621'
+---------------------+
| tzid                |
+---------------------+
| America/Los_Angeles |
+---------------------+
```

To shut down and clean up, do:

```
$ make down clean
docker-compose down
Stopping mysql-shapefiles_db_1 ... done
Removing mysql-shapefiles_seed_1 ... done
Removing mysql-shapefiles_db_1   ... done
Removing network mysql-shapefiles_mysql_shapefiles
rm -f timezones-with-oceans.shapefile.zip
```
