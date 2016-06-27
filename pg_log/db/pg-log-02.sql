-- query pg_log for memory-related errors (assumes pg_log has been created by x0.sql)
select curr_ts
     , seg
--     , pid
     , sev
     , state
--     , usename
     , session
     , cmdcnt
     , slice
     , substr(message,1,120) message 
--      , substr(statement,1,40) statement
--      , substr(statement,length(statement)-100,length(statement))
from   pg_log 
where 
       lower(message) not like 'duration:%'
   and lower(message) not like 'statement:%'
   and lower(message) not like 'connection%'
   and lower(message) not like 'disconnection%'
   and lower(message) not like '3rd party error log%'
   and lower(message) not like 'canceling%'
   and usename = 'gpadmin'
   and state != '57M01'
--    and seg != 'seg-1'
   and (
      lower(message) like '%mirror%' 
   or lower(message) like '%connection%' 
   or lower(message) like '%fork%' 
   or lower(message) like '%skew%' 
   or lower(message) like 'threshold%' 
   or lower(message) like '%VMEM%' 
   or lower(message) like '%protect%' 
   or lower(message) like '%retry%' 
   or lower(message) like '%retried%' 
   or lower(message) like '%fts%' 
   or lower(message) like '%recovery%' 
   or lower(message) like '%terminat%' 
   or (message) like '%Broken pipe%'
   or (message) like '%TopMemoryContext%'
   or (message) like '%terminated by signal%'
--   or lower(message) like 'memory%'
--   or lower(message) like 'context%'
--   or sev = 'ERROR'
)
order by 1
;
