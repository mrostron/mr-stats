
========
CONTENTS
========
- mr-stats/sar/db: 	collection/load scripts (shell/sql)
- mr-stats/sar/charts: 	charting scripts (R)

========
PROCEDURES
========

- build the database
  - cr-tgt-tabs-gpdb.sql:	build the target tables in the database
  - cr-load-tabs-gpdb.sql:	build the load tables in the database

- get the data
  - db/config.sh:		config file for both get-sa.sh and load.sh
  - db/get-sa.sh:		execute as root on the master(standby), will pull the sar files back to master
  - db/load.sh:			once the sar files are copied, read them and load them to a database

- chart the data
  - setup the env:		set PGDATABASE,PGUSER,PGHOST,PGPASSWORD
  - configure charts:		edit global.R, set global variables, chart output dir and size
  - execute charts:
    - charts-cl-avg.R:			area charts which show average resource util across the cluster
    - charts-point-by-host:		xy-scatter plots which display resource util colored by host
    - charts-point-by-kmeans:		xy-scatter plots which display resource util colored by kmeans
    - charts-combo-by-kmeans:		combined xy-scatter plots and histogram, resource util colored by kmeans
    - charts-heatmap-host-by-kmeans:	map of host to kmeans group, read in conjunction with point-by-kmeans or combo-by-kmeans	
  - R dependencies
    - RPostgreSQL (CRAN)
    - ggplot2 (CRAN)

