# mr-stats
* this repo provides a simple approach to logging & analysis of a GreenplumDB or HAWQ MPP cluster
* included:
  * collection
    * linux system stats data (sar)
    * process-centric information (pidstat)
    * database-session-centric information (pg_log)
  * analysis
    * collected information is loaded to a postgresql database
    * a number of template sql scripts are provided
* code
  * all of the code is shell/sql scripts, no compilation required, no web setup
* instructions
  * each directory contains a README with specific instructions


