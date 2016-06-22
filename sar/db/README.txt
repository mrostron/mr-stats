
INTRO
-----

This directory implements a real simple collect/db-load procedure for sar files.
Main tasks:
- gather sar stats data from a set of hosts
- load the sar data into a postgres or greenplum database

The load.sh script can be configured to run in "full load" or "incremental load" mode (config.sh)

The objective is speed - get the data and load it to a db.
The data is then available for charting and analysis using R.

The gather and load tasks are handled by the get-sa.sh and load.sh scripts.
The tasks are separate to improve security.
They do share the same config.sh file.



FILES
-----

-- shell scripts and supporting sql code called from shell
sar.txt                    : sar man page (cosmetically edited)
config.sh                  : used by load.sh/get-sa.sh
hostfile                   : list of hosts in the cluster
get-sa.sh                  : execute within cluster; pull the sa files from each node in cluster 
load.sh                    : load the captured sa files to a gpdb or pg database
full-ins.sql               : copy load table data to target tables (full copy, used for initial load)
incr-ins.sql               : copy load table data to target tables (incremental copy)
truncate-load.sql          : truncate tables (load only, used for incremental load)
truncate-tgt-and-load.sql  : truncate tables (target and load, used for initial load)

-- db aggregate templates
cr-aggr-tmplt.sql          : template used to create cluster aggregates
ins-aggr-tmplt.sql         : template used to insert cluster aggregates

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
  - run the get-sa.sh and load.sh scripts in a cron
  - store the interim sa results
  - load the sa results to a database
  - all nodes must have sysstat installed
  - must have either root access to all nodes *or* the sa files on all nodes readable
  - must have database access
  - database (either postgres or gpdb) should have dedicated database
  - within database (either postgres or gpdb) must have load and target schemas
- database: postgresql or greenplum
  - store sa results
  - query from R (details elsewhere)



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

This file is sourced by both get-sa.sh and load.sh.
Alternatively, it can be copied/edited and the name of the config file provided as parameter to both scripts.


Contents:

export PGDATABASE=sar
export PGUSER=mrostron
export PGHOST=mdw
TEMPDIR=/var/tmp
CLUSTER=local
SA_BASE=/data/sa                        # base local storage directory
SA_DEST=${SA_BASE}/${CLUSTER}           # cluster-specific local storage directory
SA_SOURCE=/var/log/sa                   # remote sa directory                           (customize)
HOSTFILE=/var/tmp/misc/sa/hostfile      # list of hosts in cluster                      (as in: for n in $(cat $HOSTFILE))
DAYS_HIST=3                             # number of days historical sa files to collect (as in: find -mtime $DAYS_HIST)
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


Pull sar files in a cluster from each node to a master directory on our admin server.

  - collection script:

    - get-sa.sh:     copy all remote sar files from remote node to local store
      usage: get-sa.sh <config.sh>
      configuration is via adjustment to config.sh (or equivalent)

  - copy collection shell scripts to admin node
  - can be run via cron, suggest that the HIST_DAYS be reduced following the initial pull



----
Load
----

- sar file load

    - load.sh  :     load contents of sar files to database
      usage: load.sh <config.sh>
    - determine range of dates and list of hosts (config.sh)
    - for each host/date combination, bunzip the sayyyymmdd.bz2 sar to a temp copy
    - use sadf to extract the cpu,mem,buffer,page,ldavg,net,disk stats and load to a database


