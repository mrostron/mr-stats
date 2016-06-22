\echo loading target.cpu
\copy target.cpu from 'cpu.csv' with csv
\echo loading target.mem
\copy target.mem from 'mem.csv' with csv
\echo loading target.net
\copy target.net from 'net.csv' with csv
\echo loading target.disk
\copy target.disk from 'disk.csv' with csv
\echo loading target.buffer
\copy target.buffer from 'buffer.csv' with csv
\echo loading target.page
\copy target.page from 'page.csv' with csv
\echo loading target.runq
\copy target.runq from 'runq.csv' with csv
