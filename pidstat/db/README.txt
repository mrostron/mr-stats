
INTRO
-----

This directory implements a real simple collect/db-load procedure for pidstat files.
Main tasks:
- gather pidstat stats data from a set of hosts
- load the pidstat data into a postgres or greenplum database

The load.sh script can be configured to run in "full load" or "incremental load" mode (config.sh)

The objective is speed - get the data and load it to a db.
The data is then available for charting and analysis using R.

The gather and load tasks are handled by the get-pidstat.sh and load.sh scripts.
The tasks are separate to improve security.
They do share the same config.sh file.



FILES
-----

-- shell scripts and supporting sql code called from shell
pidstat.txt                : pidstat man page (cosmetically edited)
config.sh                  : used by load.sh/get-pidstat.sh
hostfile                   : list of hosts in the cluster
get-pidstat.sh                  : execute within cluster; pull the sa files from each node in cluster 
load.sh                    : load the captured sa files to a gpdb or pg database
full-ins.sql               : copy load table data to target tables (full copy, used for initial load)
incr-ins.sql               : copy load table data to target tables (incremental copy)
truncate-load.sql          : truncate tables (load only, used for incremental load)
truncate-tgt-and-load.sql  : truncate tables (target and load, used for initial load)

-- other maintenance
cr-load-tabs-gpdb.sql      : load table creation script   (gpdb format)
cr-load-tabs-pg.sql        : load table creation script   (postgres format)
cr-tgt-tabs-gpdb.sql       : target table creation script (gpdb format)
cr-tgt-tabs-pg.sql         : target table creation script (postgres format)
dr-all-tabs.sql            : drop tables                  (both target and load tables)

dump.sql                   : \copy table to local file    (target tables only)
load.sql                   : \copy table from local file  (target tables only)
trunc.sql                  : truncate all tables          (both target and load tables)
vacuum.sql                 : vacuum/analyze all tables    (target tables only)



Requirements
------------

- admin node within cluster
  - run the get-pidstat.sh and load.sh scripts in a cron
  - store the interim pidstat results (get-pidstat.sh)
  - load the sa results to a database (load.sh)
  - must have database access (to enable load.sh)
  - recommend that database (either postgres or gpdb) should have dedicated database
  - within database (either postgres or gpdb) must have load and target schemas
- database: postgresql or greenplum
  - store pidstat results



Preparation
-----------

- db connection
  - update config.sh: PGUSER, PGHOST, PGDATABASE, PGPASSWORD

- create database and schemas
  - default schemas are:
    - load
    - target

- create tables
  - psql -f cr-tgt-tables.sql
  - psql -f cr-load-tables.sql




Configuration (config.sh)
-------------------------

This file is sourced by both get-pidstat.sh and load.sh.
Alternatively, it can be copied/edited and the name of the config file provided as parameter to both scripts.


Contents:

export PGDATABASE=pidstat
export PGUSER=mrostron
export PGHOST=mdw
TEMPDIR=/var/tmp
CLUSTER=local
SA_BASE=/data/pidstat                   # base local storage directory
SA_DEST=${SA_BASE}/${CLUSTER}           # cluster-specific local storage directory
SA_SOURCE=/var/log/pidstat              # remote pidstat directory                           (customize)
HOSTFILE=${CURRDIR}/hostfile            # list of hosts in cluster                      (as in: for n in $(cat $HOSTFILE))
DAYS_HIST=3                             # number of days historical pidstat files to collect (as in: find -mtime $DAYS_HIST)

# ---------
# sql
# ---------
PSQL_OPTS="-eAtq"                       # psql additional options
#-- initial (full) processing
#INSERT_SQL=full-ins.sql                # copy data from load.table to target.table
#TRUNCATE_SQL=truncate-tgt-and-load.sql # truncate load and/or target tables
#-- incremental processing
INSERT_SQL=incr-ins.sql                 # copy data from load.table to target.table
TRUNCATE_SQL=truncate-load.sql          # truncate load tables only





----------
Collection
----------


Pull pidstat files in a cluster from each node to a master directory on our admin server.

  - collection script:

    - get-pidstat.sh:     copy all remote pidstat files from remote node to local store
      usage: get-pidstat.sh <config.sh>
      configuration is via adjustment to config.sh (or equivalent)

  - copy collection shell scripts to admin node
  - can be run via cron, suggest that the HIST_DAYS be reduced following the initial pull



----
Load
----

- pidstat file load

    - load.sh  :     load contents of pidstat files to database
      usage: load.sh <config.sh>
    - determine range of dates and list of hosts (config.sh)
    - for each host/date combination, bunzip the file pidstatyyyymmdd.bz2 to an unzipped file in TEMPDIR
    - use psql \copy to load the contents into table load.pidstat


