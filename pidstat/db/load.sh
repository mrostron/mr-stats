#!/bin/bash
# -----------------
CURRDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG=${1:-${CURRDIR}/config.sh}
[ -f ${CONFIG} ] || { echo "cant read config file ${CONFIG}"; exit 1; }
echo "executing with config file ${CONFIG}"
source ${CONFIG}

# -----------------
# get_list_of_files
# - get the most recent files from the local destination
# - from each file:
#   - extract the information for each destination table
#   - load the information to the database
# -----------------
function get_list_of_files {
  find ${PIDSTAT_DEST} -mtime -${DAYS_HIST} -name *.bz2
}


# -----------------
# preprocess
# - truncate the load tables and/or target tables
# - input: TRUNCATE_SQL (config.sh)
# -----------------
function preprocess {
  echo "executing script ${TRUNCATE_SQL}"
  psql ${PSQL_OPTS} -v tab=pidstat -f ${TRUNCATE_SQL}
#   psql ${PSQL_OPTS} -v tab=mem    -f ${TRUNCATE_SQL}
#   psql ${PSQL_OPTS} -v tab=page   -f ${TRUNCATE_SQL}
#   psql ${PSQL_OPTS} -v tab=buffer -f ${TRUNCATE_SQL}
#   psql ${PSQL_OPTS} -v tab=net    -f ${TRUNCATE_SQL}
#   psql ${PSQL_OPTS} -v tab=disk   -f ${TRUNCATE_SQL}
#   psql ${PSQL_OPTS} -v tab=runq   -f ${TRUNCATE_SQL}
}


# -----------------
# postprocess
# - copy data from load table to target table
# - input: INSERT_SQL (config.sh)
# -----------------
function postprocess {
  echo "executing script ${INSERT_SQL}"
  psql ${PSQL_OPTS} -v tab=pidstat -f ${INSERT_SQL}
#   psql ${PSQL_OPTS} -v tab=mem    -f ${INSERT_SQL}
#   psql ${PSQL_OPTS} -v tab=page   -f ${INSERT_SQL}
#   psql ${PSQL_OPTS} -v tab=buffer -f ${INSERT_SQL}
#   psql ${PSQL_OPTS} -v tab=net    -f ${INSERT_SQL}
#   psql ${PSQL_OPTS} -v tab=disk   -f ${INSERT_SQL}
#   psql ${PSQL_OPTS} -v tab=runq   -f ${INSERT_SQL}
}



# -----------------
# load one sar file
# - unzip file to TEMPDIR
# - extract information cpu,mem,queue,buffer,net,disk
# - remove unzipped file
# -----------------

function load {
  typeset l_file=${1:?"process missing parameter 1: file name"}
  echo "loading data from pidstat file ${l_file}"
  typeset l_unzipped_file=${TEMPDIR}/$(basename ${l_file} .bz2)
  typeset l_cluster=${CLUSTER}
  typeset l_host=$( echo $l_file | awk -F/ '{print $(NF-1)}' )
  bunzip2 -c ${l_file} | awk -v "h=${l_host}" -v "c=${l_cluster}" -f ${PIDSTAT_AWK} > ${l_unzipped_file}
##   sadf -dt ${l_unzipped_file} -- -u     | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.cpu    from stdin with delimiter ';'"
##   sadf -dt ${l_unzipped_file} -- -r     | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.mem    from stdin with delimiter ';'"
##   sadf -dt ${l_unzipped_file} -- -B     | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.page   from stdin with delimiter ';'"
##   sadf -dt ${l_unzipped_file} -- -b     | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.buffer from stdin with delimiter ';'"
##   sadf -dt ${l_unzipped_file} -- -n DEV | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.net    from stdin with delimiter ';'"
##   sadf -dt ${l_unzipped_file} -- -d     | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.disk   from stdin with delimiter ';'"
##   sadf -dt ${l_unzipped_file} -- -q     | egrep -v "(LINUX-RESTART|^#)" | sed "s/^/${CLUSTER};/" | psql ${PSQL_OPTS} -c "\\copy load.runq   from stdin with delimiter ';'"
  psql ${PSQL_OPTS} -c "\\copy load.pidstat from '${l_unzipped_file}' with delimiter '~'"
#  rm -f ${l_unzipped_file}
}


# -----------------
# main routine
# -----------------

trap "echo trapped; kill -9 0" 1 2 3 15
# preprocess
get_list_of_files | while read F; do load ${F} ; break ; done
# postprocess

