
------------------------
-- edit here
------------------------

\set load_schema load
\set target_schema target

------------------------
-- dont edit past here
------------------------

set search_path=:load_schema ;
drop table if exists cpu;
create table cpu (like :target_schema.cpu) distributed randomly ;
drop table if exists buffer;
create table buffer (like :target_schema.buffer) distributed randomly ;
drop table if exists page;
create table page (like :target_schema.page) distributed randomly ;
drop table if exists disk;
create table disk (like :target_schema.disk) distributed randomly ;
drop table if exists net;
create table net (like :target_schema.net) distributed randomly ;
drop table if exists mem;
create table mem (like :target_schema.mem) distributed randomly ;
drop table if exists runq;
create table runq (like :target_schema.runq) distributed randomly ;


