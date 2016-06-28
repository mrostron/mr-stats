
\echo full load table: :tab
update load.:tab set ts = date_trunc('min',ts) ;
insert into target.:tab select * from load.:tab ;
\set t '''' target. :tab ''''
select 'table-count:'||:t||':'||count(*)||':'||max(ts) from target.:tab
;
