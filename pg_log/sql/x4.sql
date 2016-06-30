select  l.logtime::timestamp as ts
      , l.loguser as user
      , q.rsqname as rsqname
      , l.logpid as pid
      , l.logsession as session
      , l.logcmdcount as cmdcnt
      , l.logstate as state
      , l.logseverity as sev
--      , replace(substr(l.logmessage,1,140),E'\x0a',' ') message
      , replace(l.logmessage,E'\x0a',' ') message
from    pg_log  l
left join pg_roles r on l.loguser = r.rolname
left join pg_resqueue q on q.oid = r.rolresqueue
where   logtime between '2014-11-17 13:15:00' and '2014-11-17 13:40:00'
-- and l.logsession = 'con734113'
-- and     logmessage like '%pg_terminate_backend%'
order by 1;
