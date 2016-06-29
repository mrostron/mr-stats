
-----------------
CRON INSTALLATION OVERVIEW
-----------------

- the pidstat cron implementation has two steps:
  - unzip the distribution into the gpadmin home dir (creates a directory named mr-stats/pidstat/cron)
  - copy the cron command into /etc/cron.d on all nodes in the cluster

- pull the latest mr-stats zipfile

  - NB:
    -  if you pull the master zipfile from github.com, the file comes down as mr-stats-master.zip
       it will expand to mr-stats-master
       for convenience, you should rename it to mr-stats  i.e. remove the -master suffix
       the rename operation is included below assuming you pulled the master from github

- INSTALLATION: see SETUP notes below: one set for master node, another for segment nodes

- UN-INSTALLATION: see UN-INSTALL notes below


-----------------
OUTPUT
-----------------

- pidstat will run via cron on each host
- it will use /home/gpadmin/mr-stats/pidstat as it's home
- log files are in /home/gpadmin/mr-stats/pidstat/log
  - output of process activity by day-of-week (7-day rotation)
  - pid file of latest process
  - log file containing output from execution each day


-----------------
CRON INSTALLATION ON MASTER (as root):
-----------------

  - as root:
    - drop the zip file to a temp space on the master host:
      ( /var/tmp/mr-stats-master.zip )

  - as root:
    - unzip the zip file to the gpadmin home directory, change ownership to gpadmin, and
    - create a directory for pidstat output, change owner to gpadmin
$   mkdir -p /data/mr-stats/pidstat/log
$   chown -R gpadmin:gpadmin /data/mr-stats/pidstat/log

  - as root:
    - setup the cron ( copy the cron script pidstat_cron to /etc/cron.d )
$   su - root
$   unzip -d /home/gpadmin /var/tmp/mr-stats-master.zip
$   mv /home/gpadmin/mr-stats-master /home/gpadmin/mr-stats
$   rm -f /etc/cron.d/pidstat_cron                                   # remove any old copy
$   cp /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d  # (cron file must be owned by root)
$   cat /etc/cron.d/pidstat_cron
$   chown -R gpadmin:gpadmin /home/gpadmin/mr-stats




-----------------
CRON INSTALLATION ON EACH SEGMENT NODE (as root):
-----------------


  - as root:
    - recursive copy /home/gpadmin/mr-stats from master to the segment nodes
$ for n in {1..N}
> do 
>   echo sdw${n}
>   scp -pr /home/gpadmin/mr-stats sdw${n}:/home/gpadmin
> done


  - as root:
    - create a directory for pidstat output, change owner to gpadmin
    - setup the cron on each node
      nb: pidstat_cron ownership must be root in /etc/cron.d
$   ssh sdw${n} 
$   mkdir -p /data/mr-stats/pidstat/log
$   chown -R gpadmin:gpadmin /data/mr-stats/pidstat/log
$   rm -f /etc/cron.d/pidstat_cron
$   cp /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d
$   chown root:root /etc/cron.d/pidstat_cron
$   ls -l /etc/cron.d/pidstat_cron
$   chown -R gpadmin:gpadmin /home/gpadmin/mr-stats


  - the command to perform the above from the master is (assuming N segment nodes):
$ for n in {1..N}
> do
>   echo sdw${n}
>   ssh sdw${n} "
mkdir -p /data/mr-stats/pidstat/log
chown -R gpadmin:gpadmin /data/mr-stats/pidstat/log
rm -f /etc/cron.d/pidstat_cron
cp /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d
chown root:root /etc/cron.d/pidstat_cron
ls -l /etc/cron.d/pidstat_cron
chown -R gpadmin:gpadmin /home/gpadmin/mr-stats
"
> done






-----------------
CRON UN-INSTALLATION
-----------------
- execute the reverse of the installation.


-----------------
on the master (as root)
-----------------
- execute:
$ su - root
$ rm -f /etc/cron.d/pidstat_cron
$ rm -rf /home/gpadmin/mr-stats



-----------------
on each segment (as root)
-----------------
- execute:
$ su - root
$ rm -f /etc/cron.d/pidstat_cron
$ rm -rf /home/gpadmin/mr-stats


- the shell to do this from the master is (assuming N segment hosts):
$ for n in {1..N}; do echo sdw${n}; ssh sdw${n} "rm -f /etc/cron.d/pidstat_cron; rm -rf /home/gpadmin/mr-stats"; done



