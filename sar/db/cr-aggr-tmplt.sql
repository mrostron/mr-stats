

drop table if exists cpu_aggr;
create table cpu_aggr
as
select 
       ':aggr'                            as source
     , null                             as interval
     , strftime('%Y-%m-%d %H:%M:00',ts) as ts
     , null                             as cpu
     , round(:aggr(user),2)               as user
     , round(:aggr(nice),2)               as nice
     , round(:aggr(system),2)             as system
     , round(:aggr(iowait),2)             as iowait
     , round(:aggr(steal),2)              as steal
     , round(:aggr(idle),2)               as idle 
from cpu 
where ts != 'timestamp'
group by 1,2,3
;

drop table if exists buffer_aggr;
create table buffer_aggr
as
select 
       ':aggr'                            as source
     , null                             as interval
     , strftime('%Y-%m-%d %H:%M:00',ts) as ts
     , round(:aggr(tps),2)                as tps
     , round(:aggr(rtps),2)               as rtps
     , round(:aggr(wtps),2)               as wtps
     , round(:aggr(bread_sec),2)          as bread_sec
     , round(:aggr(bwrtn_sec),2)          as bwrtn_sec
from buffer 
where ts != 'timestamp'
group by 1,2,3
;

drop table if exists page_aggr;
create table page_aggr
as
select 
      ':aggr'                             as source
    , null                              as interval
    , strftime('%Y-%m-%d %H:%M:00',ts)  as ts
    , round(:aggr(pgpgin_sec),2)          as pgpgin_sec
    , round(:aggr(pgpgout_sec ),2)        as pgpgout_sec
    , round(:aggr(fault_sec),2)           as fault_sec
    , round(:aggr(majflt_sec),2)          as majflt_sec
    , round(:aggr(pgfree_sec),2)          as pgfree_sec
    , round(:aggr(pgscank_sec),2)         as pgscank_sec
    , round(:aggr(pgscand_sec),2)         as pgscand_sec
    , round(:aggr(pgsteal_sec),2)         as pgsteal_sec
    , round(:aggr(vmeff_pct),2)           as vmeff_pct
from page
where ts != 'timestamp'
group by 1,2,3
;

drop table if exists disk_aggr;
create table disk_aggr
as
select 
      ':aggr'                             as source
    , null                              as interval
    , strftime('%Y-%m-%d %H:%M:00',ts)  as ts
    , device                            as device
    , round(:aggr(tps),2)                 as tps
    , round(:aggr(rd_sectors_sec),2)      as rd_sectors_sec
    , round(:aggr(wr_sectors_sec),2)      as wr_sectors_sec
    , round(:aggr(avgrq_sz),2)            as :aggrrq_sz
    , round(:aggr(avgqu_sz),2)            as :aggrqu_sz
    , round(:aggr(await),2)               as await
    , round(:aggr(svctm),2)               as svctm
    , round(:aggr(util_pct),2)            as util_pct
from disk
where ts != 'timestamp'
group by 1,2,3,4
;

drop table if exists net_aggr;
create table net_aggr
as
select 
      ':aggr'                             as source
    , null                              as interval
    , strftime('%Y-%m-%d %H:%M:00',ts)  as ts
    , iface                             as iface
    , round(:aggr(rxpck_sec),2)           as rxpck_sec
    , round(:aggr(txpck_sec),2)           as txpck_sec
    , round(:aggr(rxKB_sec),2)            as rxKB_sec
    , round(:aggr(txKB_sec),2)            as txKB_sec
    , round(:aggr(rccmp_sec),2)           as rccmp_sec
    , round(:aggr(txcmp_sec),2)           as txcmp_sec
    , round(:aggr(rxmcst_sec),2)          as rxmcst_sec
from net
where ts != 'timestamp'
group by 1,2,3,4
;

drop table if exists mem_aggr;
create table mem_aggr
as
select 
      ':aggr'                             as source
    , null                              as interval
    , strftime('%Y-%m-%d %H:%M:00',ts)  as ts
    , round(:aggr(kbmemfree),2)           as kbmemfree
    , round(:aggr(kbmemused),2)           as kbmemused
    , round(:aggr(memused_pct),2)         as memused_pct
    , round(:aggr(kbbuffers),2)           as kbbuffers
    , round(:aggr(kbcached),2)            as kbcached
    , round(:aggr(kbcommit),2)            as kbcommit
    , round(:aggr(commit_pct),2)          as commit_pct
from mem
where ts != 'timestamp'
group by 1,2,3
;


