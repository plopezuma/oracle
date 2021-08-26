select u.tablespace_name tablespace, s.username, u.status, sum(u.bytes)/1024/1024 sum_in_mb, count(u.segment_name) seg_cnts 
from dba_undo_extents u left join v$transaction t on u.segment_name = '_SYSSMU' || t.xidusn || '$' left join v$session s on t.addr = s.taddr 
group by u.tablespace_name, s.username, u.status order by 1,2,3;