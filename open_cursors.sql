-- Open cursors by session/SID
SELECT SUM( COUNT( * ) ) OVER (PARTITION BY oc.sid) AS sid_cursor_count,
       COUNT( * ) AS sql_cursor_count,
       oc.sid,
       ss.username,
       s.sql_text
  FROM v$sql s, v$open_cursor oc, v$session ss
WHERE oc.saddr = ss.saddr
   AND s.sql_id = oc.sql_id
   AND s.hash_value = oc.hash_value
   AND s.object_status = 'VALID'
   AND ss.username IS NOT NULL
GROUP BY oc.sid,
         s.sql_text,
         ss.username
ORDER BY sid_cursor_count DESC,
         sql_cursor_count DESC,
         oc.sid,
         s.sql_text;

-- Open cursors for a specific session/SID    
-- Replace :SID as needed     
SELECT OC.saddr, 
       OC.SID, 
       S.*, 
       SS.* 
FROM v$sql         S, 
     v$open_cursor OC, 
     v$session     SS 
WHERE SS.SID = :SID 
  AND OC.saddr = SS.saddr 
  AND S.sql_id = OC.sql_id 
  AND S.hash_value = OC.hash_value 
  AND S.object_status = 'VALID';
  
-- Open cursors by SQL_ID
WITH
    multi AS (
             SELECT SID,
                    sql_id,
                    COUNT(*) AS num_open
             FROM v$open_cursor
             WHERE 1=1
             --AND user_name = 'OMUSER'
            GROUP BY SID,
                      sql_id
             HAVING COUNT(*) > 1
             )
SELECT M.*,
       SS.program,
       SS.last_call_et AS since_last_call,
       S.sql_fulltext,
       S.*
FROM multi      M,
     v$sql      S,
     V$session  SS
WHERE S.sql_id = M.sql_id
  AND ss.SID   = M.SID
  AND NVL(S.parsing_schema_name,'?') != 'SYS'
ORDER BY M.num_open DESC
;
