\echo dumping target.cpu
\copy target.cpu to 'cpu.csv' with csv
\echo dumping target.mem
\copy target.mem to 'mem.csv' with csv
\echo dumping target.net
\copy target.net to 'net.csv' with csv
\echo dumping target.disk
\copy target.disk to 'disk.csv' with csv
\echo dumping target.buffer
\copy target.buffer to 'buffer.csv' with csv
\echo dumping target.page
\copy target.page to 'page.csv' with csv
\echo dumping target.runq
\copy target.runq to 'runq.csv' with csv
