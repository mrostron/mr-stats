-----------------
CRON INSTALLATION
-----------------

- the pidstat cron implementation is now part of the mr-stats set
- get the zipfile
- drop it to a temp space on the master host:

  /var/tmp/mr-stats.zip

- on master (as root):

  - unzip the zip file to the gpadmin home directory, change ownership to gpadmin
  - setup the cron

$ su - root
$ unzip -d /home/gpadmin /var/tmp/mr-stats.zip
$ chown -R gpadmin:gpadmin /home/gpadmin/mr-stats

  - copy the cron definition to /etc/cron.d

$ cp /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d

  - copy zipfile to the segment nodes

$  for n in {1..N}; do echo sdw${n}; scp /var/tmp/mr-stats.zip sdw${n}:/var/tmp; done


- on each segment node (same as for master):

$  ssh sdw${n} 
$  unzip -d /home/gpadmin /var/tmp/mr-stats.zip
$  chown -R gpadmin:gpadmin /home/gpadmin/mr-stats
$  cp /home/gpadmin/mr-stats/pidstat/cron/pidstat_cron /etc/cron.d
$  ls -l /etc/cron.d/pidstat_cron

- the command to perform the above from the master is (assuming N segment nodes):

$  for n in {1..N}; do echo sdw${n}; ssh sdw${n} "cd /home/gpadmin; unzip -d /home/gpadmin /var/tmp/mr-stats.zip; chown -R /home/gpadmin/mr-stats; cp /home/gpadmin/pidstat/cron/pidstat_cron /etc/cron.d; ls -l /etc/cron.d/pidstat_cron";  done


