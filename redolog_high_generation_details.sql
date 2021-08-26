How to Find Sessions Generating High Redo/Archives in Oracle
Source: http://nabhesh-joshi-oracledba.blogspot.com/2017/03/how-to-find-sessions-generating-high.html
-- Size, used, Reclaimable 

SELECT
  ROUND((A.SPACE_LIMIT / 1024 / 1024 / 1024), 2) AS FLASH_IN_GB, 
  ROUND((A.SPACE_USED / 1024 / 1024 / 1024), 2) AS FLASH_USED_IN_GB, 
  ROUND((A.SPACE_RECLAIMABLE / 1024 / 1024 / 1024), 2) AS FLASH_RECLAIMABLE_GB,
  SUM(B.PERCENT_SPACE_USED)  AS PERCENT_OF_SPACE_USED
FROM
  V$RECOVERY_FILE_DEST A,
  V$FLASH_RECOVERY_AREA_USAGE B
GROUP BY
  SPACE_LIMIT, 
  SPACE_USED , 
  SPACE_RECLAIMABLE ;



-- FRA Occupants
set pages 100
set lines 120
SELECT * FROM V$FLASH_RECOVERY_AREA_USAGE; 

-- Utilisation (MB) du FRA
set lines 100
col name format a60

select
   name,
  floor(space_limit / 1024 / 1024) "Size MB",
  ceil(space_used / 1024 / 1024) "Used MB"
from v$recovery_file_dest;


-- Location and size of the FRA
show parameter db_recovery_file_dest


===================Archivelog generation on a daily basis===============
set pages 1000
select trunc(COMPLETION_TIME,'DD') Day, thread#, round(sum(BLOCKS*BLOCK_SIZE)/1048576) MB,count(*) Archives_Generated from v$archived_log
group by trunc(COMPLETION_TIME,'DD'),thread# order by 1;


====================Archive log generation on an hourly basis====================
set pages 1000
select trunc(COMPLETION_TIME,'HH') Hour,thread# , round(sum(BLOCKS*BLOCK_SIZE)/1048576) MB,count(*) Archives from v$archived_log
group by trunc(COMPLETION_TIME,'HH'),thread#  order by 1 ;

==================== Show the Number of Redo Log Switches Per Hour ====================

SET PAUSE ON
SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300

SELECT to_char(first_time, 'yyyy - mm - dd') aday,
           to_char(first_time, 'hh24') hour,
           count(*) total
FROM   v$log_history
WHERE  thread#=&EnterThreadId
GROUP BY to_char(first_time, 'yyyy - mm - dd'),
              to_char(first_time, 'hh24')
ORDER BY to_char(first_time, 'yyyy - mm - dd'),
              to_char(first_time, 'hh24') asc
/



==================== script to list the history of log switches per hour over the last week ====================
SET PAGESIZE 90
SET LINESIZE 150
set heading on
column "00:00" format 9999
column "01:00" format 9999
column "02:00" format 9999
column "03:00" format 9999
column "04:00" format 9999
column "05:00" format 9999
column "06:00" format 9999
column "07:00" format 9999
column "08:00" format 9999
column "09:00" format 9999
column "10:00" format 9999
column "11:00" format 9999
column "12:00" format 9999
column "13:00" format 9999
column "14:00" format 9999
column "15:00" format 9999
column "16:00" format 9999
column "17:00" format 9999
column "18:00" format 9999
column "19:00" format 9999
column "20:00" format 9999
column "21:00" format 9999
column "22:00" format 9999
column "23:00" format 9999
SELECT * FROM (
SELECT * FROM (
SELECT TO_CHAR(FIRST_TIME, 'DD/MM') AS "DAY"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '00', 1, 0), '99')) "00:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '01', 1, 0), '99')) "01:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '02', 1, 0), '99')) "02:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '03', 1, 0), '99')) "03:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '04', 1, 0), '99')) "04:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '05', 1, 0), '99')) "05:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '06', 1, 0), '99')) "06:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '07', 1, 0), '99')) "07:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '08', 1, 0), '99')) "08:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '09', 1, 0), '99')) "09:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '10', 1, 0), '99')) "10:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '11', 1, 0), '99')) "11:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '12', 1, 0), '99')) "12:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '13', 1, 0), '99')) "13:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '14', 1, 0), '99')) "14:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '15', 1, 0), '99')) "15:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '16', 1, 0), '99')) "16:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '17', 1, 0), '99')) "17:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '18', 1, 0), '99')) "18:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '19', 1, 0), '99')) "19:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '20', 1, 0), '99')) "20:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '21', 1, 0), '99')) "21:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '22', 1, 0), '99')) "22:00"
, SUM(TO_NUMBER(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '23', 1, 0), '99')) "23:00"
    FROM V$LOG_HISTORY
       WHERE extract(year FROM FIRST_TIME) = extract(year FROM sysdate)
          GROUP BY TO_CHAR(FIRST_TIME, 'DD/MM')
  ) ORDER BY TO_DATE(extract(year FROM sysdate) || DAY, 'YYYY DD/MM') DESC
  ) WHERE ROWNUM <8;


