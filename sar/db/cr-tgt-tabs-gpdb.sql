

-- edit this bit

\set partition_start_date   '''' 2016-05-01 ''''
\set partition_end_date     '''' 2017-01-01 ''''
\set partition_interval     '''' 1 ' ' month ''''
\set target_schema          target


-- dont edit from here down
set search_path=:target_schema;

drop table if exists cpu;
create table cpu (
      cluster    text
    , host       text
    , interval   integer
    , ts         timestamp
    , cpu        numeric
    , usr        numeric
    , nice       numeric
    , system     numeric
    , iowait     numeric
    , steal      numeric
    , idle       numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index cpu_idx1 on cpu using bitmap (ts)
;


drop table if exists buffer;
create table buffer (
      cluster      text
    , host         text
    , interval     integer
    , ts           timestamp
    , tps          numeric
    , rtps         numeric
    , wtps         numeric
    , bread_sec    numeric
    , bwrtn_sec    numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index buffer_idx1 on buffer using bitmap (ts)
;


drop table if exists page;
create table page (
      cluster      text
    , host         text
    , interval     integer
    , ts           timestamp
    , pgpgin_sec   numeric
    , pgpgout_sec  numeric
    , fault_sec    numeric
    , majflt_sec   numeric
    , pgfree_sec   numeric
    , pgscank_sec  numeric
    , pgscand_sec  numeric
    , pgsteal_sec  numeric
    , vmeff_pct    numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index page_idx1 on page using bitmap (ts)
;


drop table if exists disk;
create table disk (
      cluster          text
    , host             text
    , interval         integer
    , ts               timestamp
    , device           text
    , tps              numeric
    , rd_sectors_sec   numeric
    , wr_sectors_sec   numeric
    , avgrq_sz         numeric
    , avgqu_sz         numeric
    , await            numeric
    , svctm            numeric
    , util_pct         numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index disk_idx1 on disk using bitmap (ts)
;


drop table if exists net;
create table net (
      cluster        text
    , host           text
    , interval       integer
    , ts             timestamp
    , iface          text
    , rxpck_sec      numeric
    , txpck_sec      numeric
    , rxKB_sec       numeric
    , txKB_sec       numeric
    , rccmp_sec      numeric
    , txcmp_sec      numeric
    , rxmcst_sec     numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index net_idx1 on net using bitmap (ts)
;


drop table if exists mem;
create table mem (
      cluster        text
    , host           text
    , interval       integer
    , ts             timestamp
    , kbmemfree      text
    , kbmemused      numeric
    , memused_pct    numeric
    , kbbuffers      numeric
    , kbcached       numeric
    , kbcommit       numeric
    , commit_pct     numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index mem_idx1 on mem using bitmap (ts)
;



drop table if exists runq;
create table runq (
      cluster        text
    , host           text
    , interval       integer
    , ts             timestamp
    , runqsz         numeric
    , plistsz        numeric
    , ldavg1m        numeric
    , ldavg5m        numeric
    , ldavg15m       numeric
)
distributed randomly
partition by range (ts) (start (:partition_start_date) end (:partition_end_date) every (interval :partition_interval))
;
create index runq_idx1 on runq using bitmap (ts)
;



