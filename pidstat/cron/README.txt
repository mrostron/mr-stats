

-----------------
CRON INSTALLATION
-----------------

- the pidstat cron implementation is part of the mr-stats script set

- pull the latest mr-stats zipfile

  (NB: if you pull the master zipfile from github.com, the file comes down as mr-stats-master.zip )
  (    it will expand to mr-stats-master                                                          )
  (    for convenience, you should rename it to mr-stats  i.e. remove the -master suffix          )
  (    the rename operation is included below assuming you pulled the master from github          )




-----------------
- setup on master (as root):
-----------------

  - drop the zip file to a temp space on the master host:
    /var/tmp/mr-stats-master.zip

  - unzip the zip file to the gpadmin home directory, change ownership to gpadmin
$   su - root
$   unzip -d /home/gpadmin /var/tmp/mr-stats-master.zip
$   mv /home/gpadmin/mr-stats-master /home/gpadmin/mr-stats
$   chown -R gpadmin:gpadmin /home/gpadmin/mr-stats

  - setup the cron ( copy the cron script pidstat_cron to /etc/cron.d )
$   cp /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d



-----------------
- setup on each segment node is the same as for the master (as root):
-----------------


  - copy mr-stats from master (/home/gpadmin/pidstat) to the segment nodes
$   for n in {1..N}; do echo sdw${n}; scp -pr /home/gpadmin/mr-stats sdw${n}:; done


  - setup the cron on each node
$   ssh sdw${n} 
$   chown -R gpadmin:gpadmin /home/gpadmin/mr-stats
$   cp -p /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d
$   ls -l /etc/cron.d/pidstat_cron


  - the command to perform the above from the master is (assuming N segment nodes):
$   for n in {1..N}; do echo sdw${n}; ssh sdw${n} "chown -R gpadmin:gpadmin /home/gpadmin/mr-stats; cp -p /home/gpadmin/pidstat/cron/pidstat_cron /etc/cron.d; ls -l /etc/cron.d/pidstat_cron";  done


