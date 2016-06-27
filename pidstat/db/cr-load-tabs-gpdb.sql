
------------------------
-- edit here
------------------------

\set load_schema load
\set target_schema target

------------------------
-- dont edit past here
------------------------

set search_path=:load_schema ;
drop table if exists pidstat;
create table pidstat(like :target_schema.pidstat) distributed randomly ;


