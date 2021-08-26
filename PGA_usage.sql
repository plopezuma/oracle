-- Summary 

-- To find the total PGA memory used by processes

SELECT ROUND(SUM(pga_used_mem)/(1024*1024),2) PGA_USED_MB FROM v$process;


-- Every session takes something from the PGA memory 

SELECT DECODE(TRUNC(SYSDATE - LOGON_TIME), 0, NULL, TRUNC(SYSDATE - LOGON_TIME) || ' Days' || ' + ') || 
TO_CHAR(TO_DATE(TRUNC(MOD(SYSDATE-LOGON_TIME,1) * 86400), 'SSSSS'), 'HH24:MI:SS') LOGON, 
SID, v$session.SERIAL#, v$process.SPID , ROUND(v$process.pga_used_mem/(1024*1024), 2) PGA_MB_USED, 
v$session.USERNAME, STATUS, OSUSER, MACHINE, v$session.PROGRAM, MODULE 
FROM v$session, v$process 
WHERE v$session.paddr = v$process.addr 
--and status = 'ACTIVE' 
--and v$session.sid = 97
--and v$session.username = 'SYSTEM' 
--and v$process.spid = 24301
ORDER BY pga_used_mem DESC;


-- To find PGA usage for a specific session

SELECT SID, b.NAME, ROUND(a.VALUE/(1024*1024),2) MB FROM 
v$sesstat a,  v$statname b
WHERE (NAME LIKE '%session uga memory%' OR NAME LIKE '%session pga memory%')
AND a.statistic# = b.statistic# 
AND SID = 80;

-- To calculate the amount of memory that you gone need for PGA, estimate the number of maximum connected sessions and run:
SELECT :MAX_CONNECTED_SESSIONS*(2048576+P1.VALUE+P2.VALUE)/(1024*1024) YOU_NEED_PGA_MB 
FROM V$PARAMETER P1, V$PARAMETER P2
WHERE P1.NAME = 'sort_area_size'
AND P2.NAME = 'hash_area_size';



-- To change PGA memory parameter

-- ALTER SYSTEM SET pga_aggregate_target = 3500M SCOPE=BOTH;