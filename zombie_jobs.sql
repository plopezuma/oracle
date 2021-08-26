SELECT 'kill -9 '||PROCESSES.spid AS LINUX_KILL,
       'ALTER SYSTEM KILL SESSION '||''''||SESSIONS.sid||','||SESSIONS.serial#||''''||' IMMEDIATE;' AS KILL_SESSION,       
       PROCESSES.spid,
       PROCESSES.username AS osuser,
       PROCESSES.program,
       SESSIONS.sid,
       SESSIONS.serial#,
       SESSIONS.username,
     --SESSIONS.sql_id,
       SESSIONS.logon_time,
     --SESSIONS.event,
       RUNNING_JOBS.job
     --PROCESSES.*,
     --SESSIONS.*,
     --RUNNING_JOBS.*
 FROM V$PROCESS PROCESSES, 
      V$SESSION SESSIONS,
      DBA_JOBS_RUNNING RUNNING_JOBS
  WHERE PROCESSES.program like '%J0%'
    AND PROCESSES.addr=SESSIONS.paddr
    AND SESSIONS.sid = RUNNING_JOBS.sid(+)
    AND SESSIONS.schemaname <> 'SYS'
    AND SESSIONS.type = 'USER'
    AND RUNNING_JOBS.job IS NULL
ORDER BY SESSIONS.SID;
