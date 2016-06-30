
\echo full load table: :tab
update load.:tab set ts = date_trunc('min',to_timestamp(epoch)) + interval '1 min' ;
insert into target.:tab select * from load.:tab ;
\set t '''' target. :tab ''''
select 'table-count:'||:t||':'||count(*)||':'||max(ts) from target.:tab
;
