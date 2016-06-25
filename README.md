# mr-stats
* this repo provides a simple approach to logging & analysis of a GreenplumDB or HAWQ MPP cluster
* background
  * GPDB/HAWQ are examples of MPP clusters, with one master server and multiple segment servers; a query is issued to the master, which parses it, and then sends the parsed execution plan to the segments where it is processed.
  * if all is configured properly and tuned, we expect system load to be equally balanced across all the segments servers; if it is not, then the heavily loaded server may slow the response time for the particular query
* how to use this tk
  * identify hot servers
    * collect sar statistics on the master (or the standby) host
    * load them to a repository database (GPDB/HAWQ/PGSQL)
  * identify hot processes
    * setup a pidstat cron-job on all the servers
    * the cron will snap all system processes every 10 seconds
    * collect the pidstat cron output on the master/standby
    * load the pidstat data to a repository database (GPDB/HAWQ/PGSQL)
* description of the code
  * sar
    * collection script (get-sa.sh)
    * load script (load.sh)
    * charting scripts (a number of R scripts)
  * pidstat
    * cron setup
    *
    * collected information is loaded to a postgresql database
    * a number of template sql scripts are provided
  * analysis
    * pidstat and pg_log database load scripts
    * SQL to join the pidstat and pg_log output to determine SQL
    * error detection
* README
  * each directory contains a README with specific instructions


