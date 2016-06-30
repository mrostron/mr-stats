#!/bin/bash
#
# pidstat.sh
# this script is a shell wrapper that runs pidstat on a 10-second poll for 24hrs 
# only postgres commands are monitored
# it records output in a weekly rotating output file (pidstat.(day-of-week) )
# parameters (below) determine location of output file and email address
# a log file, pidstat.log, and pid file, pidstat.pid, are created in the output directory
# this script is intended to be run from cron once/day
# eg 02 00 * * * /home/gpadmin/pidstat.sh
# Control
# - pidstat_cron should be edited and copied to /etc/cron.d
# - default is to have this restart once/day and run for 1 day
# Procedure
# - set up parameters
# - check output directory and output file are both writable
# - remove files older than retention ($R)
# - touch output file
# - start pidstat (snaps all postgres pids every 10secs for 24hrs)
# - record status via "logger"
# - record pid in pidfile
# Output
# - default pidstat output is on a weekly rotation
# - expected size of pidstat output is about 10MB/day
# Logging
# - log file output pidstat.log in output directory
# - if a message is generated, output one line/day indicating success/failure to /var/log/messages


#-------------
# set up parameters, customize here
#-------------
D=/data/mr-stats/pidstat/log
TODAY=$(date +%Y%m%d)
T=$(date)
F=${D}/pidstat.${TODAY}     # output file path
L=${D}/pidstat.log          # LOG file path
P=${D}/pidstat.pid          # PID file path
R=3                         # retention
I=10                        # interval
C=8640                      # count of iterations

#-------------
# check output directory exists (D)
#-------------
mkdir -p ${D}
if [ $? -ne 0 ]
then
  M="${T}: pidstat.sh: failure to create directory ${D}"
  echo "${M}"
  logger "${M}"
  exit 1
fi

#-------------
# remove old files
#-------------

find ${D} -mtime +${R} | xargs rm -f

#-------------
# redirect output to logfile (L)
# turn on trace
#-------------
exec 1>${L} 2>&1
set -x

#-------------
# check output file can be created (F)
#-------------
touch ${F}
if [ $? -ne 0 ]
then
  M="${T}: pidstat.sh: failure to touch output file ${F}"
  echo "${M}"
  logger "${M}"
  exit 1
fi

#-------------
# start pidstat on 10 second poll for 8640 polls (1 day)
#-------------
pidstat -C postgres -Iudrhl ${I} ${C} > ${F} &      # uncomment if you only want postgres processes
# pidstat -p ALL -Iudrhl 10 8640 > ${F} &
pid=$!
echo ${pid} > ${P}
if [ $? -ne 0 ]
then
  M="${T}: pidstat.sh: failure to create pid file ${F}"
  echo "${M}"
  logger "${M}"
  exit 1
fi

#-------------
# log start
#-------------
echo "${T}: start pidstat: output:${F}: pid:${pid}"
logger "start pidstat: output:${F}: pid:${pid}"

