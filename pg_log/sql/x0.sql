select  logsession
      , logtime
      , logcmdcount
      , loguser
      , replace(substr(logmessage,1,120),E'\x0a',' ') message
      , logstate
      , logseverity
from pg_log
where logtime between '2014-11-17 13:30' and '2014-11-17 13:40' 
and logseverity in ('ERROR','FATAL','PANIC')
order by logsession,logtime
;
