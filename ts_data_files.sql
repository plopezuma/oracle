-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/ts_datafiles.sql
-- Author       : Tim Hall
-- -----------------------------------------------------------------------------------

SET LINESIZE 200
COLUMN file_name FORMAT A70

SELECT file_id,
       file_name,
       ROUND(bytes/1024/1024/1024) AS size_gb,
       ROUND(maxbytes/1024/1024/1024) AS max_size_gb,
       autoextensible,
       increment_by,
       status
FROM   dba_data_files
WHERE  tablespace_name = UPPER('&1')
ORDER BY file_id;