# mr-stats
* this repo provides a simple approach to logging & analysis of a GreenplumDB or HAWQ MPP cluster
* background
  * GPDB/HAWQ are implemented MPP clusters, with one master server and multiple segment (slave) servers; a SQL query is issued to the master, which parses it, then sends the parsed execution plan to the segments, where it is processed, and from which the result set, if any, is collected and returned to the user.
  * if the cluster is properly configured and tuned, we expect system load to be equally balanced across all of the segment servers - indicating optimal query execution; if it is not balanced (i.e. skew), then the most heavily loaded server will slow the response time for the particular query, becoming a bottleneck
  * searching for the imbalance can be tedious - this toolkit is aimed at providing a simple method to obtain the necessary information to detect and analyze the skew host, identify the processes, and finally the SQL query being run when the skew occurred
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


