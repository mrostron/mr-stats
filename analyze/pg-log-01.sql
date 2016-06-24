

--------
-- NOTES
--------
-- assumption: (1) existance of external table reading pg_log with compatible date to min_time/max_time
--             (2) the external table has been read and the contents saved in permanent file wm_ad_hoc.pg_log_mr_02
-- procedure:
-- - scan wm_ad_hoc.pg_log_mr_02, calculate current timestamp, next timestamp, previous timestamp
-- - filter by ( message like 'duration:%' )
-- - remove ctl-chars from logdebug

\i config.sql

drop table if exists pg_log;
create temp table pg_log 
with (appendonly=true,compresstype=quicklz) --,orientation=column)
as
select      l.logtime::timestamptz as curr_ts
--          , lag(l.logtime::timestamptz) over (partition by l.logsession order by l.logtime) as prev_ts
--          , lead(l.logtime::timestamptz) over (partition by l.logsession order by l.logtime) as next_ts
          , l.logsegment as seg
          , l.logpid as pid
          , l.loguser as usename
--          , q.rsqname as rsqname
          , l.logsession as session
          , l.logcmdcount as cmdcnt
          , l.logslice as slice
          , l.logstate as state
          , l.logseverity as sev
--          , regexp_replace(l.logmessage,'[^0-9.]*','','g') as duration
          , replace(replace(replace(l.logmessage,E'\x0a',' '),E'\x0d',' '),E'\x09',' ')   message
          , replace(replace(replace(l.logdebug,E'\x0a',' '),E'\x0d',' '),E'\x09',' ')   statement
--          , l.logdebug as statement
from     :scratch_schema.:persistent_pg_log_table l
-- left join pg_roles r on l.loguser = r.rolname
-- left join pg_resqueue q on q.oid = r.rolresqueue
where     l.logtime between :min_time and :max_time
-- where     l.logtime > :min_time
-- and       l.loguser in ( 'dba_mwrostr', 'mwrostr' )
-- and       lower(loguser) = 'mwrostr'
-- and       l.logmessage like 'duration:%'
-- where     l.logsession = 'con2395651'
order by 1
distributed randomly;

