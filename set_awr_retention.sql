SET SERVEROUTPUT ON;
declare
  vDBID number;
begin
  select dbid into vDBID from v$database;
  dbms_workload_repository.modify_snapshot_settings(retention=>64800, interval=>60, topnsql=>100, dbid=>vDBID);
  dbms_output.put_line(vDBID || ' successfully set');
end;
/

