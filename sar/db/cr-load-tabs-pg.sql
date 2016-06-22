
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
create table cpu (like :target_schema.cpu)  ;
drop table if exists buffer;
create table buffer (like :target_schema.buffer)  ;
drop table if exists page;
create table page (like :target_schema.page)  ;
drop table if exists disk;
create table disk (like :target_schema.disk)  ;
drop table if exists net;
create table net (like :target_schema.net)  ;
drop table if exists mem;
create table mem (like :target_schema.mem)  ;
drop table if exists runq;
create table runq (like :target_schema.runq)  ;


