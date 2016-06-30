--------
OVERVIEW
--------
pidstat is similar to ps, but can be set up to snap every N seconds, and includes per-process utilization over the time interval
this directory contains a set of cron-execution and database load scripts

---------
PROCEDURE
---------

- set up pidstat.sh script:
  - edit config.sh
  - create the pidstat output directory (PIDSTAT_SOURCE)
  - test it

- set up the pidstat.sh in a cron call
  - setup the pidstat_cron file in /etc/cron.d

- give pidstat some time to gather statistics
  - default snapshot frequency is 10secs, so you wont have to wait too long

- set up the database
  - create a database and schemas (load and target)
  - create the pidstat target and load tables

- edit the config.sh 
  - the defaults should work
  - edit your db connection information 

- collect the pidstat files 
  - db/get-pidstat.sh will collect the files from each host back to the master

- load the database
  - db/load.sh





