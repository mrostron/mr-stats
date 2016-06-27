

DROP EXTERNAL TABLE wm_ad_hoc.pidstat_mr_01;

CREATE EXTERNAL WEB TABLE wm_ad_hoc.pidstat_mr_01 (
    epoch integer,
    procpid integer,
    cpu_usr numeric,
    cpu_sys numeric,
    cpu_guest numeric,
    cpu_total numeric,
    cpu_id integer,
    min_flt_per_sec numeric,
    max_flt_per_sec numeric,
    vsz integer,
    rss integer,
    mem_percent numeric,
    kb_rd_per_sec numeric,
    kb_wrt_per_sec numeric,
    kb_ccwr_per_sec numeric,
    command text
) EXECUTE E'cat /var/tmp/pidstat.txt'
ON MASTER FORMAT 'text'(delimiter '~');

