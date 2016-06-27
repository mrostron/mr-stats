# Introduction
* this repo provides a (hopefully) simple approach to logging & analysis of system load on a GreenplumDB or HAWQ MPP cluster
  * it is a current work in progress and I will update as more components complete
# Content
  * README
    * each directory contains a README with specific instructions
  * sar
    * db: data collection and db load scripts (shell/sql)
    * charts: charting scripts (R)
  * pidstat
    * cron: local setup
    * db: data collection and db load scripts (shell/sql)
    * charts: charting scripts (R)
  * pg_log
    * db: database load scripts (shell/sql)
    * charts: charting scripts (R)
  * combo-analysis
    * combined charts and analyses across sar/pidstat/pg_log data

# How to Use this TK
  * identify hot servers
    * collect sar statistics on the master (or the standby) host
    * load them to a repository database (GPDB/HAWQ/PGSQL)
    * use the charts to determine skew segment servers
  * identify hot processes
    * setup a pidstat cron-job on all the servers
    * the cron will snap all system processes every 10 seconds
    * collect the pidstat cron output on the master/standby
    * load the pidstat data to a repository database (GPDB/HAWQ/PGSQL)
    * use the charts to determine skew processes
  * identify queries
    * collect pg_log information and load it to the repo database
    * join the pg_log and pidstat tables to determine the SQL being run by the hot processes

# Background
  * GPDB/HAWQ are MPP clusters, with one master server and multiple segment (slave) servers; a SQL query is issued to the master, which parses it, then sends the parsed execution plan to the segments, where it is processed, and from which the result set, if any, is collected and returned to the user.
  * if the cluster is properly configured and tuned, we expect system load to be equally balanced across all of the segment servers - indicating optimal query execution; if it is not balanced (i.e. skew), then the most heavily loaded server will slow the response time for the particular query, becoming a bottleneck
  * searching for the imbalance can be tedious - this toolkit is aimed at providing a simple method to obtain the necessary information to detect and analyze the skew host, identify the processes, and finally the SQL query being run when the skew occurred
