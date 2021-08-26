set pagesize 100
set linesize 150
column SID format 99999
column Serial# format 99999
column SPID format a7
column LOG_USER format a15
column JOB format 999999
column LAST_DATE format a30
column THIS_DATE format a30
column NEXT_DATE format a30
column WHAT format a30

SELECT /*+ rule */  J.SID,
S.SERIAL#,
S.SPID,
       J.LOG_USER,
       J.JOB,
       J.BROKEN,
       J.LAST_DATE || ' : ' ||J.LAST_SEC LAST_DATE,
       --J.THIS_DATE || ' : ' ||J.THIS_SEC THIS_DATE,
       J.NEXT_DATE || ' : ' ||J.NEXT_SEC NEXT_DATE,
       J.WHAT,
	   'ALTER SYSTEM KILL SESSION ''' || J.SID || ',' || S.SERIAL# || ''' IMMEDIATE;' KILLMESQL
FROM (SELECT DJR.SID, 
             DJ.LOG_USER, DJ.JOB, DJ.BROKEN, DJ.FAILURES, 
             DJ.LAST_DATE, DJ.LAST_SEC, DJ.THIS_DATE, DJ.THIS_SEC, 
             DJ.NEXT_DATE, DJ.NEXT_SEC, DJ.INTERVAL, DJ.WHAT
        FROM DBA_JOBS DJ, DBA_JOBS_RUNNING DJR
       WHERE DJ.JOB = DJR.JOB ) J,
     (SELECT P.SPID, S.SID, S.SERIAL#
          FROM V$PROCESS P, V$SESSION S
         WHERE P.ADDR  = S.PADDR ) S
WHERE J.SID = S.SID
ORDER BY NEXT_DATE
/

------------------------------------------------


select * from dba_scheduler_running_jobs;

select * from dba_scheduler_running_jobs where owner != 'SYS';


