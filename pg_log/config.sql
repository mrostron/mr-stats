


-------------------
-- creation of the external tables and persistent copy of pg_log
-------------------

--   :scratch_schema               schema of the external tables and the persi
--   :scratch_owner                owner of the external tables and the persi
--   :segment_extl_pg_log_table    name of the segment external table
--   :master_extl_pg_log_table     name of the master external table
--   :persistent_pg_log_table      name of the final persistent table
--   :log_file                     name of the log file in pg_log

\set scratch_owner              mrostron
\set scratch_schema             ad_hoc
\set segment_extl_pg_log_table  pg_log_mr_segments_01
\set master_extl_pg_log_table   pg_log_mr_master_01
\set persistent_pg_log_table    pg_log_mr_02
-- \set log_file                E '''' gunzip ' ' -c ' '  ${GP_SEG_DATADIR}/pg_log/gpdb-2015-11-*.csv.gz ''''
\set log_file                   E '''' cat ' '  ${GP_SEG_DATADIR}/pg_log/gpdb-2016-01-09*.csv ''''



-------------------
-- creation of the temporary pg_log image
-------------------

-- :min_time                    start timestamp for the range of time of interest
-- :max_time                    end timestamp for the range of time of interest

\set min_time    ''''  2016-01-09 ' ' 08:00:00 '''' '::timestamp'
\set max_time    ''''  2016-01-09 ' ' 18:00:00 '''' '::timestamp'
-- \set max_time current_timestamp



