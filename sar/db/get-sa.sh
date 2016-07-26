#!/bin/bash
# ----------------------
CURRDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG=${1:-${CURRDIR}/config.sh}
[ -f ${CONFIG} ]   || { echo "cant read config file ${CONFIG}"; exit 1; }
echo "executing with config file ${CONFIG}"
source ${CONFIG}
[ -f ${HOSTFILE} ]   || { echo "cant read host file ${HOSTFILE}"; exit 1; }
mkdir -p ${SA_DEST}  || { echo "cant create directory ${SA_DEST}"; exit 1; }
chmod 755 ${SA_DEST} || { echo "cant chown directory ${SA_DEST}"; exit 1; }
trap "echo trapped; kill -9 0" 1 2 3 15


# ----------------------
# get_list_of_files
# - ssh to host, get list of sa files
# - nb ls format:
## /var/tmp> ls -Ggl --time-style="+%Y%m%d"
## total 12
## drwxrwxr-x 4 4096 20160531 misc
## drwxrwxr-x 2 4096 20160531 mrostron
## drwx------ 3 4096 20160511 yum-mrostron-dUqZbM
# - return list of columns 4,5
#   column 4: last-mod-time day: yyyymmdd
#   column 5: full path to file
# ----------------------

function get_list_of_files {
  typeset l_host=${1:?"list_of_files missing param 1 l_host"}
#  ssh ${l_host} "find ${SA_SOURCE} -name sa[0-9][0-9]* -mtime -${DAYS_HIST} | xargs ls -Ggl --time-style='+%Y%m%d' | awk '{print \$4,\$5}'"
ssh ${l_host} "find ${SA_SOURCE} ! -type l -name sa[0-9][0-9]* -mtime -${DAYS_HIST} | xargs ls -Ggl --time-style='+%Y%m%d' | awk '{print \$4,\$5}'"
}



# ----------------------
# main routine
# - for each host in HOSTFILE
#   - setup a local destination directory
#   - get a list of remote sa files from each host
#   - for each sa file:
#     - scp each sa file to local destination directory
#     - compress sa file with bzip2
# to do
#   - implement a retention period
# ----------------------

for l_host in $( cat ${HOSTFILE} )
do
# setup local host-specific destination directory
  l_dest=${SA_DEST}/${l_host}
  mkdir -p ${l_dest} || { echo "cant create directory ${l_dest}; exit 1; }
  chmod -R 755 ${l_dest} || { echo "cant chmod directory ${l_dest}; exit 1; }
# copy from remote host to the local host-specific destination directory
  get_list_of_files ${l_host} |
  while read TIMESTAMP FULLPATH
  do
    typeset f=${l_dest}/sa${TIMESTAMP}
    echo "scp -p ${l_host}:${FULLPATH} ${f}"
    scp -p ${l_host}:${FULLPATH} ${f}
    chmod 644 ${f}
    bzip2 -1 -f ${f}
  done
done



