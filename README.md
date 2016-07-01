# Introduction
* this repo provides a (hopefully) simple approach to logging & analysis of system load on a GreenplumDB or HAWQ MPP cluster
  * it is a current work in progress and I will update as more components complete

# Contents
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

# Other Ramblings
## Concepts
  * GPDB/HAWQ are MPP clusters (master combined with multiple segment servers)
  * All performance issues on the cluster result from over-utilization of a given resource either (a) across the entire cluster or (b) on a single machine (usually a segment)
  * This tk is intended to provide views of resource utilization for both cases
    * in the case of (a), we provide a set of area charts which illustrate average utilization for the entire cluster
    * in the case of (b), we provide a set of xy-scatter charts which illustrate specific utilization cases, classified using kmeans
  * All the charts use a database of performance data collected and loaded, using the sysstat tk to collect locally and then loading a set of data to a database, from which R charts obtain their data
  * X-AXIS (independent variable)
    * the x-axis for cluster-average area charts is time
    * the x-axis for xy-scatterplot charts is plist ("sar -q" provides count of active processes, which reflects active query requests in GPDB/HAWQ clusters)
  * Y-AXIS (dependent variable)
    * depends on the resource, and scaled to provide a best-fit on the chart - to be honest, R does a pretty good job of y-scaling, so i pretty much let R do it for me

## Uses for this TK
  * in general, this TK is intended to be used to quickly analyze specific system events historically
    * while it may be possible to use this in near-real-time, at the moment, it is best for historical analyses of the period of time 2-5 days prior to now
  * types of investigation for which it is useful
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

