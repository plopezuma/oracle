with candidate_to_partitions as (
select owner,table_name,num_rows 
from dba_tables where num_rows is not null and 
owner not in ('ANONYMOUS','APEX_040200','APEX_PUBLIC_USER','APPQOSSYS',
'AUDSYS','BI','CTXSYS','DBSNMP','DIP','DVF','DVSYS','EXFSYS','FLOWS_FILES',
'GSMADMIN_INTERNAL','GSMCATUSER','GSMUSER','HR','IX','LBACSYS','MDDATA',
'MDSYS','OE','ORACLE_OCM','ORDDATA','ORDPLUGINS','ORDSYS','OUTLN','PM',
'SCOTT','SH','SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR',
'SPATIAL_WFS_ADMIN_USR','SYS','SYSBACKUP','SYSDG','SYSKM','SYSTEM','WMSYS',
'XDB','SYSMAN','RMAN','RMAN_BACKUP') 
order by num_rows desc
)
Select * from candidate_to_partitions
where rownum <=50;
