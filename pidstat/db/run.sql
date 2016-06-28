

------------------------
-- edit here
------------------------

\set load_schema load
\set target_schema target


create temp table pg_log as select * from :load_schema.pidstat_ext;

