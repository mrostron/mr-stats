
Description
===========

This directory contains code used to debug incidents occuring on 2014-11-17.
Contents are:
- code to load pg_log and pidstat
- analysis sql queries




Procedure
=========

-------
LOAD
-------
- pidstat
  - awk -f pidstat.awk > /var/tmp/pidstat.txt
  - edit cr-pidstat-ext.sql and point at the correct pidstat file
    this will create an external table pointing at the pidstat file
- pg_log
  - edit cr-pg_log-ext.sql and point at the correct pg_log file
    this will create an external table pointing at the pg_log file
- cr temp tables for analysis
$ psql
psql> create temp table pg_log as select * from wm_ad_hoc.pg_log_mr_01;
psql> create temp table pidstat as select * from wm_ad_hoc.pidstat_mr_01;



-------
ANALYZE
-------

- scripts

  x0.sql: query pg_log where logseverity in (FATAL/PANIC/ERROR)
  x1.sql: query pidstat between 13:00 and 14:00
  x2.sql: query pidstat between 13:00 and 14:00, summarize by minute

- use for spreadsheet

  *x3.sql: query pidstat 13:00-14:00, join to pg_roles,pg_resqueue
  *x4.sql: query pg_log 13:00-14:00,join to pg_roles,pg_resqueue

- spreadsheet import

  x3.sql: import to s/s and create pivot chart
  x4.sql: import to s/s directly