================archivelog switches on an hourly basis that happened in the past one week===================
SELECT to_date(first_time) DAY,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'99') "00",
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'99') "01",
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'99') "02",
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'99') "03",
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'99') "04",
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'99') "05",
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'99') "06",
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'99') "07",
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'99') "08",
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'99') "09",
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'99') "10",
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'99') "11",
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'99') "12",
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'99') "13",
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'99') "14",
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'99') "15",
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'99') "16",
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'99') "17",
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'99') "18",
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'99') "19",
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'99') "20",
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'99') "21",
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'99') "22",
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'99') "23"
from
v$log_history
where to_date(first_time) > sysdate -30
GROUP by
to_char(first_time,'YYYY-MON-DD'), to_date(first_time)
order by to_date(first_time)
/

==================== list archived files not backed-up ====================
select NAME, ARCHIVED , deleted, status from v$archived_log where status='A';
####
RUN
{ 
ALLOCATE CHANNEL ch1 DEVICE TYPE DISK FORMAT  '/u02/export_dir/rman_arch/STATV10_archive%U';
ALLOCATE CHANNEL ch2 DEVICE TYPE DISK FORMAT '/u02/export_dir/rman_arch/STATV10_archive%U';
backup AS COMPRESSED BACKUPSET archivelog all delete input ;
}


###
==================== Recovery time for one archive log on standby ====================

set linesize 400
col Values for a65
col Recover_start for a21
select to_char(START_TIME,'dd.mm.yyyy hh24:mi:ss') "Recover_start",to_char(item)||' = '||to_char(sofar)||' '
||to_char(units)||' '|| to_char(TIMESTAMP,'dd.mm.yyyy hh24:mi') "Values" from v$recovery_progress where start_time=(select max(start_time)
from v$recovery_progress);


==================== List the sessions and the generated redo in MB if the session is still connected ====================
This was the query I used to use whenever I notice a huge archive log generation.


select s.username, s.osuser, s.status,s.sql_id,  sr.*  from 
  (select sid, round(value/1024/1024) as "RedoSize(MB)" 
          from v$statname sn, v$sesstat ss
          where sn.name = 'redo size'
                and ss.statistic# = sn.statistic#
          order by value desc) sr,
   v$session s
where sr.sid = s.sid
and   rownum <= 10;



==================== Find out which table / object has more number of changes during the problematic window ====================

1. 

SELECT to_char(begin_interval_time,'YYYY_MM_DD HH24:MI') snap_time,
        dhsso.object_name,
        sum(db_block_changes_delta) as maxchages
  FROM dba_hist_seg_stat dhss,
         dba_hist_seg_stat_obj dhsso,
         dba_hist_snapshot dhs
  WHERE dhs.snap_id = dhss.snap_id
    AND dhs.instance_number = dhss.instance_number
    AND dhss.obj# = dhsso.obj#
    AND dhss.dataobj# = dhsso.dataobj#
    AND begin_interval_time BETWEEN to_date('2013_05_22 17','YYYY_MM_DD HH24')
                                           AND to_date('2013_05_22 21','YYYY_MM_DD HH24')
  GROUP BY to_char(begin_interval_time,'YYYY_MM_DD HH24:MI'),
           dhsso.object_name order by maxchages asc;



==================== Tables has more number of changes ====================
2. 

