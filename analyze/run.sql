--
\i cr-pg_log-ext.sql
\i cr-pidstat-ext.sql
--
create temp table pg_log as select * from wm_ad_hoc.pg_log_mr_01;
create temp table pidstat as select * from wm_ad_hoc.pidstat_mr_01;
--
