-- Undotbs by session 
SELECT r.NAME "Undo Segment Name", dba_seg.size_mb,
DECODE(TRUNC(SYSDATE - LOGON_TIME), 0, NULL, TRUNC(SYSDATE - LOGON_TIME) || ' Days' || ' + ') || 
TO_CHAR(TO_DATE(TRUNC(MOD(SYSDATE-LOGON_TIME,1) * 86400), 'SSSSS'), 'HH24:MI:SS') LOGON, 
v$session.SID, v$session.SERIAL#, p.SPID, v$session.process,
v$session.USERNAME, v$session.STATUS, v$session.OSUSER, v$session.MACHINE, v$session.PROGRAM, v$session.module, action 
FROM v$lock l, v$process p, v$rollname r, v$session, 
(SELECT segment_name, ROUND(bytes/(1024*1024),2) size_mb FROM dba_segments WHERE segment_type = 'TYPE2 UNDO' ORDER BY bytes DESC) dba_seg 
WHERE l.SID = p.pid(+) AND 
v$session.SID = l.SID AND 
TRUNC (l.id1(+)/65536)=r.usn AND 
l.TYPE(+) = 'TX' AND 
l.lmode(+) = 6 
AND r.NAME = dba_seg.segment_name
--AND v$session.username = 'SYSTEM'
--AND status = 'INACTIVE'
ORDER BY size_mb DESC;

-- Undo segments status
select tablespace_name,status,count(*)
from dba_undo_extents
group by tablespace_name,status;

-- Space Usage Undotbs
select a.tablespace_name, SIZEMB, USAGEMB, (SIZEMB - USAGEMB) FREEMB
from (select sum(bytes) / 1024 / 1024 SIZEMB, b.tablespace_name
from dba_data_files a, dba_tablespaces b
where a.tablespace_name = b.tablespace_name
and b.contents = 'UNDO'
group by b.tablespace_name) a,
(select c.tablespace_name, sum(bytes) / 1024 / 1024 USAGEMB
from DBA_UNDO_EXTENTS c
where status <> 'EXPIRED'
group by c.tablespace_name) b
where a.tablespace_name = b.tablespace_name;

-- Undo advisor
SELECT 'Recommended undo tablespace size ' || dbms_undo_adv.required_undo_size(128) || ' MB' required_undo_size FROM dual;

-- Undo Info in one query
SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
       (TO_NUMBER(e.value) * TO_NUMBER(f.value) *
       g.undo_block_per_sec) / (1024*1024) 
      "NEEDED UNDO SIZE [MByte]"
  FROM (
       SELECT SUM(a.bytes) undo_size
         FROM v$datafile a,
              v$tablespace b,
              dba_tablespaces c
        WHERE c.contents = 'UNDO'
          AND c.status = 'ONLINE'
          AND b.name = c.tablespace_name
          AND a.ts# = b.ts#
       ) d,
      v$parameter e,
       v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
         undo_block_per_sec
         FROM v$undostat
       ) g
 WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size'
/