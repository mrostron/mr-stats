
\echo incr-load table: :tab
\set t '''' target. :tab ''''

select 'table-count-before:'||:t||':'||count(*)||':'||max(ts) from target.:tab
;

update load.:tab set ts = date_trunc('min',ts)
;

insert into target.:tab 
select * 
from (
    with x as ( select cluster,host,min(ts) as ts from load.:tab group by 1,2 ),
         y as ( select t.cluster,t.host,max(t.ts) as ts from target.:tab t join x on t.cluster = x.cluster and t.host = x.host and t.ts > x.ts group by 1,2 )
    select l.* from load.:tab l join y on l.cluster = y.cluster and l.host = y.host and l.ts > y.ts
) z
;

select 'table-count-after:'||:t||':'||count(*)||':'||max(ts) from target.:tab
;

