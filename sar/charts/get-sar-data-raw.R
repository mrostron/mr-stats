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
     , host
     , (kbmemfree)/(1024^2)                    as free
     , (kbmemused-kbcached-kbbuffers)/(1024^2) as used
     , (kbbuffers)/(1024^2)                    as buff
     , (kbcached)/(1024^2)                     as cach
from target.mem 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
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
    , host
    , (pgpgin_sec)
    , (pgpgout_sec)
    , (fault_sec)
    , (majflt_sec)
    , (pgfree_sec)
    , (pgscank_sec)
    , (pgscand_sec)
    , (pgsteal_sec)
    , (vmeff_pct)
from target.page
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
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
     , host
     , (usr)       as usr
     , (nice)      as nice
     , (system)    as sys
     , (iowait)    as iowait
     , (idle)      as idle
     , (100-idle)  as not_idle
from target.cpu
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
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
     , host
     , (plistsz)  as plistsz
     , (runqsz)   as runqsz
     , (ldavg1m)  as ldavg1m
     , (ldavg5m)  as ldavg5m
     , (ldavg15m) as ldavg15m
from target.runq 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
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
     , host
     , device
     , (tps)              as tps
     , (rd_sectors_sec)   as rd_sectors_sec
     , (wr_sectors_sec)   as wr_sectors_sec
     , (avgrq_sz)         as avgrq_sz
     , (avgqu_sz)         as avgqu_sz
     , (await)            as await
     , (svctm)            as svctm
     , (util_pct)         as util_pct
from target.disk 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
and ( :disk_incl is null or device like :disk_incl )
and ( :disk_excl is null or device not like :disk_excl )
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
     , host
     , iface
     , (rxpck_sec/1000)    as rxpck_sec
     , (txpck_sec/1000)    as txpck_sec
     , (rxkb_sec)          as rxkb_sec
     , (txkb_sec)          as txkb_sec
     , (rccmp_sec)         as rccmp_sec
     , (txcmp_sec)         as txcmp_sec
     , (rxmcst_sec)        as rxmcst_sec
from target.net 
where ts between :min_ts and :max_ts 
and ( :host_incl is null or host like :host_incl )
and ( :host_excl is null or host not like :host_excl )
and ( :net_incl  is null or iface  like :net_incl )
and ( :net_excl  is null or iface  not like :net_excl )
")
  data.frame(dbGetQuery(con,sql))
}

# ---------------------------
# disconnect
# ---------------------------
disconnect <- function(con) {
  dbDisconnect(con)
}


