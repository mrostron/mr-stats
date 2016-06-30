

CURRDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PGDATABASE=sar
export PGUSER=mrostron
export PGHOST=mdw

TEMPDIR=/var/tmp
CLUSTER=local
PIDSTAT_BASE=/data/mr-stats/pidstat               # pidstat storage directory (on admin node)
PIDSTAT_DEST=${PIDSTAT_BASE}/${CLUSTER}           # cluster-specific local storage directory (on admin node)
PIDSTAT_SOURCE=${PIDSTAT_BASE}/log                # pidstat storage directory (on local nodes)
PIDSTAT_AWK=/home/gpadmin/mr-stats/pidstat/db/pidstat.awk # pidstat awk filter
HOSTFILE=${CURRDIR}/hostfile                      # list of hosts in cluster                      (as in: for n in $(cat $HOSTFILE))
DAYS_HIST=3                                       # number of days historical sa files to collect (as in: find -mtime $DAYS_HIST)

# ---------
# sql
# ---------
PSQL_OPTS="-eAtq"                                 # psql additional options
#-- initial (full) processing
#INSERT_SQL=${CURRDIR}/full-ins.sql                          # copy data from load.table to target.table
#TRUNCATE_SQL=${CURRDIR}/truncate-tgt-and-load.sql           # truncate load and/or target tables
#-- incremental processing
INSERT_SQL=${CURRDIR}/incr-ins.sql                           # copy data from load.table to target.table
TRUNCATE_SQL=${CURRDIR}/truncate-load.sql                    # truncate load tables only

