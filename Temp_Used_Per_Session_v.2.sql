column SID_SERIAL format a12
column USERNAME format a15
column OSUSER format a20
column SPID format a10
column MODULE format a30
column PROGRAM format a35
column TABLESPACE format a10
set linesize 200
set pagesize 500

SELECT   S.sid || ',' || S.serial# sid_serial,
           S.username,
           S.osuser,
           P.spid,
           S.module,
           P.program,
           S.sql_id,
           SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used,
           T.tablespace,
           COUNT ( * ) statements
    FROM   v$sort_usage T,
           v$session S,
           dba_tablespaces TBS,
           v$process P
   WHERE       T.session_addr = S.saddr
           AND S.paddr = P.addr
           AND T.tablespace = TBS.tablespace_name
GROUP BY   S.sid,
           S.serial#,
           S.username,
           S.osuser,
           P.spid,
           S.module,
           P.program,
           S.sql_id,
           TBS.block_size,
           T.tablespace
ORDER BY   8 DESC;



--------------------------



SELECT   S.sid || ',' || S.serial# sid_serial,
           S.username,
           S.osuser,
           P.spid,
           S.module,
           P.program,
           S.sql_id,
           Q.SQL_TEXT,
           SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used,
           T.tablespace,
           COUNT ( * ) statements
    FROM   v$sort_usage T,
           v$session S,
           dba_tablespaces TBS,
           v$process P,
           v$sql Q
   WHERE       T.session_addr = S.saddr
           AND S.paddr = P.addr
           AND T.tablespace = TBS.tablespace_name
           AND Q.SQL_ID = S.SQL_ID AND Q.HASH_VALUE=S.SQL_HASH_VALUE
GROUP BY   S.sid,
           S.serial#,
           S.username,
           S.osuser,
           P.spid,
           S.module,
           P.program,
           S.sql_id,
           Q.SQL_TEXT,
           TBS.block_size,
           T.tablespace
ORDER BY   8 DESC;
