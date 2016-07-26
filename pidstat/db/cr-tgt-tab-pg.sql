
-- edit this bit

\set partition_start_date   '''' 2016-05-01 ''''
\set partition_end_date     '''' 2017-01-01 ''''
\set partition_interval     '''' 1 ' ' month ''''
\set target_schema          target


-- dont edit from here down
set search_path=:target_schema;

DROP TABLE if exists pidstat;

CREATE TABLE pidstat (
    cluster text,
    host  text,
    ts    timestamp,
    epoch integer,
    procpid integer,
    cpu_usr numeric,
    cpu_sys numeric,
    cpu_guest numeric,
    cpu_total numeric,
    cpu_id integer,
    min_flt_per_sec numeric,
    max_flt_per_sec numeric,
    vsz integer,
    rss integer,
    mem_percent numeric,
    kb_rd_per_sec numeric,
    kb_wrt_per_sec numeric,
    kb_ccwr_per_sec numeric,
    command text
)
;

CREATE INDEX pidstat_idx_01 ON pidstat (ts)
;
