
-- this script creates two external tables in gpdb/hawq: one to read the master pg_log file, one to read the segment pg_log file

\i config.sql

DROP EXTERNAL TABLE if exists :scratch_schema.:segment_extl_pg_log_table;
CREATE EXTERNAL WEB TABLE :scratch_schema.:segment_extl_pg_log_table (
    logtime timestamp with time zone,
    loguser text,
    logdatabase text,
    logpid text,
    logthread text,
    loghost text,
    logport text,
    logsessiontime timestamp with time zone,
    logtransaction integer,
    logsession text,
    logcmdcount text,
    logsegment text,
    logslice text,
    logdistxact text,
    loglocalxact text,
    logsubxact text,
    logseverity text,
    logstate text,
    logmessage text,
    logdetail text,
    loghint text,
    logquery text,
    logquerypos integer,
    logcontext text,
    logdebug text,
    logcursorpos integer,
    logfunction text,
    logfile text,
    logline integer,
    logstack text
) EXECUTE :log_file
ON ALL FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"') ENCODING 'UTF8';
-- ALTER TABLE :scratch_schema.:segment_extl_pg_log_table owner to :scratch_owner;


DROP EXTERNAL TABLE if exists :scratch_schema.:master_extl_pg_log_table;
CREATE EXTERNAL WEB TABLE :scratch_schema.:master_extl_pg_log_table (
    logtime timestamp with time zone,
    loguser text,
    logdatabase text,
    logpid text,
    logthread text,
    loghost text,
    logport text,
    logsessiontime timestamp with time zone,
    logtransaction integer,
    logsession text,
    logcmdcount text,
    logsegment text,
    logslice text,
    logdistxact text,
    loglocalxact text,
    logsubxact text,
    logseverity text,
    logstate text,
    logmessage text,
    logdetail text,
    loghint text,
    logquery text,
    logquerypos integer,
    logcontext text,
    logdebug text,
    logcursorpos integer,
    logfunction text,
    logfile text,
    logline integer,
    logstack text
) EXECUTE :log_file
ON MASTER FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"') ENCODING 'UTF8';
-- ALTER TABLE :scratch_schema.:master_extl_pg_log_table owner to :scratch_owner;


DROP TABLE if exists :scratch_schema.:persistent_pg_log_table;
CREATE TABLE :scratch_schema.:persistent_pg_log_table (like :scratch_schema.:master_extl_pg_log_table) with (appendonly=true, compresstype=quicklz) distributed randomly;
ALTER TABLE :scratch_schema.:persistent_pg_log_table owner to :scratch_owner;
INSERT INTO :scratch_schema.:persistent_pg_log_table select * from :scratch_schema.:segment_extl_pg_log_table ;
INSERT INTO :scratch_schema.:persistent_pg_log_table select * from :scratch_schema.:master_extl_pg_log_table ;


