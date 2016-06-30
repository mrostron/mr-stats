

CURRDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PGDATABASE=sar
export PGUSER=mrostron
export PGHOST=mdw

TEMPDIR=/var/tmp
CLUSTER=local
SA_BASE=/data/mr-stats/sa               # base local storage directory
SA_DEST=${SA_BASE}/${CLUSTER}           # cluster-specific local storage directory
SA_SOURCE=/var/log/sa                   # remote sa directory                           (customize)
HOSTFILE=${CURRDIR}/hostfile                # list of hosts in cluster                      (as in: for n in $(cat $HOSTFILE))
DAYS_HIST=3                             # number of days historical sa files to collect (as in: find -mtime $DAYS_HIST)

# ---------
# sql
# ---------
PSQL_OPTS="-eAtq"                       # psql additional options
#-- initial (full) processing
#INSERT_SQL=full-ins.sql                # copy data from load.table to target.table
#TRUNCATE_SQL=truncate-tgt-and-load.sql # truncate load and/or target tables
#-- incremental processing
INSERT_SQL=incr-ins.sql                 # copy data from load.table to target.table
TRUNCATE_SQL=truncate-load.sql          # truncate load tables only


