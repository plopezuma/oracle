SELECT s.sid, username, program, module, action, logon_time, l.* 
FROM v$session s, v$enqueue_lock l
WHERE l.sid = s.sid and l.type = 'CF' AND l.id1 = 0 and l.id2 = 2;
