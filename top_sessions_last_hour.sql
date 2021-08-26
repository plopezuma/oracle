-- Top Sessions for the past hour
SELECT s.sid, s.serial#, s.username, s.status, s.machine, s.osuser, logon_time, s.SQL_ID, round(p.PGA_USED_MEM/1024/1024,2) "PGA MB", st.value/100 as "CPU SEC"                                          
FROM v$sesstat st, v$statname sn, v$session s, v$process p                     
WHERE sn.name = 'CPU used by this session' -- CPU                                     
AND st.statistic# = sn.statistic#                     
AND st.sid = s.sid                     
AND s.paddr = p.addr                     
AND s.last_call_et < 3600           -- active within last 1 hour                                     
--AND s.logon_time > (SYSDATE - 1)    -- sessions logged during the past 24 hours                                     
ORDER BY st. value desc 

-- Point-in-time Top Active Sessions 
col cpu format 999990.99 heading "CPU Time"
col lpct format 990.99 heading "%Logi Reads"
col ppct format 990.99 heading "%Phys Reads"
select * from (
select s.sid,
       s.username,
       s.status,
       m.cpu,
       m.physical_reads physrd,
       m.logical_reads logrd,
       m.pga_memory,
       m.physical_read_pct ppct,
       m.logical_read_pct lpct
from   v$session s,
       v$sessmetric m
where  s.sid=m.session_id
and    username <> 'SYS'
and    s.status = 'ACTIVE'
order by cpu desc )
where  rownum < 11
/
