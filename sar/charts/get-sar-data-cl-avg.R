# ---------------------------
# this script queries sar tables averaged over the cluster
# gl-subst.R contains the "where" clause constraints
# ---------------------------
library(RPostgreSQL)
source("global.R")
# ---------------------------
# connect to pg database
# ---------------------------
connect <- function() {
  drv <- dbDriver("PostgreSQL")
  dbConnect(drv)
}

# ---------------------------
# memory
# ---------------------------
get_mem_data <- function(con) {
  sql      <- gl_subst("
select ts
     , avg(kbmemfree)/(1024^2)                    as free
     , avg(kbmemused-kbcached-kbbuffers)/(1024^2) as used
     , avg(kbbuffers)/(1024^2)                    as buff
     , avg(kbcached)/(1024^2)                     as cach
from target.mem 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
group by 1
order by 1
")
  data.frame(dbGetQuery( con, sql ))
}

# ---------------------------
# page
# ---------------------------
get_page_data <- function(con) {
  sql     <- gl_subst("
select 
      ts
    , avg(pgpgin_sec)
    , avg(pgpgout_sec)
    , avg(fault_sec)
    , avg(majflt_sec)
    , avg(pgfree_sec)
    , avg(pgscank_sec)
    , avg(pgscand_sec)
    , avg(pgsteal_sec)
    , avg(vmeff_pct)
from target.page
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
group by 1
order by 1
")
  data.frame(dbGetQuery(con,sql))
}

# ---------------------------
# cpu
# - area-plot of time-cpu%, cluster-avg, segments-only
# ---------------------------
get_cpu_data <- function(con) {
  sql      <- gl_subst("
select ts
     , avg(usr)     as usr
     , avg(nice)    as nice
     , avg(system)  as sys
     , avg(iowait)  as iowait
     , avg(idle)    as idle
from target.cpu
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
group by 1
order by 1
")
  data.frame(dbGetQuery(con,sql))
}

# ---------------------------
# runq
# - xy-plot of plistsz(x)/runq(y)
# ---------------------------
get_runq_data <- function(con) {
  sql      <- gl_subst("
select 
       ts
     , avg(plistsz)  as plistsz
     , avg(runqsz)   as runqsz
     , avg(ldavg1m)  as ldavg1m
     , avg(ldavg5m)  as ldavg5m
     , avg(ldavg15m) as ldavg15m
from target.runq 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
group by 1
order by 1
")
  data.frame(dbGetQuery(con,sql))
}

# ---------------------------
# disk
# ---------------------------
get_disk_data <- function(con) {
  sql      <- gl_subst("
select 
       ts
     , device
     , avg(tps)              as tps
     , avg(rd_sectors_sec)   as rd_sectors_sec
     , avg(wr_sectors_sec)   as wr_sectors_sec
     , avg(avgrq_sz)         as avgrq_sz
     , avg(avgqu_sz)         as avgqu_sz
     , avg(await)            as await
     , avg(svctm)            as svctm
     , avg(util_pct)         as util_pct
from target.disk 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
and ( :disk_incl is null or device like :disk_incl )
and ( :disk_excl is null or device not like :disk_excl )
group by 1,2
order by 1,2
")
  data.frame(dbGetQuery(con,sql))
}

# ---------------------------
# net
# ---------------------------
get_net_data <- function(con) {
  sql      <- gl_subst("
select 
       ts
     , iface
     , avg(rxpck_sec/1000)    as rxpck_sec
     , avg(txpck_sec/1000)    as txpck_sec
     , avg(rxkb_sec)          as rxkb_sec
     , avg(txkb_sec)          as txkb_sec
     , avg(rccmp_sec)         as rccmp_sec
     , avg(txcmp_sec)         as txcmp_sec
     , avg(rxmcst_sec)        as rxmcst_sec
from target.net 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
and ( :net_incl  is null or iface  like :net_incl )
and ( :net_excl  is null or iface  not like :net_excl )
group by 1,2
order by 1,2
")
  data.frame(dbGetQuery(con,sql))
}

# ---------------------------
# disconnect
# ---------------------------
disconnect <- function(con) {
  dbDisconnect(con)
}