SNAP_TIME        OBJECT_NAME                     MAXCHAGES
---------------- ------------------------------ ----------
2017_03_03 14:00 SIGNAL_MASCHINE                     10144
2017_03_03 13:00 SIGNAL_MASCHINE                     10240
2017_03_03 12:00 SIGNAL_MASCHINE                     11728
2017_03_03 15:00 SIGNAL_MASCHINE                     12000
2017_03_03 12:00 ICOL$                               24000
2017_03_03 14:00 I_COL1                              24096
2017_03_03 14:00 ICOL$                               24208
2017_03_03 14:00 I_COL3                              24240
2017_03_03 14:00 I_COL2                              24336
2017_03_03 12:00 I_COL2                              24352
2017_03_03 12:00 I_COL3                              24432
2017_03_03 12:00 I_COL1                              24576
2017_03_03 13:00 I_COL3                              27456
2017_03_03 13:00 I_COL1                              27792
2017_03_03 13:00 I_COL2                              27824
2017_03_03 13:00 ICOL$                               27936
2017_03_03 15:00 ICOL$                               31760
2017_03_03 15:00 I_COL1                              32864
2017_03_03 15:00 I_COL2                              32896
2017_03_03 15:00 I_COL3                              33616
2017_03_03 15:00 TPM_SCHICHT                        101328
2017_03_03 12:00 ALIVETIMER                       22931616
2017_03_03 13:00 ALIVETIMER                       23646176
2017_03_03 14:00 ALIVETIMER                       23965088
2017_03_03 15:00 ALIVETIMER                       25387744


==================== Once you know the objects ,get the SQL information realted to those objects ====================
3. 


SELECT to_char(begin_interval_time,'YYYY_MM_DD HH24:MI'),
         dbms_lob.substr(sql_text,4000,1),
         dhss.instance_number,
         dhss.sql_id,executions_delta,rows_processed_delta
  FROM dba_hist_sqlstat dhss,
         dba_hist_snapshot dhs,
         dba_hist_sqltext dhst
  WHERE upper(dhst.sql_text) LIKE '%TPM_SCHICHT%'
    AND dhss.snap_id=dhs.snap_id
    AND dhss.instance_Number=dhs.instance_number
 AND begin_interval_time BETWEEN to_date('2017_03_03 10','YYYY_MM_DD HH24')
                                           AND to_date('2017_03_03 16','YYYY_MM_DD HH24')
    AND dhss.sql_id = dhst.sql_id;


==================== Once you know the SQL ID Get the program and userid who is running it and intimate the user to take care of this query / Program ====================
4.

SELECT instance_number, to_char(sample_time,'yyyy_mm_dd hh24:mi:ss'),
         user_id,program  FROM dba_hist_active_sess_history WHERE sql_id in ('5xmfm787py0a3','bq28gpz5w5qqg','71t5d196acgr9','a8d5br4z9m251')
    AND snap_id BETWEEN 31856 AND 31860 ;


==================== This view contains the column BLOCK_CHANGES which indicates how much blocks have been changed by the session ====================

SELECT s.sid, s.serial#, s.username, s.program,i.block_changes FROM v$session s, v$sess_io i WHERE s.sid = i.sid ORDER BY 5 desc, 1, 2, 3, 4;


==================== Query V$TRANSACTION. This view contains information about the amount of undo blocks and undo records accessed by the transaction (as found in the USED_UBLK and USED_UREC columns)====================

SELECT s.sid, s.serial#, s.username, s.program, 
  t.used_ublk, t.used_urec
  FROM v$session s, v$transaction t
  WHERE s.taddr = t.addr
  ORDER BY 5 desc, 6 desc, 1, 2, 3, 4;


SELECT s.sid, s.serial#, s.username, s.program, 
  t.used_ublk, t.used_urec
  FROM v$session s, v$transaction t
  WHERE s.taddr = t.addr
  ORDER BY 5 desc, 6 desc, 1, 2, 3, 4;


select sql.sql_text sql_text, t.USED_UREC Records, t.USED_UBLK Blocks,
 (t.USED_UBLK*8192/1024) KBytes from v$transaction t,
 v$session s,
 v$sql sql
 where t.addr = s.taddr
 and s.sql_id = sql.sql_id
 and s.username ='&USERNAME';



==================== Sessions generating more redo or SQL queries generate heavy archive logs ====================
set lines 2000
set pages 1000
col sid for 99999
col name for a09
col username for a14
col PROGRAM for a21
col MODULE for a25
select s.sid,sn.SERIAL#,n.name, round(value/1024/1024,2) redo_mb, sn.username,sn.status,substr (sn.program,1,21) "program", sn.type, sn.module,sn.sql_id
from v$sesstat s join v$statname n on n.statistic# = s.statistic#
join v$session sn on sn.sid = s.sid where n.name like 'redo size' and s.value!=0 order by
redo_mb desc;