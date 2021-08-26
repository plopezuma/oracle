EXEC dbms_sqltune.create_sqlset('STS_d8a1j7fukjpqb');

DECLARE
  cur sys_refcursor;
BEGIN
open cur for
 select value(p) from table(dbms_sqltune.select_workload_repository(
      begin_snap => 10712,
      end_snap => 10808,
      basic_filter => 'sql_id IN (''fynd2qd60xpqh'') AND plan_hash_value = ''228980211''')) p;
    dbms_sqltune.load_sqlset(sqlset_name=>'STS_PL_RITM0349471', populate_cursor=>cur, load_option => 'MERGE', update_option => 'ACCUMULATE', sqlset_owner=>'SYS');
  close cur;
END;
/

DECLARE sqlset_cur dbms_sqltune.sqlset_cursor; 
BEGIN 
OPEN sqlset_cur FOR 
SELECT VALUE(P) FROM TABLE (DBMS_SQLTUNE.SELECT_CURSOR_CACHE('sql_id = ''d8a1j7fukjpqb'' AND plan_hash_value = ''2594988417''')) p;
DBMS_SQLTUNE.LOAD_SQLSET(SQLSET_NAME=> 'STS_d8a1j7fukjpqb', POPULATE_CURSOR=>sqlset_cur);
END;
/

SELECT PARSING_SCHEMA_NAME, SQL_ID, PLAN_HASH_VALUE FROM TABLE(DBMS_SQLTUNE.select_sqlset ('STS_d8a1j7fukjpqb'));


DECLARE
 my_plans PLS_INTEGER;
BEGIN
 my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(
   sqlset_name => 'STS_d8a1j7fukjpqb',
    fixed => 'YES');
END;
/

d8a1j7fukjpqb
2594988417

92m16n0kr8tpn

2594988417
3439090471