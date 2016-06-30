

===========
Contents
===========

README.txt		: this file
config.sql              : configuration file
cr-pg_log-ext.sql	: create pg_log external table, persistent copy of same
drop.sql		: drop pg_log external table, persistent copy of same

pg-log-01.sql		: create a subset (temp table: pg_log) of perstistent pg_log table, within given time-range
pg-log-02.sql		: report errors in temp table pg_log created by pg-log-01.sql



=============
CONFIGURATION
=============

scratch_schema:			schema
scratch_owner:			owner
segment_extl_pg_log_table:	segment external table
master_extl_pg_log_table:	master external table
persistent_pg_log_table:	persistent table
log_file:			log file patterns (pg_log directory)




=========
PROCEDURE
=========

- create external tables
$ psql
psql> \i pg-log-01.sql
psql> \i pg-log-02.sql


